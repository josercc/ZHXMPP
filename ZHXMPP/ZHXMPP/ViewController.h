//
//  ViewController.h
//  ZHXMPP
//
//  Created by 张行 on 15/11/20.
//  Copyright © 2015年 张行. All rights reserved.
//

#import <UIKit/UIKit.h>
//sdfsd
@interface ViewController : UIViewController

- (instancetype)initWithName:(NSString *)name error:(NSError **)error ;
//
@end

////@interface ViewController() {
////
////    NSString *_viewControllerName;
////}
//
//@end

@interface ViewController (Name)

@property (nonatomic, copy) NSString *viewControllerName;

@end