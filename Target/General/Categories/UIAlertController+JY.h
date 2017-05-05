//
//  UIAlertController+JY.h
//  Target
//
//  Created by Jolie_Yang on 2017/5/5.
//  Copyright © 2017年 JolieYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (JY)
+ (instancetype)alertWithTitle:(NSString *)title cancelTitle:(NSString *)cancelStr;
+ (instancetype)actionSheetWithTitle:(NSString *)title
                          firstTitle:(NSString *)firstTitle
                        firstHandler:(void (^)())firstHandler
                         secondTitle:(NSString *)secondTitle
                       secionHandler:(void (^)())secondHandler;
@end
