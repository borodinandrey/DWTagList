//
//  DWTagButton.h
//  DWTagList
//
//  Created by Andrew Podkovyrin on 28.02.14.
//  Copyright (c) 2014 Andrew Podkovyrin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DWTagButtonDelegate;


@interface DWTagButton : UIButton

@property (weak, readwrite, nonatomic) id<DWTagButtonDelegate> delegate;

@property (weak, readwrite, nonatomic) id tagValue;

- (void)setTagTextFont:(UIFont *)font;
- (void)setTagCornerRadius:(CGFloat)cornerRadius;
- (void)setTagBorderColor:(CGColorRef)borderColor;
- (void)setTagBorderWidth:(CGFloat)borderWidth;
- (void)setTagTextColor:(UIColor *)textColor;
- (void)setTagTextShadowColor:(UIColor *)textShadowColor;
- (void)setTagTextShadowOffset:(CGSize)textShadowOffset;

+ (CGSize)tagButtonSize:(id)tag
                   font:(UIFont *)font
     constrainedToWidth:(CGFloat)maxWidth
                padding:(CGSize)padding
           minimumWidth:(CGFloat)minimumWidth;

@end


@protocol DWTagButtonDelegate <NSObject>

@required

- (void)tagButtonDeleteAction:(DWTagButton *)tagButton;

- (BOOL)tagButtonCanBecomeFirstResponder;
- (BOOL)tagButtonMenuControllerCanPerformAction:(SEL)action;

@end

