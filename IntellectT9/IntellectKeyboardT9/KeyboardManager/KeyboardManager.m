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
#import "KeyboardModel.h"

@interface KeyboardManager ()
@property (nonatomic, strong) EPStack* keyStack;
@property (nonatomic, assign) KeyboardLang currentLanguage;
@property (nonatomic, assign) KeyboardType currentType;
@property (nonatomic, strong) KeyboardModel* keyBoardModel;
@end

@implementation KeyboardManager

SINGLETON_IMPLEMENTATION(KeyboardManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentType = KeyboardTypeQWERTY;
        self.currentLanguage = KeyboardTypeABC;
        self.keyBoardModel = [KeyboardModel new];
    }
    return self;
}

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
        if (self.keyStack.count > 0) {
            [self.keyStack pop];
            [textInputProxy deleteBackward];
            [textInputProxy deleteBackward];
        }
        else {
            [textInputProxy deleteBackward];
        }

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

        __weak typeof(self) wself = self;
        [MANAGER wordsForKey:[wself keyStory] result:^(NSArray* results) {
            if(results.count > 0){
                NSString* topWord = results.firstObject;
                for (int i = 0; i < wself.keyStack.count - 1; i++) {
                    [textInputProxy deleteBackward];
                }
                [textInputProxy insertText:topWord];
                
                if (wself.predictionUpdateCallback) {
                    wself.predictionUpdateCallback(results);
                }
            }
            else{
                [wself.keyStack pop];
            }
            
            DLog(@"%@", [self keyStory]);
                      }];
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
