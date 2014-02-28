//
//  DWTagList.m
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import "DWTagList.h"
#import "DWTagListStyles.h"
#import "DWTagButton.h"


@interface DWTagList () <DWTagButtonDelegate> {
    CGSize sizeFit;
}

@end


@implementation DWTagList

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self setClipsToBounds:YES];
    
    self.tagBackgroundColor = kBackgroundColor;
    self.highlightedBackgroundColor = kHighlightedBackgroundColor;
    self.textFont = [UIFont systemFontOfSize:kFontSizeDefailt];
    self.labelMargin = kLabelMargin;
    self.bottomMargin = kBottomMargin;
    self.horizontalPadding = kHorizontalPadding;
    self.verticalPadding = kVerticalPadding;
    self.cornerRadius = kCornerRadius;
    self.borderColor = kBorderColor;
    self.borderWidth = kBorderWidth;
    self.textColor = kTextColor;
    self.textShadowColor = kTextShadowColor;
    self.textShadowOffset = kTextShadowOffset;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self display];
}

#pragma mark - Tags

- (void)setTags:(NSArray *)tags_ {
    _tags = [NSArray arrayWithArray:tags_];
    
    sizeFit = CGSizeZero;
    if (self.automaticResize) {
        [self display];
        self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), sizeFit.width, sizeFit.height);
    } else {
        [self setNeedsLayout];
    }
}

#pragma mark - Display

- (void)display {
    NSMutableArray *tagViews = [NSMutableArray array];
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
            [tagViews addObject:button];
        }
        [subview removeFromSuperview];
    }

    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;

    for (id tag in self.tags) {
        DWTagButton *tagButton = nil;
        if (tagViews.count > 0) {
            tagButton = [tagViews lastObject];
            [tagViews removeLastObject];
        } else {
            tagButton = [[DWTagButton alloc] init];
        }
        
        CGSize tagButtonSize = [DWTagButton tagButtonSize:tag
                                                   font:self.textFont
                                     constrainedToWidth:CGRectGetWidth(self.frame) - self.horizontalPadding * 2
                                                padding:CGSizeMake(self.horizontalPadding, self.verticalPadding)
                                           minimumWidth:self.minimumWidth];
        
        CGPoint origin = CGPointZero;
        if (gotPreviousFrame) {
            CGFloat left = CGRectGetMinX(previousFrame) + CGRectGetWidth(previousFrame);
            if (left + tagButtonSize.width + self.labelMargin > CGRectGetWidth(self.frame)) {
                origin = CGPointMake(0.f, CGRectGetMinY(previousFrame) + tagButtonSize.height + self.bottomMargin);
            } else {
                origin = CGPointMake(left + self.labelMargin, CGRectGetMinY(previousFrame));
            }
        }
        
        tagButton.frame = CGRectMake(origin.x, origin.y, tagButtonSize.width, tagButtonSize.height);
        tagButton.tagValue = tag;
        [self configureTagButton:tagButton];
        [self addSubview:tagButton];

        previousFrame = tagButton.frame;
        gotPreviousFrame = YES;
    }

    sizeFit = CGSizeMake(CGRectGetWidth(self.frame),
                         CGRectGetMinY(previousFrame) + CGRectGetHeight(previousFrame) + self.bottomMargin + 1.0f);
    self.contentSize = sizeFit;
}

- (void)configureTagButton:(DWTagButton *)tagButton {
    tagButton.delegate = self;
    
    [tagButton setBackgroundColor:self.tagBackgroundColor];
    [tagButton setTagCornerRadius:self.cornerRadius];
    [tagButton setTagBorderWidth:self.borderWidth];
    [tagButton setTagBorderColor:self.borderColor.CGColor];
    [tagButton setTagTextFont:self.textFont];
    [tagButton setTagTextColor:self.textColor];
    [tagButton setTagTextShadowColor:self.textShadowColor];
    [tagButton setTagTextShadowOffset:self.textShadowOffset];

    if (!self.readonly) {
        [tagButton addTarget:self action:@selector(touchDownInside:) forControlEvents:UIControlEventTouchDown];
        [tagButton addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [tagButton addTarget:self action:@selector(touchDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [tagButton addTarget:self action:@selector(touchDragInside:) forControlEvents:UIControlEventTouchDragInside];
    }
}

#pragma mark - DWTagButtonDelegate

- (void)tagButtonDeleteAction:(DWTagButton *)tagButton {
    NSMutableArray *mutableTags = [NSMutableArray arrayWithArray:self.tags];
    [mutableTags removeObject:tagButton.tagValue];
    self.tags = mutableTags;
    
    if ([self.tagDelegate respondsToSelector:@selector(tagView:didRemoveTag:)]) {
        [self.tagDelegate tagView:self didRemoveTag:tagButton.tagValue];
    }
}

- (BOOL)tagButtonCanBecomeFirstResponder {
    return self.showMenu;
}

- (BOOL)tagButtonMenuControllerCanPerformAction:(SEL)action {
    if (!self.showMenu) {
        return NO;
    }
    
    if ([self.tagDelegate respondsToSelector:@selector(tagView:menuControllerCanPerformAction:)]) {
        return [self.tagDelegate tagView:self menuControllerCanPerformAction:action];
    }
    
    return (action == @selector(copy:)) || (action == @selector(delete:));
}

#pragma mark - Actions

- (void)touchDownInside:(id)sender {
    UIButton *button = (UIButton *)sender;
    [button setBackgroundColor:self.highlightedBackgroundColor];
}

- (void)touchUpInside:(id)sender {
    DWTagButton *tagButton = (DWTagButton *)sender;
    [tagButton setBackgroundColor:self.tagBackgroundColor];
    
    [tagButton becomeFirstResponder];
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setTargetRect:tagButton.frame inView:self];
    [menuController setMenuVisible:YES animated:YES];
    
    if ([self.tagDelegate respondsToSelector:@selector(tagView:didSelectTag:)]) {
        [self.tagDelegate tagView:self didSelectTag:tagButton.tagValue];
    }
}

- (void)touchDragExit:(id)sender {
    UIButton *button = (UIButton *)sender;
    [button setBackgroundColor:self.tagBackgroundColor];
}

- (void)touchDragInside:(id)sender {
    UIButton *button = (UIButton *)sender;
    [button setBackgroundColor:self.tagBackgroundColor];
}

#pragma mark - Setters
#pragma mark - Behaviour

- (void)setReadonly:(BOOL)readonly {
    if (_readonly != readonly) {
        _readonly = readonly;
        [self setNeedsLayout];
    }
}

- (void)setShowDeleteIcon:(BOOL)showDeleteIcon {
    if (_showDeleteIcon != showDeleteIcon) {
        _showDeleteIcon = showDeleteIcon;
        [self setNeedsLayout];
    }
}

#pragma mark - Background

- (void)setTagBackgroundColor:(UIColor *)color {
    _tagBackgroundColor = color;
    [self setNeedsLayout];
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor {
    _highlightedBackgroundColor = highlightedBackgroundColor;
    [self setNeedsLayout];
}

#pragma mark - Border

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsLayout];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    [self setNeedsLayout];
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self setNeedsLayout];
}

#pragma mark - Text

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    [self setNeedsLayout];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self setNeedsLayout];
}

- (void)setTextShadowColor:(UIColor *)textShadowColor {
    _textShadowColor = textShadowColor;
    [self setNeedsLayout];
}

- (void)setTextShadowOffset:(CGSize)textShadowOffset {
    _textShadowOffset = textShadowOffset;
    [self setNeedsLayout];
}

#pragma mark - Dynamic height

+ (CGFloat)heightForTags:(NSArray *)tags font:(UIFont *)font width:(CGFloat)width {
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    
    for (id tag in tags) {
        CGSize tagSize = [DWTagButton tagButtonSize:tag
                                               font:font
                                 constrainedToWidth:width - kHorizontalPadding * 2
                                            padding:CGSizeMake(kHorizontalPadding, kVerticalPadding)
                                       minimumWidth:0.f];
        
        CGRect tagFrame = CGRectMake(0.f, 0.f, tagSize.width, tagSize.height);
        if (gotPreviousFrame) {
            CGFloat left = CGRectGetMinX(previousFrame) + CGRectGetWidth(previousFrame);
            if (left + tagSize.width + kLabelMargin > width) {
                tagFrame.origin = CGPointMake(0.f, CGRectGetMinY(previousFrame) + tagSize.height + kBottomMargin);
            } else {
                tagFrame.origin = CGPointMake(left + kLabelMargin, CGRectGetMinY(previousFrame));
            }
        }
        
        previousFrame = tagFrame;
        gotPreviousFrame = YES;
    }
    
    CGFloat height = previousFrame.origin.y + previousFrame.size.height + kBottomMargin + 1.f;
    
#if defined(__LP64__) && __LP64__
    return ceil(height);
#else
    return ceilf(height);
#endif
}

@end
