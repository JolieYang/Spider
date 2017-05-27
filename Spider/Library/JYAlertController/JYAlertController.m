//
//  JYAlertController.m
//  Target
//
//  Created by Jolie_Yang on 2017/5/5.
//  Copyright © 2017年 JolieYang. All rights reserved.
//

#import "JYAlertController.h"

@interface JYAlertAction ()
@property (nonatomic, copy) void (^actionBlock)();
@end

@implementation JYAlertAction

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(JYAlertAction *action))handler {
    static JYAlertAction *alertAction = nil;
    if (!alertAction) {
        alertAction = [[JYAlertAction alloc] init];
    }
    alertAction.title = title;
    alertAction.style = style;
    
    alertAction.actionBlock = [handler copy];
    
    return alertAction;
}
@end

@interface JYAlertController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) NSMutableArray<JYAlertAction *> *actionArray;
@end

@implementation JYAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    [self setupDatas];
}

- (void)addAction:(JYAlertAction *)action {
    [self.actionArray addObject:action];
}

- (void)setupViews {
    
}

- (void)setupDatas {
    self.actionArray = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
