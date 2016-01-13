//
//  LeftViewController.m
//  Player
//
//  Created by yaoyao on 14-11-23.
//  Copyright (c) 2014年 yaoyao. All rights reserved.
//

#import "LeftViewController.h"
#import "DataDeal.h"
#import "CenterViewController.h"
@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
   
}
@property(nonatomic, strong) NSMutableArray *classTitle;
@property(nonatomic, assign) NSInteger previousRow;
@property(nonatomic,strong) NSIndexPath *selectIndexPath;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    
    CGRect frame = self.view.frame;
    frame.origin.y = 44;
    frame.size.height -= 44+20;
    
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"category_tableview_bg"]];
    bg.frame = frame;
    [self.view addSubview:bg];
    
    self.classTitle = [NSMutableArray arrayWithArray:[DataDeal getShouldShowFinderArray]];//@[@"我的视频",@"新建"];
    [self.classTitle addObject:NewCreateFinder];

    table = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor clearColor];
    table.backgroundView = nil;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    [self showSecretList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSecretList) name:NotificationShowSecretList object:nil];
}
- (void)showSecretList
{
    
    if (self.selectIndexPath.row == -1) {
        int row = 0;
        for (int i = 0; i<[self.classTitle count]; i++) {
            if ([self.classTitle[i] isEqualToString:MyVeadio]) {
                row = i;
                break;
            }
        }
        self.selectIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [table selectRowAtIndexPath:self.selectIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self tableView:table didSelectRowAtIndexPath:self.selectIndexPath];
    }
    else
    {
        NSString *str = [self.classTitle[self.selectIndexPath.row] copy];
        self.classTitle = [NSMutableArray arrayWithArray:[DataDeal getShouldShowFinderArray]];
        [self.classTitle addObject:NewCreateFinder];
        [table reloadData];
        
        int row = -1;
        int my = 0;
        for (int i = 0; i<[self.classTitle count]; i++) {
            if ([self.classTitle[i] isEqualToString:MyVeadio]) {
                my = i;
            }
            if ([self.classTitle[i] isEqualToString:str]) {
                row = i;
                break;
            }
        }
        if (row == -1) {
            row = my;
        }
        self.selectIndexPath = [NSIndexPath indexPathForRow: row inSection:0];
        [table selectRowAtIndexPath:self.selectIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self tableView:table didSelectRowAtIndexPath:self.selectIndexPath];
        
    }
    
    
    
    
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

    NSParameterAssert(self.classTitle);
    return self.classTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(self.classTitle);
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier ];
    }
    
    cell.textLabel.text = self.classTitle[indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"categoryselectedbg"]];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.classTitle[indexPath.row] isEqualToString:MySecretVeadio]) {
        
    }
    else if ([self.classTitle[indexPath.row] isEqualToString:NewCreateFinder]) {
        
    }
    else
    {
        CenterViewController *vc = (CenterViewController*)_drawer.centerViewController;
        vc.classTitle = [NSMutableArray arrayWithArray:[DataDeal getFilesWithFinder:self.classTitle[indexPath.row]]];
        [vc.table reloadData];
        
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    
}
#pragma mark ---状态栏
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    
}

#pragma mark - ICSDrawerControllerPresenting

- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}

- (void)drawerControllerWillClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}
@end
