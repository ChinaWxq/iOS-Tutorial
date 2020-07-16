//
//  ViewController.m
//  RACSignIn
//
//  Created by wuxueqian on 2020/7/14.
//  Copyright © 2020 wuxueqian. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SignInService.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (strong, nonatomic) SignInService *signInService;

@property (weak, nonatomic) IBOutlet UILabel *signInFailureLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.signInService = [SignInService new];
    
    self.signInFailureLabel.hidden = YES;
    
    // text map -> NSNumber
    RACSignal *usernameSignal = [self.usernameTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidUsername:text]);
    }];
    
    RACSignal *passwordSignal = [self.passwordTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidPassword:text]);
    }];
    
    
    // NSNumber map -> UIColor
    // RAC宏语法
    RAC(self.usernameTextField, backgroundColor) = [usernameSignal map:^id(NSNumber *usernameValid) {
        return [usernameValid boolValue] ? [UIColor whiteColor] : [UIColor lightGrayColor];
    }];
    
    RAC(self.passwordTextField, backgroundColor) = [passwordSignal map:^id(NSNumber *passwordValid) {
        return [passwordValid boolValue] ? [UIColor whiteColor] : [UIColor lightGrayColor];
    }];
    
    // NSNumber combine -> NSNumber
    RACSignal *combineSignal = [RACSignal combineLatest:@[usernameSignal, passwordSignal] reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid) {
        return @([usernameValid boolValue] && [passwordValid boolValue]);
    }];
    // 按钮与文本框合法的绑定
    [combineSignal subscribeNext:^(NSNumber *signInActive) {
        self.signInButton.enabled = [signInActive boolValue];
    }];
    
    [[[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside]
       // 添加附加操作，触发按钮点击事件之后，恢复原状
      doNext:^(id x) {
        self.signInButton.enabled = NO;
        self.signInFailureLabel.hidden = YES;
    }]
      flattenMap:^id(id value) {
        return [self signInSignal];
    }] subscribeNext:^(NSNumber *signIn) {
        BOOL success = [signIn boolValue];
        self.signInButton.enabled = YES;
        self.signInFailureLabel.hidden = success;
        if (success) {
            [self performSegueWithIdentifier:@"signInSuccess" sender:self];
        }
    }];
}

- (BOOL)isValidUsername:(NSString *)userName {
    return userName.length >= 4;
}

- (BOOL)isValidPassword:(NSString *)password {
    return password.length >= 6;
}

- (RACSignal *)signInSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.signInService signInWithUsername:self.usernameTextField.text
                                      password:self.passwordTextField.text
                                      complete:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

@end
