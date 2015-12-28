//
//  ViewController.m
//  ZHXMPP
//
//  Created by 张行 on 15/11/20.
//  Copyright © 2015年 张行. All rights reserved.
//

#import "ViewController.h"
#import "ZHXMPP.h"
#import "FriendListViewController.h"
#import "ZHTabBarController.h"
#import "UIButton_ButtonName.h"
#import "ViewController+VCName.h"
NSString * const LoginUserName = @"LoginUserName";
NSString * const LoginPassWord = @"LoginPassWord";

@interface ViewController ()
@property (nonatomic, strong) ZHXMPP *xmpp;

#pragma mark - IBOutlet
@property (weak, nonatomic) IBOutlet UITextField *userNameTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFiled;

@end

@implementation ViewController{
    
    

}

-(instancetype)initWithName:(NSString *)name error:(NSError *__autoreleasing *)error {

    if (!name) {
        *error = [NSError errorWithDomain:@"名字不能为空" code:-1 userInfo:nil];
        return nil;
    }else {
    
        return [super init];
    }
    

}

- (IBAction)loginButtonClick:(id)sender {
    
    if (self.userNameTextFiled.text.length == 0) {
        [ZHCommon showErrorMessage:@"用户名不能为空"];
    }else if (self.passwordTextFiled.text.length == 0){
        [ZHCommon showErrorMessage:@"密码不能为空" ];
    }
    __weak typeof(self) weakSelf=self;
    [self.xmpp loginUserName:self.userNameTextFiled.text passWord:self.passwordTextFiled.text complete:^(BOOL isSuccess, DDXMLElement *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (isSuccess) {
            [ZHCommon showSuccessMessage:@"登录成功"];
            [strongSelf gotoFriendListController];
        }else {
        
            [ZHCommon showErrorMessage:@"登录失败" ];

            
        }
        
    }];
    
}
- (IBAction)regiserButtonClick:(id)sender {
}
- (ZHXMPP *)xmpp
{
    if (!_xmpp) {
        _xmpp = [ZHXMPP xmpp];
        _xmpp.xmppHost = @"xmpp.com";
        [_xmpp steup];
    }
    return _xmpp;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [TSMessage setDefaultViewController:self.navigationController];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *userName = [userDefault objectForKey:LoginUserName];
    NSString *passWord = [userDefault objectForKey:LoginPassWord];
    if (userName) {
        self.userNameTextFiled.text = userName;
    }
    if (passWord) {
        self.passwordTextFiled.text = passWord;
    }
    
    self.VCName = @"12431523";
    NSLog(@"%@",self.VCName);
    
    
}
-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden= NO;
}
-(void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
   // self.navigationController.navigationBarHidden = YES;
}
- (void)gotoFriendListController {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:self.userNameTextFiled.text forKey:LoginUserName];
    [userDefault setObject:self.passwordTextFiled.text forKey:LoginPassWord];
    [userDefault synchronize];
    
    ZHTabBarController *controller = [[ZHTabBarController alloc]init];
    controller.baseNavigationController = self.navigationController;
    
    [UIApplication sharedApplication].keyWindow.rootViewController = controller;
}

@end

@implementation ViewController (Name)

-(void)setViewControllerName:(NSString *)viewControllerName {

    _buttonName = viewControllerName;
}
-(NSString *)viewControllerName {

    return _buttonName;
}

@end
