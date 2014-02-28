//
//  ViewController.m
//  DWTagList
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tagList = [[DWTagList alloc] initWithFrame:CGRectMake(20.0f, 70.0f, self.view.bounds.size.width-40.0f, 50.0f)];
    _tagList.automaticResize = YES;
    _tagList.showMenu = YES;
    _array = [[NSMutableArray alloc] initWithObjects:@"Foo",
                        @"Tag Label 1",
                        @"Tag Label 2",
                        @"Tag Label 3",
                        @"Tag Label 4",
                        @"Long long long long long Tag vgbhjknhbgvjbknhbvghbjknjhbv", nil];
    _tagList.tags = _array;
    _tagList.tagDelegate = self;
    _tagList.cornerRadius = 4.f;
    _tagList.borderColor = [UIColor lightGrayColor];
    _tagList.borderWidth = 1.f;
    _tagList.showDeleteIcon = YES;
    _tagList.showAddTagButton = YES;
    [self.view addSubview:_tagList];
}

#pragma mark - DWTagListDelegate

- (BOOL)tagView:(DWTagList *)tagView menuControllerCanPerformAction:(SEL)action {
    return (action == @selector(delete:));
}

- (void)tagView:(DWTagList *)tagView didSelectTag:(id)tag {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message (disable this alert to see menu on tag)"
                                                    message:[NSString stringWithFormat:@"You tapped tag %@", tag]
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)tagView:(DWTagList *)tagView didRemoveTag:(id)tag {
    [_array removeObject:tag];
    NSLog(@"didRemoveTag %@", tag);
}

- (void)tagViewAddTagButtonAction:(DWTagList *)tagView {
    [_array addObject:@"trololo"];
    [_tagList setTags:_array];
    
    NSLog(@"tagViewAddTagButtonAction");
}

#pragma mark - Actions

- (IBAction)tappedAdd:(id)sender
{
    [_addTagField resignFirstResponder];
    [_array addObject:[_addTagField text]];
    [_addTagField setText:@""];
    [_tagList setTags:_array];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
