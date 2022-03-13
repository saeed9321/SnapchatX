#include "Include/welcome.h"

@interface SIGAlertDialog : UIViewController
+(id)_alertWithTitle:(id)arg1 description:(id)arg2 ;
@end


BOOL isCompatibleVersion = YES;
BOOL alreadyShown = NO;
NSString *msg = nil;

%group welcomeCheck
    %hook UIViewController 
        - (void)viewDidAppear:(BOOL)animated{ 
            %orig;
            if(!alreadyShown){
                alreadyShown = YES;
                
                NSString *title = @"SnapchatX is running 😈";
                NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                
                // Version check if needed
                if(![version isEqualToString:@"11.65.0"]){
                    title = @"This version is not compatible 🥲";
                    msg = @"Please make sure your version is 11.65.0";
                    isCompatibleVersion = NO;
                }

                SIGAlertDialog *alertController = [%c(SIGAlertDialog) _alertWithTitle:title description:msg];

                [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if(!isCompatibleVersion){
                            exit(0);
                        }
                    });
                }];
            }
        }
    %end
%end

void load_welcome_check(char *s){
    msg = [NSString stringWithUTF8String:s];
    %init(welcomeCheck);
}