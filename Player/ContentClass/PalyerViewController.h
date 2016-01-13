//
//  PalyerViewController.h
//  SimplePlayback
//
//  Created by Longxun on 14-12-2.
//  Copyright (c) 2014年 VideoLAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PalyerViewController : UIViewController
@property (nonatomic,strong)UIView *playView;
@property (nonatomic,strong)NSMutableArray *classTitles;
@property (nonatomic,strong)NSIndexPath *listIndexPath;
@end
