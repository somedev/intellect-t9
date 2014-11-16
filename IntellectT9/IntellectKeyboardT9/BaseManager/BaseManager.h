//
//  BaseManager.h
//  IntellectT9
//
//  Created by Алексей Шадура on 15.11.14.
//  Copyright (c) 2014 Intellectsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "defines.h"

typedef void (^BaseManagerSearchResult)(NSArray* words);

typedef enum {
    Eng = 0,
    Rus = 1
} Language;

typedef enum {
    QWERTY = 0,
    ABC = 1
} TypeKeys;

#define EQUAL @"="
#define BEGINSWITH @"BEGINSWITH"

#define LIMIT 20

@interface BaseManager : NSObject

@property (nonatomic, assign) Language language;
@property (nonatomic, assign) TypeKeys type;

SINGLETON_INTERFACE

- (void)wordsForLanguage:(Language)language type:(TypeKeys)type forKey:(NSString*)key command:(NSString*)command result:(BaseManagerSearchResult)resultBlock;
- (void)wordsForKey:(NSString*)key result:(BaseManagerSearchResult)resultBlock;
- (void)wordsStartWithKey:(NSString*)key result:(BaseManagerSearchResult)resultBlock;

@end
