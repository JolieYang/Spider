//
//  TargetAddTableViewCell.h
//  Out
//
//  Created by Jolie_Yang on 2017/3/16.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYImageView;

@interface IconTextFieldTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet JYImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UITextField *inputTextField;

+ (instancetype)reusableCellWithTableView:(UITableView *)tableView;

@property (nonatomic, copy) void (^textFieldReturnBlock)(NSString *inputedText);
@property (nonatomic, copy) void (^textFieldDidChangeBlock)(NSString *inputedText);
@end
