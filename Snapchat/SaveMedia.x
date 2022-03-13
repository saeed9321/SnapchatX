#include "Include/SaveMedia.h"
#include "Include/DEBUG.h"
#include "Controllers/SnapchatXPrefs.h"
#import <AVFoundation/AVFoundation.h>


@interface SCOperaImageLayerViewController : UIViewController
@end

@interface SCOperaVideoLayerViewController : UIViewController
-(void)_startPlayingItem:(id)arg1;
@end

@interface SCOperaSnapPlaybackPerformanceData : NSObject
-(void)setMediaType:(long long)arg1 ;
@end

@interface SCOperaPageViewController : UIViewController
-(void)saveButtonPressed;
-(void)saveImage:(UIView *)view;
-(void)saveVideo:(AVURLAsset *)videoAsset;
-(void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
@end



// Global Var
static UIView *viewForImage = nil;
static AVURLAsset *assetForVideo = nil;
static UIButton *downloadBtn = nil;
static BOOL newSnap = YES;
static long long mediaType = -1;
static NSURL *tempVideoURL = nil;



%group saveMedia

	%hook SCOperaSnapPlaybackPerformanceData
		// Check Media Type
		-(void)setMediaType:(long long)arg1{
			mediaType = arg1;
			newSnap = YES;
			// DEBUG(INFO, @"Showing %@", mediaType == 1 ? @"🎥 Video" : @"🌄 Image");
			%orig;
		}
	%end

	%hook SCOperaPageViewController
	
		// Show download button
		-(void)viewDidAppear:(BOOL)animated{
			%orig;
						
			if(![[SnapchatXPrefs shared] isSaveMediaEnabled]){
				if([self.view.subviews containsObject:downloadBtn]){
					[downloadBtn removeFromSuperview];
				}
				return;
			}
			
			if(![self.view.subviews containsObject:downloadBtn]){
				float width = self.view.frame.size.width;
				float height = self.view.frame.size.height;
				
				downloadBtn = [[UIButton alloc] init];
				CGRect downloadBtn_frame = CGRectMake(width-65, height-85, 60, 35);
				[downloadBtn setFrame:downloadBtn_frame];
				
				UIImage *img = [UIImage imageWithContentsOfFile:@"Library/Application Support/snapchatx/download-icon.png"];	
				
				[downloadBtn setBackgroundImage:img forState:normal];
				[downloadBtn.layer setCornerRadius:downloadBtn.frame.size.height/2];
				[downloadBtn setClipsToBounds:YES];
				[downloadBtn setAlpha:0.8];
				[downloadBtn addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchDown];

				[self.view addSubview:downloadBtn]; // add button to view
			}
		}
		
		// update viewForImage
		-(id)_layerVCsOnPage{
			
			if(newSnap == NO){
				return %orig;
			}
			
			if(mediaType == 2){
				NSArray *layerList = (NSArray *)%orig;	
				for(int i=0; i<layerList.count; i++){
					NSString *className = NSStringFromClass([[layerList objectAtIndex:i] class]);
					if([className isEqualToString:@"SCOperaImageLayerViewController"]){
						SCOperaImageLayerViewController *vc = (SCOperaImageLayerViewController*)[layerList objectAtIndex:i];
						viewForImage = vc.view;
						newSnap = NO;
						// DEBUG(INFO, @"Saved current image temp");
						break;
					}
				}
			}
			return %orig;
		}
		
		%new // handle download button pressed
		-(void)saveButtonPressed{
			if(mediaType == 1){ // Video
				[self saveVideo:assetForVideo];
			}else{ // Image
				[self saveImage:viewForImage];
			}
		}
		
		%new // handle image save
		-(void)saveImage:(UIView *)view{
			if(view) {
				// Convert UIView to UIImage
				UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
				[view.layer renderInContext:UIGraphicsGetCurrentContext()];
				UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
				UIGraphicsEndImageContext();
				
				// Image saving
				DEBUG(SUCCESS, @"IMAGE SAVED TO CAMERA ROLL");
				UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
				
				// Show UIAlert "Screenshot Saved"
				UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Screenshot Saved" preferredStyle:UIAlertControllerStyleAlert];
				[self presentViewController:alert animated:YES completion:nil];
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					[alert dismissViewControllerAnimated:YES completion:nil]; // Hide Alert ... 0.8s
				});
			}else{
				// Show UIAlert "Error: no image found"
				UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Error: no image found" preferredStyle:UIAlertControllerStyleAlert];
				[self presentViewController:alert animated:YES completion:nil];
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					[alert dismissViewControllerAnimated:YES completion:nil]; // Hide Alert ... 0.6s
				});
			}
		}
		
		%new // handle video save
		-(void)saveVideo:(AVURLAsset *)videoAsset{
			if(videoAsset){
				// Prepare temp video path
				NSURL *tmpDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
				NSURL *fileURL = [tmpDirURL URLByAppendingPathComponent:[NSString stringWithFormat:@"video123"]];
				NSURL *newFileURL = [fileURL URLByAppendingPathExtension:@"mp4"];

				// Configure export session
				AVAssetExportSession *export = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:AVAssetExportPresetHighestQuality];

				// video saving
				__block NSData *assetData = nil;
				[export setOutputURL:newFileURL];
				[export setOutputFileType:AVFileTypeQuickTimeMovie];
				[export exportAsynchronouslyWithCompletionHandler:^{
					tempVideoURL = newFileURL;
					assetData = [NSData dataWithContentsOfURL:newFileURL];					
					UISaveVideoAtPathToSavedPhotosAlbum([newFileURL.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
				}];
				
				// Show UIAlert "Video Saved"
				UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Video Saved" preferredStyle:UIAlertControllerStyleAlert];
				[self presentViewController:alert animated:YES completion:nil];
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					[alert dismissViewControllerAnimated:YES completion:nil]; // Hide Alert ... 0.8s
				});
			}else{
				// Show UIAlert "Error: no video found"
				UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Error: no video found" preferredStyle:UIAlertControllerStyleAlert];
				[self presentViewController:alert animated:YES completion:nil];
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					[alert dismissViewControllerAnimated:YES completion:nil]; // Hide Alert ... 0.6s
				});
			}
		}
		
		%new // clear tmp video cache
		- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
			DEBUG(SUCCESS, @"VIDEO SAVED TO CAMERA ROLL");
			[[NSFileManager defaultManager] removeItemAtURL:tempVideoURL error:nil];
		}
		
	%end

	%hook SCOperaVideoLayerViewController
		// update assetForVideo
		-(void)_startPlayingItem:(id)arg1{
			AVPlayerItem *player = (AVPlayerItem *)arg1;
			AVURLAsset *asset = (AVURLAsset *)player.asset;
			assetForVideo = asset;
			tempVideoURL = asset.URL;
			newSnap = NO;
			%orig;
		}
	%end
%end







void enable_media_save(){
    %init(saveMedia);
}