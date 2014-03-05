//
//  DWTagButton.h
//  DWTagList
//
//  Created by Andrew Podkovyrin on 28.02.14.
//  Copyright (c) 2014 Andrew Podkovyrin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWTagButton : UIButton

@property (weak, readwrite, nonatomic) id tagValue;

- (void)setTagTextFont:(UIFont *)font;
- (void)setTagCornerRadius:(CGFloat)cornerRadius;
- (void)setTagBorderColor:(CGColorRef)borderColor;
- (void)setTagBorderWidth:(CGFloat)borderWidth;
- (void)setTagTextColor:(UIColor *)textColor;
- (void)setTagTextShadowColor:(UIColor *)textShadowColor;
- (void)setTagTextShadowOffset:(CGSize)textShadowOffset;
- (void)setTagIconImage:(UIImage *)image;

+ (CGSize)tagButtonSize:(id)tag
                   font:(UIFont *)font
     constrainedToWidth:(CGFloat)maxWidth
                padding:(CGSize)padding
           minimumWidth:(CGFloat)minimumWidth
               showIcon:(BOOL)showIcon;

@end
