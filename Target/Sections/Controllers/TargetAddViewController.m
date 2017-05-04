//
//  TargetAddViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/3/16.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//
// [todo] 进入该页面时自动弹出键盘

#import "TargetAddViewController.h"
#import "IconTextFieldTableViewCell.h"
#import "TextFieldTableViewCell.h"
#import "TextViewTableViewCell.h"
#import "Target.h"
#import "TargetManager.h"
#import "DateHelper.h"
#import "UITextView+JY.h"

@interface TargetAddViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSString *targetName;
@property (nonatomic, strong) NSString *encourage;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, strong) UITableView *configTableView;
@property (nonatomic, strong) UICollectionView *iconCollectionView;
@end

@implementation TargetAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"创建Target";
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self customBackItemWithImageName:Gray_Nav_Back_Icon_Name action:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationController.navigationBar.barTintColor = System_Nav_White;
    [self setNavigationBarTitleColor:System_Nav_Gray];
    [self addDoneNavigationItem];
    [self hideRightItem:YES];
    [self becomeFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)setupViews {
    self.view.backgroundColor = App_Bg;
    self.configTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight) style: UITableViewStylePlain];
    self.configTableView.backgroundColor = App_Bg;
    self.configTableView.delegate = self;
    self.configTableView.dataSource = self;
    self.configTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.configTableView];
    [self addResignKeyboardGestures];
}

- (void)addDoneNavigationItem {
    [self customRightItemWithImageName:Gray_Nav_Check_Icon_Name action:^{
        [self doneItemAction];
    }];
}

- (void)doneItemAction {
    // 添加项目
    if ([self.targetName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [JYProgressHUD showTextHUDWithDetailString:@"请填写Target名称" AddedTo:self.view];
        return;
    }
    if (self.successAddTargetBlock) {
        self.successAddTargetBlock([self addedTarget]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 58;
    } else if(indexPath.section == 2) {
        return 140;
    }else {
        return 0;
    }
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        
        TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TextFieldTableViewCell class])];
        if (!cell) {
            cell = [TextFieldTableViewCell loadFromNib];
        }
        if (indexPath.section == 0) {
            cell.textField.placeholder = @"Target名称，如看电影，跑步";
            cell.textFieldDidChangeBlock = ^(NSString *text) {
                weakSelf.targetName = text;
                if (text.length > 0) {
                    [weakSelf hideRightItem:NO];
                } else {
                    [weakSelf hideRightItem:YES];
                }
            };
            
            return cell;
        } else {
            cell.textField.placeholder = @"一句激励自己的话";
            cell.textFieldDidChangeBlock = ^(NSString *text) {
                weakSelf.encourage = text;
            };
            
            return cell;
        }
    } else if(indexPath.section == 2) {
        TextViewTableViewCell *cell = [TextViewTableViewCell loadFromNib];
        cell.textView.font = [UIFont fontWithName:@"PingFangSC-Thin" size:14.0];
        [cell.textView setPlaceHolder: @"描述这个Target"];
        
        NSLog(@"cell visible:%lu", tableView.visibleCells.count);
        return cell;
    } else {
        IconTextFieldTableViewCell *firstCell = [IconTextFieldTableViewCell loadFromNib];
        firstCell.iconImageView.image = Default_Image;
        firstCell.inputTextField.returnKeyType = UIReturnKeyDone;
        firstCell.textFieldReturnBlock = ^(NSString *text) {
            [self.view endEditing:YES];
        };
        firstCell.textFieldDidChangeBlock = ^(NSString *text) {
            self.targetName = text;
            if (text.length > 0) {
                [self hideRightItem:NO];
            } else {
                [self hideRightItem:YES];
            }
        };
        return firstCell;
    }
}

- (Target *)addedTarget {
    Target *target = [[Target alloc] init];
    target.targetName = self.targetName;
    target.encourage = self.encourage;
    target.remarks = self.remarks;
    target.createUnix = [DateHelper getCurrentTimeInterval];
    target.updateUnix = target.createUnix;
    [TargetManager addTarget:target];
    return target;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

@end
