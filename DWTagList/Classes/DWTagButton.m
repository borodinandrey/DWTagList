//
//  DWTagButton.m
//  DWTagList
//
//  Created by Andrew Podkovyrin on 28.02.14.
//  Copyright (c) 2014 Andrew Podkovyrin. All rights reserved.
//

#import "DWTagButton.h"
#import <QuartzCore/QuartzCore.h>

@interface DWTagButton ()

@property (strong, readwrite, nonatomic) UILabel *tagLabel;

@end


@implementation DWTagButton

- (id)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self.layer setMasksToBounds:YES];
        
        self.tagLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.tagLabel.backgroundColor = [UIColor clearColor];
        self.tagLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.tagLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.tagLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tagLabel.frame = self.bounds;
}

#pragma mark - Content

- (void)setTagValue:(id)tagValue_ {
    _tagValue = tagValue_;
    
    if ([_tagValue isKindOfClass:[NSString class]]) {
        self.tagLabel.text = _tagValue;
    } else if ([_tagValue isKindOfClass:[NSAttributedString class]]) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:_tagValue];
        [attributedString addAttributes:@{NSFontAttributeName: self.tagLabel.font}
                                  range:NSMakeRange(0, ((NSAttributedString *)_tagValue).string.length)];

        self.tagLabel.attributedText = attributedString;
    } else {
        self.tagLabel.text = [_tagValue description];
    }
}

#pragma mark - Customization

- (void)setTagTextFont:(UIFont *)font {
    self.tagLabel.font = font;
}

- (void)setTagCornerRadius:(CGFloat)cornerRadius {
    [self.layer setCornerRadius:cornerRadius];
}

- (void)setTagBorderColor:(CGColorRef)borderColor {
    [self.layer setBorderColor:borderColor];
}

- (void)setTagBorderWidth:(CGFloat)borderWidth {
    [self.layer setBorderWidth:borderWidth];
}

- (void)setTagTextColor:(UIColor *)textColor {
    self.tagLabel.textColor = textColor;
}

- (void)setTagTextShadowColor:(UIColor *)textShadowColor {
    self.tagLabel.shadowColor = textShadowColor;
}

- (void)setTagTextShadowOffset:(CGSize)textShadowOffset {
    self.tagLabel.shadowOffset = textShadowOffset;
}

#pragma mark - UIMenuController

- (BOOL)canBecomeFirstResponder {
    return [self.delegate tagButtonCanBecomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return [self.delegate tagButtonMenuControllerCanPerformAction:action];
}

- (void)copy:(id)sender {
    [[UIPasteboard generalPasteboard] setString:(self.tagLabel.text ?: [self.tagLabel.attributedText string])];
}

- (void)delete:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tagButtonDeleteAction:)]) {
        [self.delegate tagButtonDeleteAction:self];
    }
}

#pragma mark - Dynamic height

+ (CGSize)tagButtonSize:(id)tag
                   font:(UIFont *)font
     constrainedToWidth:(CGFloat)maxWidth
                padding:(CGSize)padding
           minimumWidth:(CGFloat)minimumWidth {
    CGSize textSize;
    if ([tag isKindOfClass:[NSString class]]) {
        textSize = [(NSString *)tag sizeWithFont:font forWidth:maxWidth lineBreakMode:NSLineBreakByTruncatingTail];
    } else if ([tag isKindOfClass:[NSAttributedString class]]) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:tag];
        [attributedString addAttributes:@{NSFontAttributeName: font} range:NSMakeRange(0, ((NSAttributedString *)tag).string.length)];
        
        textSize = [attributedString boundingRectWithSize:CGSizeMake(maxWidth, 0.f) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    } else {
        textSize = [[tag description] sizeWithFont:font forWidth:maxWidth lineBreakMode:NSLineBreakByTruncatingTail];
    }
    
    textSize.width = MAX(textSize.width, minimumWidth);
    
    textSize.width += padding.width * 2;
    textSize.height += padding.height * 2;
    
#if defined(__LP64__) && __LP64__
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
#else
    return CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
#endif
}

@end
