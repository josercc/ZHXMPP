//
//  RegiserViewController.m
//  ZHXMPP
//
//  Created by 张行 on 15/11/20.
//  Copyright © 2015年 张行. All rights reserved.
//

#import "RegiserViewController.h"
#import "ZHXMPP.h"
@interface RegiserViewController ()
#pragma mark - XIB
@property (weak, nonatomic) IBOutlet UITextField *usernameTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFiled;

@end

@implementation RegiserViewController
- (IBAction)regiserButtonClick:(id)sender {
    
    if (self.usernameTextFiled.text.length == 0) {
        
        [ZHCommon showErrorMessage:@"用户名不能为空" ];
        
    }else if (self.passwordTextFiled.text.length == 0){
    
        [ZHCommon showErrorMessage:@"密码不能为空" ];
    }
    
    [[ZHXMPP xmpp] regiserUserName:self.usernameTextFiled.text passWord:self.passwordTextFiled.text complete:^(BOOL isSuccess, DDXMLElement *error) {
       
        if (isSuccess) {
            [ZHCommon showSuccessMessage:@"注册成功" ];

        }else {
        
            [ZHCommon showErrorMessage:@"注册失败" ];

            NSLog(@"%@",error);
        }
    }];
    
}

@end
