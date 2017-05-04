//
//  TextFieldTableViewCell.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/20.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "TextFieldTableViewCell.h"

@implementation TextFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInputStatus) name:UITextFieldTextDidChangeNotification object:nil];
}

+ (instancetype)reusableCellWithTableView:(UITableView *)tableView {
    TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    }
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)changeInputStatus {
    if (self.textFieldDidChangeBlock) {
        self.textFieldDidChangeBlock(_textField.text);// bug使用self.textFiled则在输入第一字时获取到的文本为空
    }
}
@end
