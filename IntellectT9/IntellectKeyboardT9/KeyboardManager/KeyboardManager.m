//
//  KeyboardManager.m
//  IntellectT9
//
//  Created by Eduard Panasiuk on 11/15/14.
//  Copyright (c) 2014 Intellectsoft. All rights reserved.
//

#import "KeyboardManager.h"
#import <UIKit/UIKit.h>
#import "EPStack.h"
#import "BaseManager.h"

@interface KeyboardManager ()
@property (nonatomic, strong) EPStack* keyStack;
@end

@implementation KeyboardManager

SINGLETON_IMPLEMENTATION(KeyboardManager)

#pragma mark - properties
- (EPStack*)keyStack
{
    if (_keyStack == nil) {
        _keyStack = [[EPStack alloc] initWithMaxCapacity:100];
    }
    return _keyStack;
}

#pragma mark - processing
- (void)processKeyPressWithPressedKeyType:(PressedKeyType)keyType
                           textInputProxy:(id<UITextDocumentProxy>)textInputProxy
{
    switch (keyType) {
    case PressedKeyType1:
    case PressedKeyType2:
    case PressedKeyType3:
    case PressedKeyType4:
    case PressedKeyType5:
    case PressedKeyType6:
    case PressedKeyType7:
    case PressedKeyType8:
    case PressedKeyType9:
        [self.keyStack push:@(keyType)];
        break;
    case PressedKeyTypeShift:

        break;
    case PressedKeyTypeBackSpace:
        [textInputProxy deleteBackward];
        [self.keyStack pop];
        break;

    case PressedKeyTypeSmiles:

        break;
    case PressedKeyTypeSpase:
        [textInputProxy insertText:@" "];
        [self.keyStack clear];
        break;
    case PressedKeyTypeSpaseLong:
        // open new keyboard
        // [textInputProxy insertText:@":)"];
        return;
        break;
    case PressedKeyTypeEnter:
        [textInputProxy insertText:@"\n"];
        [self.keyStack clear];
        break;

    default:
        break;
    }

    [self updateKeysForTextInputProxy:textInputProxy];
}

- (void)updateKeysForTextInputProxy:(id<UITextDocumentProxy>)textInputProxy
{
    if (self.keyStack.count > 0) {
        DLog(@"%@", [self keyStory]);
    }
}

- (NSString*)keyStory
{
    if (self.keyStack.count <= 0) {
        return 0;
    }
    return [self.keyStack.allItems componentsJoinedByString:@""];
}

@end
