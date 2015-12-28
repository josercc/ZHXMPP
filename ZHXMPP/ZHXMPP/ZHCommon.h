//
//  ZHCommon.h
//  ZHXMPP
//
//  Created by 张行 on 15/11/20.
//  Copyright © 2015年 张行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHCommon : NSObject
+ (void)showSuccessMessage:(NSString *)message;
+ (void)showErrorMessage:(NSString *)message;
+ (void)showWarningMessage:(NSString *)message;

+ (UIViewController *)storyboardClass:(Class)className;

+ (void)addNavigationRightButtonTitle:(NSString *)title withController:(UIViewController *)controller action:(SEL)action;
@end
