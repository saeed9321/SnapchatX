#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SnapchatXPrefs : NSObject

@property (strong, nonatomic) NSMutableDictionary *prefDict;
@property (strong, nonatomic) NSString *prefPath;

+(instancetype)shared;

-(void)reloadPrefs;
-(void)updatePref:(NSString *)key withValue:(BOOL)value;
-(BOOL)isSaveMediaEnabled;
-(BOOL)isLoopMediaEnabled;
-(BOOL)isDisableScreenshot;
-(BOOL)isDisableTyping;
-(BOOL)isDisableReadReceipt;

@end

NS_ASSUME_NONNULL_END
