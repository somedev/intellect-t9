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
#import "NSString+Additions.h"

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
        self.currentLanguage = KeyboardLangEng;
        self.keyBoardModel = [KeyboardModel new];
        MANAGER.language = self.currentLanguage;
        MANAGER.type = self.currentType;
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
- (void)processSelectionChangeFrorTextInputProxy:(id<UITextDocumentProxy>)textInputProxy
{
    NSString* text = textInputProxy.documentContextBeforeInput;

    if (text.length <= 0) {
        return;
    }

    NSArray* keyNumbers = [self.keyBoardModel keyNumbersFromText:text
                                                    keyboardType:self.currentType
                                                        language:self.currentLanguage];

    [self.keyStack clear];
    [self.keyStack pushArray:keyNumbers];

    __weak typeof(self) wself = self;
    [MANAGER wordsForKey:[wself keyStory] result:^(NSArray* results) {
        if(results.count > 0){
            if (wself.predictionUpdateCallback) {
                wself.predictionUpdateCallback(results, text);
            }
        }
        else{
            [MANAGER wordsStartWithKey:[wself keyStory]
                                result:^(NSArray *words) {
                                    if(words.count > 0){
                                        if (wself.predictionUpdateCallback) {
                                            wself.predictionUpdateCallback(words, text);
                                        }
                                    }
                                    else{
                                        //TODO: show keys
                                    }
                                }];
            
        }

    }];
}

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
    case PressedKeyTypeBackSpace: {
        if (self.keyStack.count > 0) {
            [self.keyStack pop];
            if (textInputProxy.documentContextBeforeInput.length > 0) {
                [textInputProxy deleteBackward];
            }
        }
        else {
            [textInputProxy deleteBackward];
        }
        [self processSelectionChangeFrorTextInputProxy:textInputProxy];
        return;
        break;
    }

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
                for (int i = 0; i < self.keyStack.count - 1; i++) {
                    [textInputProxy deleteBackward];
                }
                
                [textInputProxy insertText:topWord];
                
                if (wself.predictionUpdateCallback) {
                    wself.predictionUpdateCallback(results, topWord);
                }
            }
            else{
                [MANAGER wordsStartWithKey:[wself keyStory]
                                    result:^(NSArray *words) {
                                        if(words.count > 0){
                                            NSString* topWord = words.firstObject;
                                            for (int i = 0; i < self.keyStack.count - 1; i++) {
                                                [textInputProxy deleteBackward];
                                            }
                                            
                                            NSRange partRange = NSMakeRange(0, wself.keyStack.count);
                                            topWord = [topWord substringWithRange:partRange];
                                            
                                            [textInputProxy insertText:topWord];
                                        }
                                        else{
                                            [wself.keyStack pop];
                                        }
                                        
                                        DLog(@"%@", [self keyStory]);
                                    }];
                
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
