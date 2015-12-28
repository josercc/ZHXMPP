//
//  XMPPJID+ZHCategory.m
//  ZHXMPP
//
//  Created by joser on 15/11/21.
//  Copyright © 2015年 张行. All rights reserved.
//

#import "XMPPJID+ZHCategory.h"
#import <objc/runtime.h>
@implementation XMPPJID (ZHCategory)
-(void)setJidUserStatue:(NSString *)jidUserStatue {

    objc_setAssociatedObject(self, @selector(jidUserStatue), jidUserStatue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSString *)jidUserStatue {

    return objc_getAssociatedObject(self, @selector(jidUserStatue));
}
@end
