//
//  TargetTabBarViewController.m
//  Target
//
//  Created by Jolie on 2017/4/23.
//  Copyright © 2017年 JolieYang. All rights reserved.
//

#import "TargetTabBarViewController.h"
#import "TargetHomeNavigationController.h"

@interface TargetTabBarViewController ()

@end

@implementation TargetTabBarViewController
static NSArray *TAB_BAR_TITLE_ARRAY = nil;
static NSArray *TAB_BAR_CONTROLLER_CLASS_ARRAY = nil;
static NSString *TAB_NORMAL_IMAGE_FORMAT = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TAB_BAR_TITLE_ARRAY = @[@"Target", @"Out", @"Target", @"我的"];
    TAB_BAR_CONTROLLER_CLASS_ARRAY = @[@"TargetHomeNavigationController"];
    TAB_NORMAL_IMAGE_FORMAT = @"tab_icon_0%i_normal";
    
    [self setupTabBar];
}

- (void)setupTabBar {
    NSMutableArray *controllerArray = [NSMutableArray array];
    NSArray *tabBarViewControllerClassNameArray = TAB_BAR_CONTROLLER_CLASS_ARRAY;
    NSArray *titleArray = TAB_BAR_TITLE_ARRAY;
    
    for (int i = 0; i < tabBarViewControllerClassNameArray.count; i++) {
        UIViewController *vc = (UIViewController *)[[NSClassFromString(tabBarViewControllerClassNameArray[i]) alloc] init];
        UIImage *normalImage = [UIImage imageNamed:[NSString stringWithFormat:TAB_NORMAL_IMAGE_FORMAT, i+1]];
        vc.tabBarItem.title = titleArray[i];
        vc.tabBarItem.image = [normalImage imageWithRenderingMode:UIImageRenderingModeAutomatic];
        [controllerArray addObject:vc];
    }
    self.viewControllers = controllerArray;
    
    self.tabBar.tintColor = Apple_Gold;
    self.tabBar.barTintColor = System_Black;
    self.tabBar.translucent = NO;
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
