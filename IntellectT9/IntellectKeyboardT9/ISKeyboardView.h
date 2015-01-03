//
//  ISKeyboardView.h
//  IntellectT9
//
//  Created by Eduard Panasiuk on 11/15/14.
//  Copyright (c) 2014 Intellectsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardManager.h"

@interface ISKeyboardView : UIView

@property (nonatomic, copy) void (^keyPressedCallback)(PressedKeyType keyType);

@property (weak, nonatomic) IBOutlet UICollectionView *predicateView;

- (void)setPredictViewHidden:(BOOL)hidden withAnimationDuration:(CGFloat)duration;

- (void)updateConstraintsInLandscape:(BOOL)landscape duration:(CGFloat)duration;

@end
