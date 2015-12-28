//
//  MessageListViewController.m
//  ZHXMPP
//
//  Created by 张行 on 15/11/23.
//  Copyright © 2015年 张行. All rights reserved.
//

#import "MessageListViewController.h"
#import "ZHXMPP.h"
#import "MessageModel.h"
@interface MessageListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *friendMessageArray;
@end

@implementation MessageListViewController
- (NSMutableArray *)friendMessageArray
{
    if (!_friendMessageArray) {
        _friendMessageArray = [NSMutableArray array];
        
    }
    return _friendMessageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"消息列表";
    __weak typeof(self) weakSelf= self;
    [ZHXMPP xmpp].didReciveMessageComplete = ^ (XMPPJID *jid,XMPPMessage *message){
    
        __strong typeof(weakSelf) strongSelf = weakSelf;
        MessageModel *model =[MessageModel new];
        model.jid = jid;
        model.message = message;
        
        [strongSelf addMessage:model];
    
    };
}
- (void)addMessage:(MessageModel *)model {

    BOOL isAdd = YES;
    for (MessageModel *model1 in self.friendMessageArray) {
        if ([model.jid.user isEqualToString:model1.jid.user]) {
            isAdd = NO;
            NSUInteger index= [self.friendMessageArray indexOfObject:model1];
            self.friendMessageArray[index] = model;
        }
    }
    if (isAdd) {
        [self.friendMessageArray addObject:model];
    }
    
    [self.tableView reloadData];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.friendMessageArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageListViewControllerCell"];
    MessageModel *model = self.friendMessageArray[indexPath.row];
    cell.textLabel.text = model.jid.user;
    cell.detailTextLabel.text = model.message.body;
    
    return cell;
}

@end
