//
//  ZHTabBarController.m
//  ZHXMPP
//
//  Created by 张行 on 15/11/23.
//  Copyright © 2015年 张行. All rights reserved.
//

#import "ZHTabBarController.h"
#import "FriendListViewController.h"
#import "MessageListViewController.h"
@interface ZHTabBarController ()

@end

@implementation ZHTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    FriendListViewController *VC1 = (FriendListViewController *)[ZHCommon storyboardClass:[FriendListViewController class]];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:VC1];
    nav1.tabBarItem.title = @"好友";
    MessageListViewController *VC2 = (MessageListViewController *)[ZHCommon storyboardClass:[MessageListViewController class]];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:VC2];
    nav1.tabBarItem.title = @"好友";
    nav2.tabBarItem.title = @"消息";
    self.viewControllers = @[nav1,nav2];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
