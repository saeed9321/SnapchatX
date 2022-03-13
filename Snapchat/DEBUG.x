#include "Include/DEBUG.h"

void DEBUG(DEBUG_STATE state, NSString *format, ...){
    NSMutableString *logHead =[[NSMutableString alloc] initWithString:@"SnapchatX::"];
    if(state == 1){
        logHead = (NSMutableString *)[logHead stringByAppendingString:@"👀 "];
    }
    if(state == 2){
        logHead = (NSMutableString *)[logHead stringByAppendingString:@"✅ "];
    }
    if(state == 3){
        logHead = (NSMutableString *)[logHead stringByAppendingString:@"❌ "];
    }
  
    va_list args;
    va_start(args, format);
    NSString *logString = [[NSString alloc] initWithFormat:format arguments:args];
    logHead = (NSMutableString *)[logHead stringByAppendingString:logString];
    NSLog(@"%@", logHead);
    va_end(args);   
}
