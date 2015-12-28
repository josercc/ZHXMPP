//
//  MessageChatTableViewController.h
//  ZHXMPP
//
//  Created by 张行 on 15/11/24.
//  Copyright © 2015年 张行. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMPPJID;
@interface MessageChatTableViewController : UIViewController
@property (nonatomic, strong) XMPPJID *chatJID;
@end
