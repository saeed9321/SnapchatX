#import "SnapchatXPrefs.h"

static BOOL saveMediaEnabled = NO;
static BOOL loopMediaEnabled = NO;
static BOOL disableScreenshot = NO;
static BOOL disableTyping = NO;
static BOOL disableReadReceipt = NO;

@implementation SnapchatXPrefs

+(instancetype)shared{
    static SnapchatXPrefs *shared = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shared = [[SnapchatXPrefs alloc] init];
    });
    return shared;
}

-(void)reloadPrefs{
    // save plist into the app data/Documents folder
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    self.prefPath = [documentDirectory stringByAppendingPathComponent:@"snapchatx.plist"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:self.prefPath]){
        self.prefDict = [[NSMutableDictionary alloc]initWithContentsOfFile:self.prefPath];
        saveMediaEnabled = [[self.prefDict valueForKey:@"saveMediaEnabled"] boolValue];
        loopMediaEnabled = [[self.prefDict valueForKey:@"loopMediaEnabled"] boolValue];
        disableScreenshot = [[self.prefDict valueForKey:@"disableScreenshot"] boolValue];
        disableTyping = [[self.prefDict valueForKey:@"disableTyping"] boolValue];
        disableReadReceipt = [[self.prefDict valueForKey:@"disableReadReceipt"] boolValue];
    }else{
        self.prefDict = [[NSMutableDictionary alloc]init];
        [self.prefDict setObject:[NSString stringWithFormat:@"%d", saveMediaEnabled] forKey:@"saveMediaEnabled"];
        [self.prefDict setObject:[NSString stringWithFormat:@"%d", loopMediaEnabled] forKey:@"loopMediaEnabled"];
        [self.prefDict setObject:[NSString stringWithFormat:@"%d", disableScreenshot] forKey:@"disableScreenshot"];
        [self.prefDict setObject:[NSString stringWithFormat:@"%d", disableTyping] forKey:@"disableTyping"];
        [self.prefDict setObject:[NSString stringWithFormat:@"%d", disableReadReceipt] forKey:@"disableReadReceipt"];
    }
}

-(void)updatePref:(NSString *)key withValue:(BOOL)value{
    [self.prefDict setValue:[NSString stringWithFormat:@"%d", value] forKey:key];
    [self.prefDict writeToFile:self.prefPath atomically:YES];
}

-(BOOL)isSaveMediaEnabled{
    [self reloadPrefs];
    return saveMediaEnabled;
}
-(BOOL)isLoopMediaEnabled{
    [self reloadPrefs];
    return loopMediaEnabled;
}
-(BOOL)isDisableScreenshot{
    [self reloadPrefs];
    return disableScreenshot;
}
-(BOOL)isDisableTyping{
    [self reloadPrefs];
    return disableTyping;
}
-(BOOL)isDisableReadReceipt{
    [self reloadPrefs];
    return disableReadReceipt;
}


@end
