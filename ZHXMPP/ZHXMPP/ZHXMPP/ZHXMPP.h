//
//  ZHXMPP.h
//  ZHXMPP
//
//  Created by 张行 on 15/11/20.
//  Copyright © 2015年 张行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPPFramework/XMPPFramework.h>
#import "XMPPJID+ZHCategory.h"
@class XMPPvCardTemp;

/*!
 *  设置用户的状态
 */
typedef NS_ENUM(NSUInteger,ZHXMPPUserStatue) {
    /*!
     *  在线
     */
    ZHXMPPUserStatueOnline,
    /*!
     *  离开
     */
    ZHXMPPUserStatueAway,
    /*!
     *  下线
     */
    ZHXMPPUserStatueOffLine,
    /*!
     *  忙碌
     */
    ZHXMPPUserStatueBusy
};

typedef void(^LoginSuccessComplete)(BOOL isSuccess,NSXMLElement *error);
typedef void(^ChangeUserStatueComplete)(BOOL isSuccess,ZHXMPPUserStatue);
typedef void(^RegiserSuccessComplete)(BOOL isSuccess,NSXMLElement *error);
typedef void(^DidReciveFriendListComplete)(NSArray<XMPPJID *> *friendList);
typedef void(^DidReciveVCardInfoComplete) (XMPPvCardTemp *vCardTemp);
typedef void(^DidReciveUserStatueChangedComplete) (XMPPJID *jid);
typedef void(^DidReciveAddFriendRequestComplete)(XMPPJID *jid);
typedef void(^DidReciveMessageComplete)(XMPPJID *fromJid,XMPPMessage *message);
typedef void(^DidLogoutComplete)(BOOL isSuccess,NSError *error);
typedef void(^DidReciveDeleteRequestComplete)(XMPPJID *jid);

@interface ZHXMPP : NSObject

#pragma mark -😄属性
///服务器地址
@property (nonatomic, strong) NSString *xmppHost;
///端口 默认为5222
@property (nonatomic, assign) UInt16 xmppPort;
///设置当前用户的状态
@property (nonatomic, assign) ZHXMPPUserStatue userStatue;
///获取到好友列表回掉
@property (nonatomic, copy) DidReciveFriendListComplete didReciverFriendListComplete;
///当好友或者自己状态改变回掉
@property (nonatomic, copy) DidReciveUserStatueChangedComplete didReciveUserStatueChangeComplete;
///当收到其他人加好友请求的回掉
@property (nonatomic, copy) DidReciveAddFriendRequestComplete didReciveAddFriendRequestComplete;
///收到聊天消息
@property (nonatomic, copy) DidReciveMessageComplete didReciveMessageComplete;
///退出的回调
@property (nonatomic, copy) DidLogoutComplete didLogoutComplete;
///已经收到删除好友的请求
@property (nonatomic, copy) DidReciveDeleteRequestComplete didReciveDeleteRequestComplete;

@property (nonatomic, strong, readonly) XMPPJID *userJID;
#pragma mark -😄方法
///初始化
+ (instancetype)xmpp;
///初始化 理论上只能初始化一次
- (void)steup;
/**
 *  登录XMPP
 *
 *  @param userName 用户名
 *  @param passWord 密码
 *  @param complete 完成回掉
 */
- (void)loginUserName:(NSString *)userName passWord:(NSString *)passWord  complete:(LoginSuccessComplete)complete;
///退出登录
- (void)logout;
/**
 *  注册XMPP
 *
 *  @param userName 用户名
 *  @param passWord 密码
 *  @param complete 完成回掉
 */
- (void)regiserUserName:(NSString *)userName passWord:(NSString *)passWord complete:(RegiserSuccessComplete)complete;
///获取好友列表 回掉:didReciverFriendListComplete
- (void)getFrinedList;
/**
 *  接受他人的加好友请求
 *
 *  @param jid 好友的JID
 */
- (void)subscribePresenceToUser:(NSString *)jid;
/**
 *  主动添加别人为好友
 *
 *  @param jid      别人的JID
 *  @param nikeName 备注 可以为nil
 */
- (void)addFrindJid:(NSString *)jid nikeName:(NSString *)nikeName;
/*!
 *  拒绝添加好友的请求
 *
 *  @param jid 好友的ID
 */
- (void)rejectFriendRequestJid:(NSString *)jid;
/*!
 *  删除某个好友
 *
 *  @param jid 好友的ID
 */
- (void)deleteFriendRequestJid:(NSString *)jid;
/**
 *  查询用户的资料 暂时因为LIBXIM 原因 作者没解决
 *
 *  @param jidName  查询的JID
 *  @param complete 完成的回掉
 */
- (void)fectchUserInfo:(NSString *)jidName complete:(DidReciveVCardInfoComplete)complete;
/*!
 *  发送消息
 *
 *  @param body 消息的内容
 *  @param jid 发送的用户名
 */
- (void)sendMessageBody:(NSString *)body withJid:(NSString *)jid;

@end
