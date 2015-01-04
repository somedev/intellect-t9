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
@property (nonatomic, weak) id<UITextDocumentProxy> lastTextInputProxy;
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
        DATABASE_MANAGER.language = self.currentLanguage;
        DATABASE_MANAGER.type = self.currentType;
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
    self.lastTextInputProxy = textInputProxy;
    NSString* text = textInputProxy.documentContextBeforeInput;

    __weak typeof(self) wself = self;
    if (text.length <= 0 || [text endsWithWordSeparator]) {
        [wself clearStack];
        return;
    }

    NSArray* keyNumbers = [self.keyBoardModel keyNumbersFromText:text
                                                    keyboardType:self.currentType
                                                        language:self.currentLanguage];

    [self.keyStack clear];
    [self.keyStack pushArray:keyNumbers];

    NSString *lastWord = [text lastTextComponent];
    
    [DATABASE_MANAGER searchActulWordsForKey:[self keyStory]
                                      result:^(NSArray *words) {
                                          
                                          if(words.count > 0){
                                              [wself updatePrediction:words currentWord:lastWord];
                                          }
                                          else{
                                              //TODO: show keys on prediction window
                                              [wself updatePrediction:@[lastWord] currentWord:lastWord];
                                          }
                                      }];
}

- (void)processKeyPressWithPressedKeyType:(PressedKeyType)keyType
                           textInputProxy:(id<UITextDocumentProxy>)textInputProxy
{
    self.lastTextInputProxy = textInputProxy;
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
        [self clearStack];
        break;
    case PressedKeyTypeSpaseLong:
        // open new keyboard
        // [textInputProxy insertText:@":)"];
        return;
        break;
    case PressedKeyTypeEnter:
        [textInputProxy insertText:@"\n"];
        [self clearStack];
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
        [DATABASE_MANAGER searchActulWordsForKey:[self keyStory]
                                          result:^(NSArray *results) {
                                              if(results.count > 0){
                                                  //clean previous word
                                                  NSString* topWord = results.firstObject;
                                                  
                                                  [self replacePreviousInputWithText:topWord useFullWord:NO];
                                                  [wself updatePrediction:results currentWord:topWord];
                                                  
                                              }
                                              else{
                                                  //TODO: show keys on prediction window
                                                  [wself.keyStack pop];
                                              }
                                              
                                              DLog(@"%@", [self keyStory]);
                                          }];
        
    }
}



- (void)selectedWordFromPrediction:(NSString *)selectedWord
{
    //TODO replace implementation needed
    DLog(@"selected word %@",selectedWord);
    [self replacePreviousInputWithText:selectedWord useFullWord:YES];
    [self processSelectionChangeFrorTextInputProxy:self.lastTextInputProxy];
}

#pragma mark - Utils
- (void)replacePreviousInputWithText:(NSString *)text useFullWord:(BOOL)useFullWord
{
    if(!self.lastTextInputProxy){
        return;
    }
    
    //clean previous word
    NSString *proxyText = self.lastTextInputProxy.documentContextBeforeInput;
    NSString *lastWord = [proxyText endsWithWordSeparator] ? nil : [proxyText lastTextComponent];
    if(lastWord){
        for (int i=0; i<lastWord.length; i++) {
            [self.lastTextInputProxy deleteBackward];
        };
    }
    
    NSRange partRange = NSMakeRange(0, self.keyStack.count);
    NSString *topWord = useFullWord ? text : [text substringWithRange:partRange];
    
    [self.lastTextInputProxy insertText:topWord];
}

- (void)updatePrediction:(NSArray *)results currentWord:(NSString *)currentWord
{
    if (self.predictionUpdateCallback) {
        self.predictionUpdateCallback(results, currentWord);
    }
}

- (void)clearStack
{
    [self.keyStack clear];
    [self updatePrediction:nil currentWord:nil];
}

- (NSString*)keyStory
{
    if (self.keyStack.count <= 0) {
        return 0;
    }
    return [self.keyStack.allItems componentsJoinedByString:@""];
}

@end
