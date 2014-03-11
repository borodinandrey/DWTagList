//
//  DWTagList.h
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWTagButton.h"

@protocol DWTagListDelegate;


@interface DWTagList : UIScrollView

// Tags
//
@property (copy, readwrite, nonatomic) NSArray *tags;

// Delegate
//
@property (weak, readwrite, nonatomic) id<DWTagListDelegate> tagDelegate;

// Behaviour
//
@property (assign, readwrite, nonatomic) BOOL automaticResize;
@property (assign, readwrite, nonatomic) BOOL readonly;
@property (assign, readwrite, nonatomic) BOOL showDeleteIcon;
@property (assign, readwrite, nonatomic) BOOL showAddTagButton;

// Background
//
@property (strong, readwrite, nonatomic) UIColor *tagBackgroundColor;
@property (strong, readwrite, nonatomic) UIColor *highlightedBackgroundColor;

// Geometry
//
@property (assign, readwrite, nonatomic) CGFloat labelMargin;
@property (assign, readwrite, nonatomic) CGFloat bottomMargin;
@property (assign, readwrite, nonatomic) CGFloat horizontalPadding;
@property (assign, readwrite, nonatomic) CGFloat verticalPadding;
@property (assign, readwrite, nonatomic) CGFloat minimumWidth;

// Border
//
@property (assign, readwrite, nonatomic) CGFloat cornerRadius;
@property (assign, readwrite, nonatomic) CGFloat borderWidth;
@property (strong, readwrite, nonatomic) UIColor *borderColor;

// Text
//
@property (strong, readwrite, nonatomic) UIFont *textFont;
@property (strong, readwrite, nonatomic) UIColor *textColor;
@property (strong, readwrite, nonatomic) UIColor *textShadowColor;
@property (assign, readwrite, nonatomic) CGSize textShadowOffset;

// Dynamic height
//
+ (CGFloat)heightForTags:(NSArray *)tags font:(UIFont *)font width:(CGFloat)width showIcons:(BOOL)showIcons showAddTagButton:(BOOL)showAddTagButton;

@end

#pragma mark - Delegate

@protocol DWTagListDelegate <NSObject>

@optional

- (void)tagView:(DWTagList *)tagView tagButtonAction:(DWTagButton *)tagButton tagValue:(id)tagValue;
- (void)tagView:(DWTagList *)tagView addButtonAction:(DWTagButton *)addButton;

@end

