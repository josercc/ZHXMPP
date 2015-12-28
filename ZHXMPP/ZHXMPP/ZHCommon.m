//
//  ZHCommon.m
//  ZHXMPP
//
//  Created by 张行 on 15/11/20.
//  Copyright © 2015年 张行. All rights reserved.
//

#import "ZHCommon.h"

@implementation ZHCommon
+(void)showMessage:(NSString *)message type:(TSMessageNotificationType)type {

    return [TSMessage showNotificationInViewController:[TSMessage defaultViewController]
                                                 title:message
                                              subtitle:nil
                                                  type:type
                                              duration:1.5];
}
+(void)showErrorMessage:(NSString *)message {

    [ZHCommon showMessage:message type:TSMessageNotificationTypeError];
}
+(void)showSuccessMessage:(NSString *)message {

    [ZHCommon showMessage:message type:TSMessageNotificationTypeSuccess];
    
}
+ (void)showWarningMessage:(NSString *)message {
    [ZHCommon showMessage:message type:TSMessageNotificationTypeWarning];
}

+(UIViewController *)storyboardClass:(Class)className {
    NSString *stringName = [NSString stringWithFormat:@"%@",className];
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:stringName];
}

+(void)addNavigationRightButtonTitle:(NSString *)title withController:(UIViewController *)controller action:(SEL)action{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(0, 0, 44, 44);
    controller.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    [button addTarget:controller action:action forControlEvents:UIControlEventTouchUpInside];
    
    
}
@end
