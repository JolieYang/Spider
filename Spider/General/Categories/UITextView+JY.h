//
//  UITextView+JY.h
//  Spider
//
//  Created by Jolie_Yang on 2017/4/19.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (JY)
- (void)setPlaceHolder:(NSString *)text;
- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;
@end
