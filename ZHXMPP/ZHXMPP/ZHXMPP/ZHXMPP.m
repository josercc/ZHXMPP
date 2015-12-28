//
//  ZHXMPP.m
//  ZHXMPP
//
//  Created by 张行 on 15/11/20.
//  Copyright © 2015年 张行. All rights reserved.
//

#import "ZHXMPP.h"

#import <XMPPFramework/XMPPReconnect.h>
#import <XMPPFramework/XMPPRosterCoreDataStorage.h>
#import <XMPPFramework/XMPPvCardCoreDataStorage.h>

typedef NS_ENUM(NSUInteger,XMPPConnectType) {
    ///登录
    XMPPConnectTypeLogin,
    ///注册
    XMPPConnectTypeRegiser
    
};

///上线

NSString * const KZHXMPPAvailable = @"available";
///离开
NSString * const KZHXMPPAway = @"away";
///忙碌
NSString * const KZHXMPPDisturb = @"do not disturb";
///下线
NSString * const KZHXMPPUnavailable = @"unavailable";

NSString * const KZHXMPPFreeToChat = @"Free To Chat";


#pragma mark - 添加好友
///订阅
NSString * const KZHXMPPSubscribe = @"subscribe";
///取消订阅
NSString * const KZHXMPPUnsubscribe = @"unsubscribe";
///接受添加好友
NSString * const KZHXMPPSubscribed = @"subscribed";
///拒绝添加好友
NSString * const KZHXMPPUnsubscribed = @"unsubscribed";


@interface ZHXMPP ()<XMPPStreamDelegate,XMPPRosterDelegate,XMPPvCardTempModuleDelegate>

@property (nonatomic, strong) XMPPStream *xmppStream;
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong) XMPPRosterCoreDataStorage *rosterStorage;
@property (nonatomic, strong) XMPPRoster *roster;
@property (nonatomic, strong) XMPPvCardTempModule *vCardTempModule;
@property (nonatomic, strong) XMPPvCardAvatarModule *vCardAvatarModule;


@end

@implementation ZHXMPP {

    NSError *_xmppError;
    
    LoginSuccessComplete _loginSuccessComplete;
    
    NSString *_password;
    
    RegiserSuccessComplete _regiserSuccessComplete;
    
    XMPPConnectType _xmppConnectType;
    
    NSString *_userName;
    
    NSMutableArray *_friendListArray;
    
    DidReciveVCardInfoComplete _reciveVCardInfoComplete;
    

}

+(instancetype)xmpp {

    static dispatch_once_t onceToken;
    static ZHXMPP *xmpp;
    dispatch_once(&onceToken, ^{
        xmpp = [[ZHXMPP alloc]init];
    });
    return xmpp;
}


- (XMPPStream *)xmppStream
{
    if (!_xmppStream) {
        _xmppStream = [[XMPPStream alloc]init];
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        _xmppPort = 5222;
        
    }
    return _xmppStream;
}
- (XMPPReconnect *)xmppReconnect
{
    if (!_xmppReconnect) {
        _xmppReconnect = [[XMPPReconnect alloc]init];
        [_xmppReconnect activate:self.xmppStream];
        
    }
    return _xmppReconnect;
}
- (XMPPRosterCoreDataStorage *)rosterStorage
{
    if (!_rosterStorage) {
        _rosterStorage = [[XMPPRosterCoreDataStorage alloc]init];
        
    }
    return _rosterStorage;
}
- (XMPPRoster *)roster
{
    if (!_roster) {
        _roster = [[XMPPRoster alloc]initWithRosterStorage:self.rosterStorage];
        _roster.autoFetchRoster = YES;
        _roster.autoAcceptKnownPresenceSubscriptionRequests = YES;
        [_roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
    }
    return _roster;
}
- (XMPPvCardTempModule *)vCardTempModule
{
    if (!_vCardTempModule) {
        _vCardTempModule = [[XMPPvCardTempModule alloc]initWithvCardStorage:[XMPPvCardCoreDataStorage sharedInstance]];
        [_vCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
    }
    return _vCardTempModule;
}

- (XMPPvCardAvatarModule *)vCardAvatarModule
{
    if (!_vCardAvatarModule) {
        _vCardAvatarModule = [[XMPPvCardAvatarModule alloc]initWithvCardTempModule:self.vCardTempModule];
        
    }
    return _vCardAvatarModule;
}
- (XMPPJID *)userJID
{
    return [XMPPJID jidWithUser:self.xmppStream.myJID.user domain:self.xmppHost resource:nil];
}

-(void)steup {

    [self setupXmpp];
}
- (void)setupXmpp {

    [self.roster activate:self.xmppStream];
    [self.vCardTempModule activate:self.xmppStream];
    [self.vCardAvatarModule activate:self.xmppStream];
    self.xmppStream.hostName = self.xmppHost;
    self.xmppStream.hostPort = self.xmppPort;
    
}
-(void)setXmppHost:(NSString *)xmppHost {

    _xmppHost = xmppHost;
    
    //[self setupXmpp];
}
-(void)setUserStatue:(ZHXMPPUserStatue)userStatue {

    if (_userStatue == userStatue) {
//        if (self.changeUserStatueComplete) {
//            self.changeUserStatueComplete(YES,userStatue);
//        }
    }
    
    switch (userStatue) {
        case ZHXMPPUserStatueOnline:
        {
            [self setUserStatueToHost:KZHXMPPAvailable];
            
        }
            break;
        case ZHXMPPUserStatueAway:
        {
            [self setUserStatueToHost:KZHXMPPAway];
            
        }
            break;
        case ZHXMPPUserStatueBusy:
        {
            [self setUserStatueToHost:KZHXMPPDisturb];
            
        }
            break;
        case ZHXMPPUserStatueOffLine:
        {
            [self setUserStatueToHost:KZHXMPPUnavailable];
            
        }
            break;
            
            
        default:
            break;
    }

}

- (void)setUserStatueToHost:(NSString *)statue {

    XMPPPresence *online =[XMPPPresence presenceWithType:statue];
    
    [self.xmppStream sendElement:online];

}

-(void)loginUserName:(NSString *)userName passWord:(NSString *)passWord  complete:(LoginSuccessComplete)complete {

    _xmppConnectType = XMPPConnectTypeLogin;
    _userName =  userName;
    _password = passWord;
    _loginSuccessComplete= complete;
    NSError *error;
    if (_friendListArray) {
        [_friendListArray removeAllObjects];
    }else {
    
        _friendListArray = [NSMutableArray array];
    }
    if (!self.xmppHost) {
        complete(NO,[DDXMLElement elementWithName:@"没有设置服务器地址"]);
    }
    
   
    if ([self.xmppStream isAuthenticated]) {
        
        [self.xmppStream disconnect];
        
    }
    self.xmppStream.myJID =[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",userName,self.xmppHost]];
    [self.xmppStream connectWithTimeout:60 error:&error];
        
        
       
        
  
    
    
    
    
   
}
-(void)logout {

    [self.xmppStream disconnect];
}
-(void)regiserUserName:(NSString *)userName passWord:(NSString *)passWord complete:(RegiserSuccessComplete)complete{

    _xmppConnectType = XMPPConnectTypeRegiser;
    _userName =  userName;
    _password = passWord;
    _loginSuccessComplete= complete;
    NSError *error;
    if (!self.xmppHost) {
        complete(NO,[NSXMLElement elementWithName:@"没有设置服务器地址"]);
    }
    _regiserSuccessComplete = complete;
    if ([self.xmppStream isConnected] && [self.xmppStream.myJID.user isEqualToString:userName]) {
        [self.xmppStream registerWithPassword:passWord error:&error];
        
    }else {
        self.xmppStream.myJID =[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",userName,self.xmppHost]];
        [self.xmppStream connectWithTimeout:60 error:&error];
        
    }
    


}
-(void)getFrinedList {

    if (self.didReciverFriendListComplete) {
        self.didReciverFriendListComplete(_friendListArray);
    }

}

- (void)subscribePresenceToUser:(NSString *)jid {

    [self.roster acceptPresenceSubscriptionRequestFrom:[XMPPJID jidWithUser:jid domain:self.xmppHost resource:nil] andAddToRoster:YES];
    
}

-(void)addFrindJid:(NSString *)jid nikeName:(NSString *)nikeName {

    [self.roster addUser:[XMPPJID jidWithUser:jid domain:self.xmppHost resource:nil] withNickname:nikeName groups:nil subscribeToPresence:YES];
}
-(void)rejectFriendRequestJid:(NSString *)jid {

    [self.roster rejectPresenceSubscriptionRequestFrom:[XMPPJID jidWithUser:jid domain:self.xmppHost resource:nil]];
}
-(void)deleteFriendRequestJid:(NSString *)jid {
    [self.roster removeUser:[XMPPJID jidWithUser:jid domain:self.xmppHost resource:nil]];
}
-(void)fectchUserInfo:(NSString *)jidName complete:(DidReciveVCardInfoComplete)complete{
    _reciveVCardInfoComplete = complete;
    XMPPJID *jid = [XMPPJID jidWithUser:jidName domain:self.xmppHost resource:nil];
    [self.vCardTempModule fetchvCardTempForJID:jid];
    
}
-(void)sendMessageBody:(NSString *)body withJid:(NSString *)jid {

    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithUser:jid domain:self.xmppHost resource:nil]];
    [message addBody:body];
    [self.xmppStream sendElement:message];
    

}
///获取到好友列表的返回
- (void)didFetchFriendComplete:(XMPPIQ *)iq{

    if ([iq elementsForName:@"query"].count == 0) {
        return;
    }
    
    NSArray *queryArray = [[[iq elementsForName:@"query"] objectAtIndex:0] elementsForName:@"item"];
    if ([iq.to.user isEqualToString:self.xmppStream.myJID.user] && queryArray.count>0) {
        [_friendListArray removeAllObjects];
        for (NSUInteger i = 0; i< queryArray.count; i++) {
            NSXMLElement *element = queryArray[i];
            NSString *subscription = [element attributeForName:@"subscription"].stringValue;
            NSString *jidString = [element attributeForName:@"jid"].stringValue;
            if ([subscription isEqualToString:@"both"]) {
                [_friendListArray addObject:[XMPPJID jidWithString:jidString]];
            }
        }
        if (self.didReciverFriendListComplete) {
            self.didReciverFriendListComplete(_friendListArray);
        }
    }

}
- (void)didReviceFriendStatues:(NSArray *)items presence:(XMPPPresence *)presence{

    if (items.count > 0) {
        for (NSUInteger i = 0; i < items.count; i++) {
            NSXMLElement *element = items[i];
            NSString *status = element.stringValue;
            XMPPJID *fromJid = presence.from;
            fromJid.jidUserStatue = status;
            if (self.didReciveUserStatueChangeComplete && [presence.to.user isEqualToString:self.xmppStream.myJID.user]) {
                self.didReciveUserStatueChangeComplete(fromJid);
            }
        }
    }

}
- (void)didReciveFriendMessage:(XMPPMessage *)message {

    
    if ([message.to.user isEqualToString:self.xmppStream.myJID.user] && message.body) {
        if (self.didReciveMessageComplete) {
            self.didReciveMessageComplete(message.from,message);
        }
    }
    

}
#pragma mark - 😄XMPPStreamDelegate



- (void)xmppStream:(XMPPStream *)sender didReceiveTrust:(SecTrustRef)trust
 completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler{
    
    NSLog(@"%d->>%s",__LINE__,__func__);
}
- (void)xmppStreamDidSecure:(XMPPStream *)sender{
    
    NSLog(@"%d->>%s",__LINE__,__func__);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    NSLog(@"%d->>%s",__LINE__,__func__);
    NSError *error;
    switch (_xmppConnectType) {
        case XMPPConnectTypeLogin:
        {
            [self.xmppStream authenticateWithPassword:_password error:&error];

        }
            break;
        case XMPPConnectTypeRegiser:
        {
            
            [self.xmppStream registerWithPassword:_password error:&error];
        }
            break;
            
        default:
            break;
    }
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    
    NSLog(@"%d->>%s",__LINE__,__func__);
    if (_regiserSuccessComplete) {
        _regiserSuccessComplete(YES,nil);

    }
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{
    
    NSLog(@"%d->>%s->>%@",__LINE__,__func__,error);
    if (_regiserSuccessComplete) {
        _regiserSuccessComplete(NO,error);

    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    NSLog(@"%d->>%s",__LINE__,__func__);
    if (_loginSuccessComplete) {
        _loginSuccessComplete(YES,nil);
    }
    self.userStatue = ZHXMPPUserStatueOnline;
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    
    NSLog(@"%d->>%s->>%@",__LINE__,__func__,error);
    if (_loginSuccessComplete) {
        _loginSuccessComplete(NO,error);
    }
}



- (NSString *)xmppStream:(XMPPStream *)sender alternativeResourceForConflictingResource:(NSString *)conflictingResource{
    
    NSLog(@"%d->>%s->>%@",__LINE__,__func__,conflictingResource);
    return conflictingResource;
}

- (void)xmppStreamDidFilterStanza:(XMPPStream *)sender{
    
    NSLog(@"%d->>%s",__LINE__,__func__);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    NSLog(@"%d->>%s->>%@",__LINE__,__func__,iq);
    
    NSString *type = iq.type;
    if ([type isEqualToString:@"result"]) {
        ///查询好友返回
        [self didFetchFriendComplete:iq];
    }
    return YES;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    NSLog(@"%d->>%s->>%@",__LINE__,__func__,message);
    
    if ([message.type isEqualToString:@"chat"]) {
        [self didReciveFriendMessage:message];
    }
}
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    
    NSLog(@"%d->>%s->>%@",__LINE__,__func__,presence);
    
    NSArray * status  =[presence elementsForName:@"status"];
    [self didReviceFriendStatues:status presence:presence];
    
}
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error{
    
    NSLog(@"%d->>%s->>%@",__LINE__,__func__,error);
}

//
//- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq{
//    
//    NSLog(@"%d->>%s->>%@",__LINE__,__func__,iq);
//}
//
//- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
//    
//    NSLog(@"%d->>%s->>%@",__LINE__,__func__,message);
//}
//
//- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence{
//    
//    NSLog(@"%d->>%s->>%@",__LINE__,__func__,presence);
//    
//}
- (void)xmppStream:(XMPPStream *)sender didFailToSendIQ:(XMPPIQ *)iq error:(NSError *)error{
    
    NSLog(@"%d->>%s->>%@",__LINE__,__func__,error);
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{
    
    NSLog(@"%d->>%s->>%@",__LINE__,__func__,error);
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendPresence:(XMPPPresence *)presence error:(NSError *)error{
    
    NSLog(@"%d->>%s->>%@",__LINE__,__func__,error);
   // _changeUserStatueComplete(NO,self.userStatue);
}

- (void)xmppStreamDidChangeMyJID:(XMPPStream *)xmppStream{
    NSLog(@"%d->>%s",__LINE__,__func__);
    [self xmppStreamDidConnect:self.xmppStream];
}

- (void)xmppStreamWasToldToDisconnect:(XMPPStream *)sender{
    
    NSLog(@"%d->>%s",__LINE__,__func__);
}

- (void)xmppStreamDidSendClosingStreamStanza:(XMPPStream *)sender{
    
    NSLog(@"%d->>%s",__LINE__,__func__);
}

- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    
    NSLog(@"%d->>%s",__LINE__,__func__);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    
    NSLog(@"%d->>%s->>%@",__LINE__,__func__,error);
    if (self.didLogoutComplete) {
        self.didLogoutComplete(error?YES:NO,error);
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveP2PFeatures:(NSXMLElement *)streamFeatures{
    
    NSLog(@"%d->>%s->>%@",__LINE__,__func__,streamFeatures);
}


- (void)xmppStream:(XMPPStream *)sender didRegisterModule:(id)module{
    
    NSLog(@"%d->>%s->>%@",__LINE__,__func__,module);
}

- (void)xmppStream:(XMPPStream *)sender willUnregisterModule:(id)module{
    
    NSLog(@"%d->>%s->>%@",__LINE__,__func__,module);
}


- (void)xmppStream:(XMPPStream *)sender didReceiveCustomElement:(NSXMLElement *)element{
    
    NSLog(@"%d->>%s->>%@",__LINE__,__func__,element);
}


#pragma mark - XMPPRosterDelegate

- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence {
    NSLog(@"%d->>%s->>%@",__LINE__,__func__,presence);
    if ([presence.type isEqualToString:@"unsubscribed"] && [presence.to.user isEqualToString:self.xmppStream.myJID.user]) {
        ///已经收到了别人删除好友的通知
        if(self.didReciveDeleteRequestComplete){
            self.didReciveDeleteRequestComplete(presence.from);
        }
    }
}
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(NSXMLElement *)item {
    NSLog(@"%d->>%s->>%@",__LINE__,__func__,item);
    NSString *jidString = [item attributeForName:@"jid"].stringValue;
    NSString *subscription = [item attributeForName:@"subscription"].stringValue;
    XMPPJID *jid = [XMPPJID jidWithString:jidString];
    if (self.didReciveAddFriendRequestComplete && [subscription isEqualToString:@"from"]) {
        self.didReciveAddFriendRequestComplete(jid);
    }
    
}
#pragma mark - XMPPvCardTempModuleDelegate

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule
        didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp
                     forJID:(XMPPJID *)jid {
    
    NSLog(@"%d->>%s->>%@->>%@->>%@",__LINE__,__func__,vCardTempModule,vCardTemp,jid);
    if (_reciveVCardInfoComplete) {
        _reciveVCardInfoComplete(vCardTemp);
    }
}

- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule {
    NSLog(@"%d->>%s->>%@",__LINE__,__func__,vCardTempModule);
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToUpdateMyvCard:(NSXMLElement *)error {
    NSLog(@"%d->>%s->>%@",__LINE__,__func__,error);
}

@end
