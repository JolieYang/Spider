//
//  TargetHomeViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/1/5.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "TargetHomeViewController.h"
#import "TargetAddRecordViewController.h"
#import "TargetLogsViewController.h"
#import "TargetShowTableViewCell.h"
#import "CenterTitleTableViewCell.h"
#import "TargetAddViewController.h"
#import "TargetManager.h"
#import "Target.h"
#import "TargetRecordManager.h"
#import "ACActionSheet.h"

@interface TargetHomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<Target *> *targetList;
@end

@implementation TargetHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.title = @"Target";
    self.navigationController.navigationBar.barTintColor = System_Nav_Black;
    [self setNavigationBarTitleColor:System_Nav_White];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    [self setupData];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupData {
    self.targetList = [NSMutableArray arrayWithArray:[TargetManager getTargetList]];
}

- (void)setupViews {
    [self setupNavigation];
    self.view.backgroundColor = App_Bg;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight - kTabbarHeight - kNavigationBarHeight - kStatusHeight) style: UITableViewStylePlain];
    self.tableView.backgroundColor = App_Bg;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

- (void)setupNavigation {
    [self.navigationController setNavigationBarHidden:NO];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItemAction)];
    self.navigationItem.rightBarButtonItem = addItem;
}

// 添加项目
- (void)addItemAction {
    [self chooseTargetType];
}

- (void)chooseTargetType {
    ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"项目", @"日志"] actionSheetBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [self jumpToTargetAddVCWithType:TargetTypeProject];
        } else if (buttonIndex == 1) {
            [self jumpToTargetAddVCWithType:TargetTypeLog];
        }
    }];
    [actionSheet show];
}

- (void)jumpToTargetAddVCWithType:(TargetType)targetType {
    TargetAddViewController *vc = [TargetAddViewController new];
    vc.addTargetType = targetType;
    vc.successAddOrEditTargetBlock = ^(Target *newData) {
        [self.targetList addObject:newData];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.targetList.count) {
        return 16.0;
    } else {
        return 0.0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.targetList.count) {
        return 82;
    } else {
        return kAppHeight-kTabbarHeight-kNavigationBarHeight-kStatusHeight;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.targetList.count) {
        [self chooseTargetType];
        return;
    }
    TargetAddRecordViewController *addRecordVC = [[TargetAddRecordViewController alloc] init];
    addRecordVC.hidesBottomBarWhenPushed = YES;
    addRecordVC.target = self.targetList[indexPath.section];
    addRecordVC.updateTargetBlock = ^(Target *target) {
        [self.targetList removeObjectAtIndex:indexPath.section];
        [self.targetList insertObject:target atIndex:0];
    };
    [self.navigationController pushViewController:addRecordVC animated:YES];
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.targetList.count) {
        TargetShowTableViewCell *cell = [TargetShowTableViewCell loadFromNib];
        cell.dataModel = self.targetList[indexPath.section];
        return cell;
    } else {
        CenterTitleTableViewCell *cell = [CenterTitleTableViewCell loadFromNib];
        cell.titleLabel.text = @"空空如也，快来创建Target吧";
        cell.titleLabel.textColor = Birthday_Gray;
        cell.titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.targetList.count) {
        return self.targetList.count;
    } else {
        return 1;
    }
}
@end
