//
//  types.h
//  IntellectT9
//
//  Created by Eduard Panasiuk on 11/16/14.
//  Copyright (c) 2014 Intellectsoft. All rights reserved.
//

#ifndef IntellectT9_types_h
#define IntellectT9_types_h

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
    PressedKeyTypeSwitchNumbers = 38,
    PressedKeyTypeChangeLanguage = 39,
    PressedKeyTypeNextKeyboard = 888
};

typedef NS_ENUM(NSInteger, KeyboardLang) {
    KeyboardLangEng = 0,
    KeyboardLangRus = 1
};

typedef NS_ENUM(NSInteger, KeyboardType) {
    KeyboardTypeQWERTY = 0,
    KeyboardTypeABC = 1
};

#endif
