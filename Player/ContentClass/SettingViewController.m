//
//  SettingViewController.m
//  CropTest
//
//  Created by Longxun on 14-12-1.
//
//

#import "SettingViewController.h"
#import "Header.h"
#import "DataDeal.h"

@implementation MySwitchView
@end;
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableview;
    
}
@property (retain,nonatomic)NSArray *titleArray;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavbar];
    CGRect r = self.view.bounds;
    r.origin.y = 64;
    r.size.height -= 64;
    tableview = [[UITableView alloc] initWithFrame:r style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    self.titleArray = [NSArray arrayWithObjects:@[@"清除播放进度记录",@"播放时手势快进快退",@"自动播放下一个"],@[@"显示加密列表",@"修改密码"],@[@"Wi-Fi传输视频和字幕"],@[@"使用小贴士",@"意见反馈",@"给评分",@"关于"], nil];
}

- (void)initNavbar
{
    UIImageView *navBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, StateBarHight, ScreenWidth+40, NavBarHeight)];
    navBar.image = [UIImage imageNamed:@"navi-choice-right-normal"];
    navBar.backgroundColor = [UIColor clearColor];
    navBar.userInteractionEnabled = YES;
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, NavBarHeight, NavBarHeight);
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_pressed"] forState:UIControlStateSelected];
    btnBack.tag = 1;
    [btnBack addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:btnBack];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(NavBarHeight, 0, ScreenWidth-2*NavBarHeight, NavBarHeight)];
    title.text = @"设置";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithRed:58/255. green:146/255. blue:187/255. alpha:1];
    title.font = [UIFont boldSystemFontOfSize:16];
    title.backgroundColor = [UIColor clearColor];
    [navBar addSubview:title];
    [self.view addSubview:navBar];
}
- (void)buttonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        MySwitchView *switchView = [[MySwitchView alloc] initWithFrame:CGRectMake(ScreenWidth-60, 5, 60, 34)];
        switchView.tag = 1652;
        [switchView addTarget:self action:@selector(clickeSwitch:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:switchView];
    }
    MySwitchView *s = (MySwitchView*)[cell viewWithTag:1652];
    s.indexPath = indexPath;
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        switch (indexPath.row) {
            case 0:
                s.hidden = YES;
                
                break;
            case 1:
                s.hidden = NO;
                s.on = [DataDeal getResultWithKey:GestureRecognizerOpration];
                break;
            case 2:
                s.on = [DataDeal getResultWithKey:AutoPlayNext];
                s.hidden = NO;
                break;
                
            default:
                break;
        }
    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            s.on = [DataDeal getResultWithKey:ShowSecretList];
            s.hidden = NO;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            s.hidden = YES;
        }
        
    }
    else if(indexPath.section == 2&&indexPath.row == 0)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        s.on = [DataDeal getResultWithKey:WiFiTransfer];
        s.hidden = NO;
    }
    else if(indexPath.section == 3)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        s.hidden = YES;
    }
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    return cell;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        if ([DataDeal getResultWithKey:ShowSecretList]) {
            return 2;
        }
        else
        {
            return 1;
        }
    }
    return [self.titleArray[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.titleArray count];
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    
}
- (void)clickeSwitch:(MySwitchView *)swch
{
    if (swch.indexPath.section == 0) {
        if (swch.indexPath.row == 1) {//手势
            [DataDeal setBoolValue:swch.on Key:GestureRecognizerOpration];
        }
        else if (swch.indexPath.row == 2) {//自动播放下一个
            [DataDeal setBoolValue:swch.on Key:AutoPlayNext];
        }
            
    }
    else if (swch.indexPath.section == 1 && swch.indexPath.row == 0) {//显示加密列表
       
        [DataDeal setBoolValue:swch.on Key:ShowSecretList];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationShowSecretList object:nil];
    }
    else if (swch.indexPath.section == 2 && swch.indexPath.row == 0) {//wifi传输
        
        [DataDeal setBoolValue:swch.on Key:WiFiTransfer];
    }
}
@end
