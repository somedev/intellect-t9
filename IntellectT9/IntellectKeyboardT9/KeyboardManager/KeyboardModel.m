//
//  KeyboardModel.m
//  IntellectT9
//
//  Created by Eduard Panasiuk on 11/16/14.
//  Copyright (c) 2014 Intellectsoft. All rights reserved.
//

#import "KeyboardModel.h"

@interface KeyboardModel ()
@property (nonatomic, strong) NSDictionary* keys;
@end

@implementation KeyboardModel

- (instancetype)init
{
    self = [super init];
    if (self) {
    }

    NSDictionary* keysQwertyEn = @{
        @"a" : @4,
        @"b" : @8,
        @"c" : @7,
        @"d" : @4,
        @"e" : @1,
        @"f" : @5,
        @"g" : @5,
        @"h" : @5,
        @"i" : @3,
        @"j" : @6,
        @"k" : @6,
        @"l" : @6,
        @"m" : @8,
        @"n" : @8,
        @"o" : @3,
        @"p" : @3,
        @"q" : @1,
        @"r" : @2,
        @"s" : @4,
        @"t" : @2,
        @"u" : @2,
        @"v" : @8,
        @"w" : @1,
        @"x" : @7,
        @"y" : @2,
        @"z" : @7
    };
    NSDictionary* keysQwertyRu = @{
        @"а" : @4,
        @"б" : @8,
        @"в" : @4,
        @"г" : @2,
        @"д" : @6,
        @"е" : @2,
        @"ё" : @2,
        @"ж" : @6,
        @"з" : @3,
        @"и" : @8,
        @"й" : @1,
        @"к" : @1,
        @"л" : @6,
        @"м" : @7,
        @"н" : @2,
        @"о" : @5,
        @"п" : @5,
        @"р" : @5,
        @"с" : @7,
        @"т" : @8,
        @"у" : @1,
        @"ф" : @4,
        @"х" : @3,
        @"ц" : @1,
        @"ч" : @7,
        @"ш" : @3,
        @"щ" : @3,
        @"ъ" : @3,
        @"ы" : @4,
        @"ь" : @8,
        @"э" : @6,
        @"ю" : @8,
        @"я" : @7
    };
    NSDictionary* keysABCEn = @{
        @"a" : @1,
        @"b" : @1,
        @"c" : @1,
        @"d" : @2,
        @"e" : @2,
        @"f" : @2,
        @"g" : @3,
        @"h" : @3,
        @"i" : @3,
        @"j" : @4,
        @"k" : @4,
        @"l" : @4,
        @"m" : @5,
        @"n" : @5,
        @"o" : @5,
        @"p" : @6,
        @"q" : @6,
        @"r" : @6,
        @"s" : @6,
        @"t" : @7,
        @"u" : @7,
        @"v" : @7,
        @"w" : @8,
        @"x" : @8,
        @"y" : @8,
        @"z" : @8
    };

    NSDictionary* keysABCRu = @{
        @"а" : @1,
        @"б" : @1,
        @"в" : @1,
        @"г" : @1,
        @"д" : @2,
        @"е" : @2,
        @"ё" : @2,
        @"ж" : @2,
        @"з" : @2,
        @"и" : @3,
        @"й" : @3,
        @"к" : @3,
        @"л" : @3,
        @"м" : @4,
        @"н" : @4,
        @"о" : @4,
        @"п" : @4,
        @"р" : @5,
        @"с" : @5,
        @"т" : @5,
        @"у" : @5,
        @"ф" : @6,
        @"х" : @6,
        @"ц" : @6,
        @"ч" : @6,
        @"ш" : @7,
        @"щ" : @7,
        @"ъ" : @7,
        @"ы" : @7,
        @"ь" : @8,
        @"э" : @8,
        @"ю" : @8,
        @"я" : @8
    };

    NSDictionary* keys = @{
        @(KeyboardLangEng) : @{
            @(KeyboardTypeQWERTY) : keysQwertyEn,
            @(KeyboardTypeABC) : keysABCEn
        },
        @(KeyboardLangRus) : @{
            @(KeyboardTypeQWERTY) : keysQwertyRu,
            @(KeyboardTypeABC) : keysABCRu
        }
    };

    self.keys = keys;

    return self;
}

- (NSArray*)keysForKeyNumber:(NSInteger)keyNumber
                keyboardType:(KeyboardType)keyboardType
                    language:(KeyboardLang)language
{
    return nil;
}

- (NSArray*)keyNumbersFromText:(NSString*)text
                  keyboardType:(KeyboardType)keyboardType
                      language:(KeyboardLang)language
{
    NSString* trimmedString = [[text stringByTrimmingCharactersInSet:
                                         [NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if (trimmedString.length <= 0) {
        return nil;
    }

    NSMutableArray* keyNumbers = [NSMutableArray array];
    NSDictionary* keys = [self keyDictionaryWithKeyboardType:keyboardType language:language];
    for (int i = 0; i < trimmedString.length; i++) {
        NSString* character = [trimmedString substringWithRange:NSMakeRange(i, 1)];
        id key = keys[character];
        if (key) {
            [keyNumbers addObject:key];
        }
    }

    return [keyNumbers copy];
}

- (NSDictionary*)keyDictionaryWithKeyboardType:(KeyboardType)keyboardType
                                      language:(KeyboardLang)language
{
    NSDictionary* types = self.keys[@(language)];
    if (types == nil) {
        return nil;
    }

    NSDictionary* keys = types[@(keyboardType)];
    if (keys == nil) {
        return nil;
    }

    return keys;
}

@end
