//
//  LeftViewController.h
//  Player
//
//  Created by yaoyao on 14-11-23.
//  Copyright (c) 2014年 yaoyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICSDrawerController.h"
@interface LeftViewController : UIViewController<ICSDrawerControllerChild,ICSDrawerControllerPresenting>
@property(nonatomic, weak) ICSDrawerController *drawer;
@end
