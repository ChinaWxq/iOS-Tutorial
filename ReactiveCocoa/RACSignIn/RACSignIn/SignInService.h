//
//  SignInService.h
//  RACSignIn
//
//  Created by wuxueqian on 2020/7/14.
//  Copyright © 2020 wuxueqian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SignInResponse)(BOOL);

@interface SignInService : NSObject

///  登录验证
/// @param username 用户名
/// @param password 密码
/// @param completeBlock 完成闭包
- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(SignInResponse)completeBlock;

@end

NS_ASSUME_NONNULL_END
