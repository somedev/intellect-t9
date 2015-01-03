//
//  ISKeyboardView.m
//  IntellectT9
//
//  Created by Eduard Panasiuk on 11/15/14.
//  Copyright (c) 2014 Intellectsoft. All rights reserved.
//

#import "ISKeyboardView.h"

static CGFloat const kPredictViewHeight = 44.0;
static NSTimeInterval const kLongPressTimeInterval = 1.0;

static CGFloat const kTopLanscapeValue = 1.0;
static CGFloat const kTopPortraitValue = 12;

static CGFloat const kLanscapeValue = 1.0;
static CGFloat const kPortraitValue = 15;

static CGFloat const kLanscapeLeftValue = 67.0;
static CGFloat const kPortraitLeftValue = 3.0;

static CGFloat const kLanscapeEnterBottomValue = 3.0;
static CGFloat const kPortraitEnterBottomValue = 57.0;

@interface ISKeyboardView ()

@property (nonatomic, assign) NSInteger downPressedKeyTag;
@property (nonatomic, strong) NSTimer* keyTimer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* middleConstaraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* lowerMiddleConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* enterBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* predictViewHeightConstraint;


- (IBAction)keyUp:(UIButton*)sender;

- (IBAction)keyDown:(UIButton*)sender;

@end

@implementation ISKeyboardView

- (IBAction)keyDown:(UIButton*)sender
{
    self.downPressedKeyTag = sender.tag;
    [self.keyTimer invalidate];
    self.keyTimer = [NSTimer scheduledTimerWithTimeInterval:kLongPressTimeInterval
                                                     target:self
                                                   selector:@selector(timerFired)
                                                   userInfo:nil
                                                    repeats:NO];
}

- (IBAction)keyUp:(UIButton*)sender
{
    [self.keyTimer invalidate];

    if (self.downPressedKeyTag == NSIntegerMax && sender.tag == PressedKeyTypeSpase) {
        return;
    }

    if (self.downPressedKeyTag == sender.tag) {
        self.downPressedKeyTag = NSIntegerMax;
    }

    NSInteger tag = sender.tag;
    if (self.keyPressedCallback) {
        self.keyPressedCallback(tag);
    }
}

- (void)setPredictViewHidden:(BOOL)hidden withAnimationDuration:(CGFloat)duration
{
    [self layoutIfNeeded];
    [UIView animateWithDuration:duration
                     animations:^{
                         self.predictViewHeightConstraint.constant = hidden ? 0 : kPredictViewHeight;
                         [self layoutIfNeeded];
                     }];
}

- (void)updateConstraintsInLandscape:(BOOL)landscape duration:(CGFloat)duration
{
    [self layoutIfNeeded];
    [UIView animateWithDuration:duration
                     animations:^{
                         _topConstraint.constant = landscape ? kTopLanscapeValue : kTopPortraitValue;
                         _middleConstaraint.constant = landscape ? kLanscapeValue : kPortraitValue;
                         _lowerMiddleConstraint.constant = landscape ? kLanscapeValue : kPortraitValue;
                         _leftConstraint.constant = landscape ? kLanscapeLeftValue : kPortraitLeftValue;
                         _enterBottomConstraint.constant = landscape ? kLanscapeEnterBottomValue : kPortraitEnterBottomValue;
                     }];
}

- (void)timerFired
{
    if (self.downPressedKeyTag == PressedKeyTypeSpase) {
        self.downPressedKeyTag = NSIntegerMax;
        if (self.keyPressedCallback) {
            self.keyPressedCallback(PressedKeyTypeSpaseLong);
        }
    }
    [self.keyTimer invalidate];
}

@end
