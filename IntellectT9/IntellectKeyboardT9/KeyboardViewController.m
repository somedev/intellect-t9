//
//  KeyboardViewController.m
//  IntellectKeyboardT9
//
//  Created by Eduard Panasiuk on 11/15/14.
//  Copyright (c) 2014 Intellectsoft. All rights reserved.
//

#import "KeyboardViewController.h"
#import "ISKeyboardView.h"
#import "BaseManager.h"

#pragma mark - Constants
static CGFloat const kKeyboardHeightPortrait = 260.0;
static CGFloat const kKeyboardHeightLandscape = 162.0;

@interface KeyboardViewController ()
@property (nonatomic, strong) NSLayoutConstraint* heightConstraint;
@property (nonatomic, strong) ISKeyboardView* mainKeyboardView;
@end

@implementation KeyboardViewController

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [MANAGER wordsForLanguage:Rus type:QWERTY forKey:@"111"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadKeyboardNib];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addHeightConstraint];
}

#pragma mark - Rotation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    BOOL portrait = UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
    [UIView animateWithDuration:duration
                     animations:^{
                         self.heightConstraint.constant = portrait ? kKeyboardHeightPortrait : kKeyboardHeightLandscape;
                         [self.view layoutIfNeeded];
                     }];

    [self.mainKeyboardView setPredictViewHidden:!portrait withAnimationDuration:duration];
}

#pragma mark - UITextInputDelegate
- (void)textWillChange:(id<UITextInput>)textInput
{
    // The app is about to change the document's contents. Perform any preparation
    // here.
}

- (void)textDidChange:(id<UITextInput>)textInput
{
    // The app has just changed the document's contents, the document context has
    // been updated.
}

- (void)selectionWillChange:(id<UITextInput>)textInput
{
}

- (void)selectionDidChange:(id<UITextInput>)textInput
{
}

#pragma mark - Utils
- (void)loadKeyboardNib
{
    UIView* keyboardView = [[[NSBundle mainBundle] loadNibNamed:@"ISKeyboardView"
                                                          owner:self
                                                        options:nil] firstObject];
    self.mainKeyboardView = (ISKeyboardView*)keyboardView;
    [self.view addSubview:self.mainKeyboardView];
    self.mainKeyboardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[mainKeyboardView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{ @"mainKeyboardView" : self.mainKeyboardView }]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[mainKeyboardView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{ @"mainKeyboardView" : self.mainKeyboardView }]];

    __weak typeof(self) wself = self;
    self.mainKeyboardView.keyPressedCallback = ^(PressedKeyType keyType) {
        
        switch (keyType) {
            case PressedKeyType1:
            
                break;
            case PressedKeyType2:
                
                break;
            case PressedKeyType3:
                
                break;
            case PressedKeyType4:
                
                break;
            case PressedKeyType5:
                
                break;
            case PressedKeyType6:
                
                break;
            case PressedKeyType7:
                
                break;
            case PressedKeyType8:
                
                break;
            case PressedKeyType9:
                
                break;
            case PressedKeyType0:
                
                break;
            case PressedKeyTypeShift:
                
                break;
            case PressedKeyTypeBackSpace:
                
                break;
            case PressedKeyTypeSmiles:
                
                break;
            case PressedKeyTypeEnter:
                
                break;
            case PressedKeyTypeNextKeyboard:
                [wself.view layoutIfNeeded];
                [wself advanceToNextInputMode];
                break;
                
            default:
                break;
        }
    };
}

- (void)addHeightConstraint
{
    if (self.heightConstraint) {
        return;
    }

    self.heightConstraint =
        [NSLayoutConstraint constraintWithItem:self.view
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:0.0
                                      constant:(self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) ? kKeyboardHeightLandscape : kKeyboardHeightPortrait];

    [self.view addConstraint:self.heightConstraint];
    [self.view setNeedsLayout];
}

@end
