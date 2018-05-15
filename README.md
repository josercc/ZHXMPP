# ZHXMPP

> 基于XMPPFramework的二次封装,让XMPP通信更加简单，希望大家可以FORK共同扩展功能

# 怎么安装使用

1.直接下载运行demo

2.使用POD

> pod 'ZHXMPP'


# 怎么使用

## 搭建OpenFire服务器(其他基于XMPP服务器也是可以的)

[http://www.cnblogs.com/hoojo/archive/2012/05/17/2506769.html](http://www.cnblogs.com/hoojo/archive/2012/05/17/2506769.html)

### 初始化

    ZHXMPP *xmpp=[ZHXMPP xmpp];
### 初始化服务器地址

    xmpp.xmppHost = @"服务器地址";

### 初始化端口(默认位5222)

    xmpp.xmppPort=5222;
### 初始化XMPP服务器

    [xmpp steup];
### 注册
```
/**
 *  注册XMPP
 *
 *  @param userName 用户名
 *  @param passWord 密码
 *  @param complete 完成回掉
 */
- (void)regiserUserName:(NSString *)userName passWord:(NSString *)passWord complete:(RegiserSuccessComplete)complete;
```
### 登录

```
/**
 *  登录XMPP
 *
 *  @param userName 用户名
 *  @param passWord 密码
 *  @param complete 完成回掉
 */
- (void)loginUserName:(NSString *)userName passWord:(NSString *)passWord  complete:(LoginSuccessComplete)complete;
```

### 退出登录

```
///退出登录
- (void)logout;
```

### 获取好友列表

```
///获取好友列表 回掉:didReciverFriendListComplete
- (void)getFrinedList;
```

### 接受他人好友请求

```
/**
 *  接受他人的加好友请求
 *
 *  @param jid 好友的JID
 */
- (void)subscribePresenceToUser:(NSString *)jid;
```

### 添加好友

```
/**
 *  主动添加别人为好友
 *
 *  @param jid      别人的JID
 *  @param nikeName 备注 可以为nil
 */
- (void)addFrindJid:(NSString *)jid nikeName:(NSString *)nikeName;
```

### 拒绝好友请求

```
/*!
 *  拒绝添加好友的请求
 *
 *  @param jid 好友的ID
 */
- (void)rejectFriendRequestJid:(NSString *)jid;
```

### 删除好友

```
/*!
 *  删除某个好友
 *
 *  @param jid 好友的ID
 */
- (void)deleteFriendRequestJid:(NSString *)jid;
```

### 查看好友资料

```
/**
 *  查询用户的资料 暂时因为LIBXIM 原因 作者没解决
 *
 *  @param jidName  查询的JID
 *  @param complete 完成的回掉
 */
- (void)fectchUserInfo:(NSString *)jidName complete:(DidReciveVCardInfoComplete)complete;
```

### 发送消息

```
/*!
 *  发送消息
 *
 *  @param body 消息的内容
 *  @param jid 发送的用户名
 */
- (void)sendMessageBody:(NSString *)body withJid:(NSString *)jid;
```
