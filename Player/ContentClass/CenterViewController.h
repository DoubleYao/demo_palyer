//
//  CenterViewController.h
//  Player
//
//  Created by yaoyao on 14-11-23.
//  Copyright (c) 2014年 yaoyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICSDrawerController.h"
@interface CenterViewController : UIViewController<ICSDrawerControllerChild,ICSDrawerControllerPresenting>
{
}
@property(nonatomic, weak) ICSDrawerController *drawer;
@property(nonatomic, strong) NSMutableArray *classTitle;
@property(nonatomic,strong)UITableView *table;
@end
