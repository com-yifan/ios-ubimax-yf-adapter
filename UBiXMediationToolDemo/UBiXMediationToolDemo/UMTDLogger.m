//
//  UMTDLogger.m
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/8/12.
//

#import "UMTDLogger.h"

void UMTDLog(NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    NSLog(@"[UMT-Demo] %@", message);
}

@implementation UMTDLogger



@end
