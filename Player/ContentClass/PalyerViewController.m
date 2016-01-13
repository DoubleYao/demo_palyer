//
//  PalyerViewController.m
//  SimplePlayback
//
//  Created by Longxun on 14-12-2.
//  Copyright (c) 2014年 VideoLAN. All rights reserved.
//
#import <MobileVLCKit/MobileVLCKit.h>
#import "PalyerViewController.h"
#import "Header.h"
#import "DataDeal.h"
@interface PalyerViewController ()<VLCMediaPlayerDelegate>
{
    VLCMediaPlayer *_mediaplayer;
    UIView *topNavView;
    UIImageView *topView;
    UIImageView *bottomView;
    UISlider *positionSlider;
    UILabel *sliderLabel;
    UILabel *leftTime;
    UILabel *rightTime;
    BOOL isShowTab;
}
@end

@implementation PalyerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    _mediaplayer = [[VLCMediaPlayer alloc] init];
    _mediaplayer.delegate = self;
    _playView = [[UIView alloc] init];
    _playView.frame = CGRectMake(0, 0, ScreenHight, ScreenWidth);
    [self.view addSubview:_playView];
    _mediaplayer.drawable = self.playView;
    NSString *playPath = [DataDeal getPathName:self.classTitles[self.listIndexPath.row]];
    _mediaplayer.media  = [VLCMedia mediaWithPath:playPath];
    _mediaplayer.media = [VLCMedia mediaWithURL:[NSURL URLWithString:@""]];
    [self performSelector:@selector(play) withObject:nil afterDelay:2];
    UIControl *v  = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, ScreenHight, ScreenWidth)];
    v.backgroundColor = [UIColor clearColor];
    isShowTab = NO;
    [v addTarget:self action:@selector(showBars) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:v];
    
    [self initTopBar];
    [self initBottomBar];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%@",NSStringFromCGRect([UIScreen mainScreen].bounds));
}
- (void)play
{
    
    
    if (_mediaplayer.isPlaying)
        [_mediaplayer pause];
    [_mediaplayer play];
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}
- (BOOL)shouldAutorotate {
    
    return YES;
}

- (void)initTopBar
{
    
    topNavView = [[UIView alloc] init];
    topNavView.backgroundColor = [UIColor blackColor];
    
    topView = [[UIImageView alloc] init];
    topNavView.frame = CGRectMake(0, 0, ScreenHight+40, NavBarHeight+StateBarHight);
    topView.frame = CGRectMake(0, StateBarHight, ScreenHight+40, NavBarHeight);
    topView.image = [UIImage imageNamed:@"navi-choice-right-normal"];
    topView.userInteractionEnabled = YES;
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, NavBarHeight, NavBarHeight);
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_pressed"] forState:UIControlStateSelected];
    btnBack.tag = 1;
    [btnBack addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btnBack];
    
    leftTime = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 50, NavBarHeight)];
    leftTime.text = @"00:00";
    leftTime.textColor = [UIColor colorWithRed:58/255. green:146/255. blue:187/255. alpha:1];
    leftTime.font = [UIFont boldSystemFontOfSize:12];
    leftTime.backgroundColor = [UIColor clearColor];
    leftTime.textAlignment = NSTextAlignmentRight;
    [topView addSubview:leftTime];
    
    
    rightTime = [[UILabel alloc] initWithFrame:CGRectMake(topView.frame.size.width-70-50, 0, 50, NavBarHeight)];
    rightTime.text = @"00:00";
    rightTime.textColor = RGBCOLOR(58., 146., 187.);
    rightTime.font = [UIFont boldSystemFontOfSize:12];
    rightTime.backgroundColor = [UIColor clearColor];
    [topView addSubview:rightTime];
    
    
    positionSlider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftTime.frame)+10, 0, CGRectGetMinX(rightTime.frame)-10-(CGRectGetMaxX(leftTime.frame)+10), NavBarHeight)];
    [positionSlider addTarget:self action:@selector(slideChangeValues:) forControlEvents:UIControlEventValueChanged];
    [positionSlider addTarget:self action:@selector(slideChangeValues:) forControlEvents:UIControlEventTouchDragInside];
    [positionSlider addTarget:self action:@selector(slideChangeValues:) forControlEvents:UIControlEventTouchDragOutside];
    [topView addSubview:positionSlider];
    [topNavView addSubview:topView];
    topNavView.hidden = YES;
    [self.view addSubview:topNavView];
    
}
- (void)initBottomBar
{
    bottomView = [[UIImageView alloc] init];
    bottomView.frame = CGRectMake(0, ScreenWidth-NavBarHeight, ScreenHight, NavBarHeight);
    bottomView.userInteractionEnabled = YES;
    bottomView.backgroundColor = [UIColor clearColor];
    //bottomView.image = [UIImage imageNamed:@"Controlaera_center"];
    
    float ww = ScreenHight/5.;
    UIImageView *left = [[UIImageView alloc] init];
    left.frame = CGRectMake(0, 0, ww, NavBarHeight);
    left.userInteractionEnabled = YES;
    left.backgroundColor = [UIColor clearColor];
    left.image = [UIImage imageNamed:@"Controlaera_left"];
    [bottomView addSubview:left];
    
    UIImageView *center = [[UIImageView alloc] init];
    center.frame = CGRectMake(ww, 0, 3*ww, NavBarHeight);
    center.userInteractionEnabled = YES;
    center.backgroundColor = [UIColor clearColor];
    center.image = [UIImage imageNamed:@"Controlaera_center"];
    [bottomView addSubview:center];
    
    
    UIImageView *right = [[UIImageView alloc] init];
    right.frame = CGRectMake(4*ww, 0, ww, NavBarHeight);
    right.userInteractionEnabled = YES;
    right.backgroundColor = [UIColor clearColor];
    right.image = [UIImage imageNamed:@"Controlaera_right"];
    [bottomView addSubview:right];
    [self.view addSubview:bottomView];
    
    NSArray *normalImages = [NSArray arrayWithObjects:@"",@"prev",@"pause",@"next",@"", nil];
    NSArray *selectedImages = [NSArray arrayWithObjects:@"",@"prev",@"play",@"next",@"", nil];
    
    for (int i = 0; i<5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*ww, 0, ww, NavBarHeight);
        [btn setImage:[UIImage imageNamed:normalImages[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectedImages[i]] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:selectedImages[i]] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.showsTouchWhenHighlighted = YES;
        btn.tag = 1434+i;
        [bottomView addSubview:btn];
    }
    bottomView.hidden = YES;
}
- (void)buttonAction:(UIButton*)btn
{
    [_mediaplayer stop];
    NSLog(@"%@",NSStringFromCGRect([UIScreen mainScreen].bounds));
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)showBars
{
    if (isShowTab) {
        isShowTab = NO;
        [self hideBars];
    }
    else
    {
        isShowTab  = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        
        topNavView.alpha = 0;
        bottomView.alpha = 0;
        [UIView animateWithDuration:0.5 animations:^{
            topNavView.alpha = 1;
            bottomView.alpha = 1;
        } completion:^(BOOL finished) {
            topNavView.hidden = NO;
            bottomView.hidden = NO;
        }];
    }
    
}
- (void)hideBars
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    topNavView.alpha = 1;
    bottomView.alpha = 1;
    [UIView animateWithDuration:0.5 animations:^{
        topNavView.alpha = 0;
        bottomView.alpha = 0;
    } completion:^(BOOL finished) {
        topNavView.hidden = YES;
        bottomView.hidden = YES;
    }];
}
- (void)actionButton:(UIButton *)btn
{
    int n = btn.tag - 1434;
    switch (n) {
        case 0:
        {
            
        }
            
            break;
        case 1:
        {
            [_mediaplayer previousChapter];
        }
            
            break;
        case 2:
        {
            btn.selected = !btn.selected;
            if (_mediaplayer.isPlaying)
                [_mediaplayer pause];
            else
                [_mediaplayer play];
        }
            break;
        case 3:
        {
            [_mediaplayer nextChapter];
        }
            
            break;
        case 4:
        {
            
        }
            
            break;
            
        default:
            break;
    }
    
}
- (void)slideChangeValues:(UISlider *)slider
{
    _mediaplayer.position = slider.value;
    leftTime.text = [NSString stringWithFormat:@"%@",_mediaplayer.time];
    rightTime.text = [NSString stringWithFormat:@"%@",_mediaplayer.remainingTime];
}
- (void)mediaPlayerStateChanged:(NSNotification *)aNotification
{
    VLCMediaPlayer *m = aNotification.object;
    if (m.state == VLCMediaPlayerStateEnded) {
        int n = [self.classTitles count]-1;
        if (self.listIndexPath.row<n) {
            self.listIndexPath = [NSIndexPath indexPathForRow:self.listIndexPath.row+1 inSection:self.listIndexPath.section];
        }
        else if(self.listIndexPath.row == n)
        {
            self.listIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.listIndexPath.section];
        }
        NSString *playPath = [DataDeal getPathName:self.classTitles[self.listIndexPath.row]];
        _mediaplayer.media  = [VLCMedia mediaWithPath:playPath];
    }
    
}
- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification
{
    VLCMediaPlayer *m = aNotification.object;
    positionSlider.value = m.position;

    leftTime.text = [NSString stringWithFormat:@"%@",m.time];
    rightTime.text = [NSString stringWithFormat:@"%@",m.remainingTime];
   
}
@end
