//
//  UIAlertController+JY.m
//  Spider
//
//  Created by Jolie_Yang on 2017/5/5.
//  Copyright © 2017年 JolieYang. All rights reserved.
//

#import "UIAlertController+JY.h"

@implementation UIAlertController (JY)
+ (instancetype)alertWithTitle:(NSString *)title cancelTitle:(NSString *)cancelStr {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelStr style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    return alertController;
}

+ (instancetype)actionSheetWithTitle:(NSString *)title
                          firstTitle:(NSString *)firstTitle
                        firstHandler:(void (^)())firstHandler
                         secondTitle:(NSString *)secondTitle
                       secionHandler:(void (^)())secondHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *project = [UIAlertAction actionWithTitle:@"项目" style:UIAlertActionStyleDestructive handler: firstHandler];
    UIAlertAction *log = [UIAlertAction actionWithTitle:@"日志" style:UIAlertActionStyleDestructive handler: secondHandler];
    [alertController addAction:project];
    [alertController addAction:log];
    
    return alertController;
}
@end
