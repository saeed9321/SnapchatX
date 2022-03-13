#include "Include/Extra.h"
#include "Include/DEBUG.h"
#include "Controllers/SnapchatXPrefs.h"


// Hide typing status
%group hideTypingStatus
	%hook SCChatViewControllerV3
		- (void)_updateChatTypingStateWithState:(id)arg1{
			if([[SnapchatXPrefs shared] isDisableTyping]){
				arg1 = @"typing_delete";
			}
			%orig;
		}
	%end
%end

// Loop videos
%group videoLoopForEver
	%hook SCOperaVideoLayerViewController
		-(BOOL)_shouldLoopWhenReachEnd{
			if([[SnapchatXPrefs shared] isLoopMediaEnabled]){
				return YES;
			}
			return %orig;
		}
	%end
%end

// No read receipt
%group NoReadReceipt
	%hook SCChatMessageReleaser
		- (void)_markMessagesAsReadForConversationId:(id)arg1 conversationViewModel:(id)arg2{
			// DEBUG(INFO, @"_markMessagesAsReadForConversationId: %@ - to %@", arg1, arg2);
			if([[SnapchatXPrefs shared] isDisableReadReceipt]){
				return;
			}
			%orig;
		}
	%end
%end

// Disable screenshot detection
%group disableScreenshotDetection
	%hook NSNotificationCenter
		- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject{
			// DEBUG(INFO, @"NSNotificationCenter: name-> %@", aName);
			if([aName isEqual:@"UIApplicationUserDidTakeScreenshotNotification"] || [aName isEqual:@"SCUserDidScreenRecordContentNotification"]){
				   if([[SnapchatXPrefs shared] isDisableReadReceipt]){
					   return;
				   }
			   }
			return %orig;
		}
	%end
%end




void enable_media_loop(){
    %init(videoLoopForEver);
}
void enable_stop_typing_status(){
	%init(hideTypingStatus);
}
void enable_no_read_receipt(){
	%init(NoReadReceipt);
}
void enable_no_screenshot(){
	%init(disableScreenshotDetection);
}