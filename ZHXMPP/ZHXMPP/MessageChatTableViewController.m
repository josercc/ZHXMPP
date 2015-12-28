//
//  MessageChatTableViewController.m
//  ZHXMPP
//
//  Created by 张行 on 15/11/24.
//  Copyright © 2015年 张行. All rights reserved.
//

#import "MessageChatTableViewController.h"
#import "MessageModel.h"
#import "ZHXMPP.h"

NSUInteger const KKeyBoardHeight = 255;

@interface MessageChatTableViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextFiled;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageTextFiledConstraint;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *viewButtomLayoutConstraint;

@property (nonatomic, strong) NSMutableArray *messageChatArray;
@end

@implementation MessageChatTableViewController
- (NSMutableArray *)messageChatArray
{
    if (!_messageChatArray) {
        _messageChatArray = [NSMutableArray array];
        
    }
    return _messageChatArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ZHXMPP xmpp].didReciveMessageComplete = ^ (XMPPJID *jid,XMPPMessage *message) {
    
        if ([jid.user isEqualToString:self.chatJID.user]) {
            
            MessageModel *model = [[MessageModel alloc]init];
            model.jid = jid;
            model.message = message;
            [self.messageChatArray addObject:model];
            [self.chatTableView reloadData];
        }
        
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendMessage:(id)sender {
    if (self.messageTextFiled.text.length == 0) {
        [ZHCommon showErrorMessage:@"发送的内容不能为空"];
        
    }else{
        MessageModel *model = [[MessageModel alloc]init];
        XMPPMessage *message  = [[XMPPMessage alloc]initWithType:@"chat" to:self.chatJID];
        [message addBody:self.messageTextFiled.text];
        model.jid = [ZHXMPP xmpp].userJID;
        model.message = message;
        [self.messageChatArray addObject:model];
        [self.chatTableView reloadData];
        
        [[ZHXMPP xmpp]sendMessageBody:message.body withJid:self.chatJID.user];

    }
    [self.messageTextFiled resignFirstResponder];
}
- (IBAction)dismissKeyBoard:(id)sender {
    [self.messageTextFiled resignFirstResponder];
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageChatArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageChatTableViewControllerCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MessageChatTableViewControllerCell"];
    }
    MessageModel *model = self.messageChatArray[indexPath.row];
    if ([model.jid.user isEqualToString:self.chatJID.user]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@:%@",model.jid.user,model.message.body];
        cell.detailTextLabel.text = nil;
    }else {
    
        cell.textLabel.text = nil;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@:%@",model.jid.user,model.message.body];
    }
    
    
    return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    [UIView animateWithDuration:0.25 animations:^{
        
        self.messageTextFiledConstraint.constant = self.messageTextFiledConstraint.constant-KKeyBoardHeight;
        [self.inputView updateConstraints];
    }];

    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

    [UIView animateWithDuration:0.25 animations:^{
        
        self.messageTextFiledConstraint.constant = self.messageTextFiledConstraint.constant+KKeyBoardHeight;
        [self.inputView updateConstraints];

    }];
    return YES;
}


@end
