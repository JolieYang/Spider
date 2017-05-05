//
//  JYAlertController.h
//  Target
//
//  Created by Jolie_Yang on 2017/5/5.
//  Copyright © 2017年 JolieYang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface JYAlertAction : NSObject<NSCopying>
+ (instancetype)actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(JYAlertAction *action))handler;

@property (nullable, nonatomic) NSString *title;
@property (nonatomic, assign) UIAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;
@end

@interface JYAlertController : UIViewController
//+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle;

- (void)addAction:(JYAlertAction *)action;
@property (nonatomic, readonly) NSArray<UIAlertAction *> *actions;

@property (nonatomic, strong, nullable) UIAlertAction *preferredAction ;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;

@property (nonatomic, readonly) UIAlertControllerStyle preferredStyle;
@end
