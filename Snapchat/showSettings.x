#include "Include/showSettings.h"
#import "Controllers/SettingsViewController.h"
#include "Include/DEBUG.h"

@interface SIGLegacyContainerViewController : UIViewController
- (void)listSubviewsOfViewAndAddSettingsIcon:(UIView *)view;
- (void)showSettings;
@end


static UIView *settingsView;


%group SettingsButton
    %hook SIGLegacyContainerViewController

        -(void)viewDidAppear:(BOOL)animated{
            %orig;
            [self listSubviewsOfViewAndAddSettingsIcon:self.view];
        }
        %new
        -(void)listSubviewsOfViewAndAddSettingsIcon:(UIView *)view {
            NSArray *subviews = [view subviews];
            for(UIView *subview in subviews) {
                NSString *className = NSStringFromClass([subview class]);

                if ([className isEqualToString:@"SIGHeaderTitleRow"]){
                    for(UIView *btnView in subview.subviews){
                        if([NSStringFromClass([btnView class]) isEqualToString:@"SIGHeaderButtonGroup"]){
                            if(btnView.frame.origin.x < 50){
                                settingsView = [[UIView alloc] initWithFrame:CGRectMake(btnView.frame.origin.x+btnView.frame.size.width+8, btnView.frame.origin.y, (btnView.frame.size.width-4)/2, btnView.frame.size.height)]; 
                                [settingsView setBackgroundColor:[UIColor yellowColor]];
                                [settingsView.layer setCornerRadius:settingsView.frame.size.width/2];
                                [settingsView setClipsToBounds:YES];
                                if(subview.subviews.count < 4){
                                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSettings)];
                                    [settingsView addGestureRecognizer:tap];
                                    [subview addSubview:settingsView];
                                }
                            }
                        }
                    }
                    // DEBUG(INFO, @"sub: %@ = %@", subview, subview.subviews);
                    
                    return;
                    
                }
                [self listSubviewsOfViewAndAddSettingsIcon:subview];
            }
        }
        %new
        -(void)showSettings{
            SettingsViewController *vc = [[SettingsViewController alloc] init];
            [self.navigationController.visibleViewController presentViewController:vc animated:YES completion:nil];
        }
    
    %end
%end





void show_settings_button(){
    %init(SettingsButton);
}