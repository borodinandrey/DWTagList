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

- (void)tagView:(DWTagList *)tagView tagButtonAction:(UIButton *)tagButton tagValue:(id)tagValue {
    NSLog(@"tagButtonAction %@", tagValue);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[NSString stringWithFormat:@"You tapped tag %@", tagValue]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)tagView:(DWTagList *)tagView addButtonAction:(UIButton *)addButton {
    NSLog(@"addButtonAction");
    
    [_array addObject:@"trololo"];
    [_tagList setTags:_array];
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
