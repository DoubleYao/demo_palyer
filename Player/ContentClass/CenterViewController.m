//
//  CenterViewController.m
//  Player
//
//  Created by yaoyao on 14-11-23.
//  Copyright (c) 2014年 yaoyao. All rights reserved.
//

#import "CenterViewController.h"
#import "Header.h"
#import "DataDeal.h"
#import "PalyerViewController.h"
@interface CenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    
    BOOL _isEdit;
    UIControl *bgControl;
}

@property(nonatomic, assign) NSInteger previousRow;
@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *select = [UIImage imageNamed:@"videocelleditbutton_normal"];
    UIImage *right = [UIImage imageNamed:@"videocellrightsideiconactiveunselect"];
    CGRect frame = self.view.frame;
    frame.origin.y = 24;
    frame.size.height -= 44+20;
    frame.size.width = frame.size.width + right.size.width+select.size.width;
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"category_tableview_bg"]];
    bg.frame = frame;
    [self.view addSubview:bg];
    _isEdit = NO;
    self.classTitle = [NSMutableArray arrayWithArray:[DataDeal getFilesWithFinder:MyVeadio]];
    UIImage *main = [UIImage imageNamed:@"videocellmainnormalunselectedbg"];
    _table = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = [UIColor clearColor];
    _table.backgroundView = nil;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.rowHeight = main.size.height;
    _table.showsVerticalScrollIndicator = NO;
    _table.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_table];
    
    bgControl = [[UIControl alloc] initWithFrame:_table.bounds];
    bgControl.backgroundColor = [UIColor blackColor];
    bgControl.alpha = 0.6;
    bgControl.hidden = YES;
    [_table addSubview:bgControl];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int n = ceil(tableView.frame.size.height/tableView.rowHeight);
    if (self.classTitle.count<n) {
        return n;
    }
    NSParameterAssert(self.classTitle);
    return self.classTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(self.classTitle);
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell = [_table dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier ];
    }
    if (indexPath.row<self.classTitle.count) {
        cell.textLabel.text = [NSString stringWithFormat:@"     %@",self.classTitle[indexPath.row]];
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"     "];
    }
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"categoryselectedbg"]];
    cell.backgroundColor = [UIColor clearColor];
    [self initCellBackViewWithState:0 isEdit:_isEdit cell:cell];
    [self initCellBackViewWithState:1 isEdit:_isEdit cell:cell];
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] init];
    longpress.minimumPressDuration = 2.;
    [longpress addTarget:self action:@selector(longPress:)];
    [cell addGestureRecognizer:longpress];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row<[self.classTitle count]) {
        PalyerViewController *vc = [[PalyerViewController alloc] init];
        vc.listIndexPath = indexPath;
        vc.classTitles = self.classTitle;
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}

- (void)initCellBackViewWithState:(BOOL)isSelect isEdit:(BOOL)isedit cell:(UITableViewCell *)cell
{
    UIView *v = [[UIView alloc] initWithFrame:cell.bounds];
    UIImage *left = [UIImage imageNamed:@""];
    UIImage *right = [UIImage imageNamed:@""];
    UIImage *select = [UIImage imageNamed:@""];
    UIImage *main = [UIImage imageNamed:@""];
    if (isSelect) {
        //if (isedit)
        {
            select = [UIImage imageNamed:@"videocelleditbutton_selected"];
            right = [UIImage imageNamed:@"videocellrightsideiconnormalselected"];
        }
        //else
        {
            left = [UIImage imageNamed:@"videocellleftsideiconnormalselected"];
        }
        main = [UIImage imageNamed:@"videocellmainnormalselectedbg"];
    }
    else
    {
        //if (isedit)
        {
            select = [UIImage imageNamed:@"videocelleditbutton_normal"];
            right = [UIImage imageNamed:@"videocellrightsideiconactiveunselect"];
        }
        //else
        {
            left = [UIImage imageNamed:@"videocellleftsideiconactiveunselect"];
        }
        main = [UIImage imageNamed:@"videocellmainnormalunselectedbg"];
    }
    UIImageView *v2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth+right.size.width+select.size.width, left.size.height)];
    v2.image = main;
    [v addSubview:v2];
    
    UIImageView *v1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, left.size.width, left.size.height)];
    v1.image = left;
    [v addSubview:v1];
    
    UIImageView *v3 = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, right.size.width, right.size.height)];
    v3.image = right;
    [v addSubview:v3];
    
    
    UIImageView *v4 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(v3.frame), 0, select.size.width, select.size.height)];
    v4.image = select;
    [v addSubview:v4];
 
    if (isSelect) {
        cell.selectedBackgroundView = v;
    }
    else
    {
        cell.backgroundView = v;
    }
    //[cell addSubview:v];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_isEdit) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _table.frame.size.width, _table.rowHeight)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed: @""] forState:UIControlStateNormal];
        [btn setTitle:@"删除" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake( _table.frame.size.width - ScreenWidth +10, 5, ScreenWidth-20, _table.rowHeight-10);
        [v addSubview:btn];
        return v;
    }
    return nil;
}
#pragma mark ---状态栏
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    
}
#pragma mark - ICSDrawerControllerPresenting

- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    //self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}

#pragma mark - Open drawer button

- (void)openDrawer:(id)sender
{
    [self.drawer open];
}
- (void)changeFrameLeft
{
    CGRect r = _table.frame;
    r.origin.x = 0;
    _table.frame = r;
    _isEdit = NO;
    self.drawer.isScrollEnable = YES;
    [_table reloadData];
}
- (void)changeFrameRight
{
    CGRect r = _table.frame;
    r.origin.x = ScreenWidth - r.size.width;
    _table.frame = r;
    _isEdit = YES;
    self.drawer.isScrollEnable = NO;
    [_table reloadData];
}

- (void)longPress:(UIGestureRecognizer*)gesture
{

    UIGestureRecognizerState state = gesture.state;
    
    UIView *cell = gesture.view;
    UIView *v = [[UIView alloc] initWithFrame:cell.bounds];
    v.backgroundColor = [UIColor blackColor];
    v.alpha = 0.8;
    UIImageView *image = [[UIImageView alloc] initWithFrame:cell.frame];
    image.backgroundColor = [UIColor redColor];
    CGPoint beginP,vCenter;
    switch (state) {
            
        case UIGestureRecognizerStateBegan:
        {
            [cell addSubview:v];
            bgControl.hidden = NO;
            [bgControl addSubview:image];
            beginP = [gesture locationInView:bgControl];
            vCenter = image.center;
        }
           
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            CGPoint location = [gesture locationInView:bgControl];
            image.center = CGPointMake(vCenter.x +(location.x-beginP.x), vCenter.y+(location.y-beginP.y));
            

            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        {
            bgControl.hidden = YES;
        }
            break;
        default:
            break;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

@end
