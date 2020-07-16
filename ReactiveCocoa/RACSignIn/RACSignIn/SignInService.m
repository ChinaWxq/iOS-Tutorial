//
//  SignInService.m
//  RACSignIn
//
//  Created by wuxueqian on 2020/7/14.
//  Copyright © 2020 wuxueqian. All rights reserved.
//

#import "SignInService.h"

@implementation SignInService

- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(SignInResponse)completeBlock {
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    // gcd 延迟执行
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        BOOL success = [username isEqualToString:@"root"] && [password isEqualToString:@"123456"];
        completeBlock(success);
    });
}

@end
