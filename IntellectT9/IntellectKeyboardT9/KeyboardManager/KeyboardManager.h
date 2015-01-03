//
//  KeyboardManager.h
//  IntellectT9
//
//  Created by Eduard Panasiuk on 11/15/14.
//  Copyright (c) 2014 Intellectsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UITextDocumentProxy;
@class KeyboardModel;

@interface KeyboardManager : NSObject
SINGLETON_INTERFACE
@property (nonatomic, readonly) KeyboardModel* keyBoardModel;
@property (nonatomic, copy) void (^predictionUpdateCallback)(NSArray* results, NSString* currentResult);

- (void)processKeyPressWithPressedKeyType:(PressedKeyType)keyType textInputProxy:(id<UITextDocumentProxy>)textInputProxy;
- (void)processSelectionChangeFrorTextInputProxy:(id<UITextDocumentProxy>)textInputProxy;

- (void)selectedWordFromPrediction:(NSString *)selectedWord;
@end
