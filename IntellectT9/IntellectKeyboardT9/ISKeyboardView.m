//
//  ISKeyboardView.m
//  IntellectT9
//
//  Created by Eduard Panasiuk on 11/15/14.
//  Copyright (c) 2014 Intellectsoft. All rights reserved.
//

#import "ISKeyboardView.h"

static CGFloat const kPredictViewHeight = 44.0;

@interface ISKeyboardView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* predictViewHeightConstraint;
- (IBAction)keyPressed:(UIButton*)sender;
@end

@implementation ISKeyboardView

- (IBAction)keyPressed:(UIButton*)sender
{
    if (self.keyPressedCallback) {
        self.keyPressedCallback(sender.tag);
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

@end
