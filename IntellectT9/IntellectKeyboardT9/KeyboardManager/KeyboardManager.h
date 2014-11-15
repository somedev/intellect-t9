//
//  KeyboardManager.h
//  IntellectT9
//
//  Created by Eduard Panasiuk on 11/15/14.
//  Copyright (c) 2014 Intellectsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "defines.h"

typedef NS_ENUM(NSInteger, PressedKeyType) {
    PressedKeyType1 = 1,
    PressedKeyType2 = 2,
    PressedKeyType3 = 3,
    PressedKeyType4 = 4,
    PressedKeyType5 = 5,
    PressedKeyType6 = 6,
    PressedKeyType7 = 7,
    PressedKeyType8 = 8,
    PressedKeyType9 = 9,
    PressedKeyType0 = 0,
    PressedKeyTypeShift = 33,
    PressedKeyTypeBackSpace = 34,
    PressedKeyTypeSmiles = 35,
    PressedKeyTypeEnter = 36,
    PressedKeyTypeSpaseLong = 137,
    PressedKeyTypeSpase = 37,
    PressedKeyTypeNextKeyboard = 888
};

@protocol UITextDocumentProxy;

@interface KeyboardManager : NSObject
SINGLETON_INTERFACE

- (void)processKeyPressWithPressedKeyType:(PressedKeyType)keyType textInputProxy:(id<UITextDocumentProxy>)textInputProxy;

@end
