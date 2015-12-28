//
//  MessageModel.h
//  ZHXMPP
//
//  Created by 张行 on 15/11/23.
//  Copyright © 2015年 张行. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XMPPJID;
@class XMPPMessage;
@interface MessageModel : NSObject
@property (nonatomic, strong) XMPPJID *jid;
@property (nonatomic, strong) XMPPMessage *message;
@end
