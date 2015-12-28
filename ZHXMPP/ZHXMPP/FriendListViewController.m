//
//  FriendListViewController.m
//  ZHXMPP
//
//  Created by joser on 15/11/21.
//  Copyright © 2015年 张行. All rights reserved.
//

#import "FriendListViewController.h"
#import "ZHXMPP.h"
#import "ZHTabBarController.h"
#import "MessageChatTableViewController.h"
@interface FriendListViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *friendListTableView;

@property (nonatomic, strong) NSMutableArray * friendList;

@end

@implementation FriendListViewController


- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.title = @"好友列表";
    __weak typeof(self) weakSelf= self;
    [ZHXMPP xmpp].didReciverFriendListComplete = ^(NSArray<XMPPJID *> *array){
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.friendList) {
            [strongSelf.friendList removeAllObjects];
        }else {
            strongSelf.friendList = [NSMutableArray array];
        }
        [strongSelf.friendList addObjectsFromArray:array];
        [strongSelf.friendListTableView reloadData];
    };
    
    [[ZHXMPP xmpp]getFrinedList];
    
    self.friendListTableView.tableHeaderView = nil;
    

    [ZHXMPP xmpp].didReciveUserStatueChangeComplete = ^(XMPPJID *jid){
    
        __strong typeof(weakSelf) strongSelf = weakSelf;
        for (XMPPJID *oldJid in strongSelf.friendList) {
            if ([oldJid.user isEqualToString:jid.user]) {
                oldJid.jidUserStatue = jid.jidUserStatue;
                [strongSelf.friendListTableView reloadData];
            }
        }
    
    };
    
    [ZHXMPP xmpp].didReciveAddFriendRequestComplete = ^ (XMPPJID *jid){
    
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"添加好友请求" message:jid.user delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"接受",@"拒绝",nil];
        alertView.tag = 0;
        [alertView show];

    };
    
    [ZHXMPP xmpp].didReciveDeleteRequestComplete = ^ (XMPPJID *jid){
    
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"对方已经把你删除，是否也删除" message:jid.user delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alertView.tag = 3;
        [alertView show];

    };
    
  
    
}


- (IBAction)logout:(id)sender {
    [[ZHXMPP xmpp]logout];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = ((ZHTabBarController *)self.tabBarController).baseNavigationController;
}
-(void)awakeFromNib {

    
}
- (IBAction)addFriend:(id)sender {
    [self addFrined];
}

- (void)addFrined {

    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请输入用户名" message:@"请输入存在的帐号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = 1;
    [alertView show];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.friendList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *str= @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    XMPPJID *jid = self.friendList[indexPath.row];
    
    cell.textLabel.text = jid.user;
    if (jid.jidUserStatue) {
        cell.detailTextLabel.text = jid.jidUserStatue;

    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    XMPPJID *jid = self.friendList[indexPath.row];
    MessageChatTableViewController *chatVC =(MessageChatTableViewController *) [ZHCommon storyboardClass:[MessageChatTableViewController class]];
    chatVC.chatJID = jid;
    [self.navigationController pushViewController:chatVC animated:YES];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1 && alertView.tag == 1) {
        UITextField *textFiled = [alertView textFieldAtIndex:0];
        
        [[ZHXMPP xmpp]subscribePresenceToUser:textFiled.text];
    }else if(buttonIndex == 1 && alertView.tag == 0){
    
        [[ZHXMPP xmpp]addFrindJid:alertView.message nikeName:nil];
        
    }else if (buttonIndex == 2  && alertView.tag == 0) {
    
        [[ZHXMPP xmpp]rejectFriendRequestJid:alertView.message];
    }else if (buttonIndex == 1 && alertView.tag == 3) {
    
        
    }

}

@end
