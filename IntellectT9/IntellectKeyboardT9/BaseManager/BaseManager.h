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


typedef void (^BaseManagerSearchResult)(NSArray *);


typedef enum {
    Eng = 0,
    Rus
} Language;

typedef enum {
    QWERTY = 0,
    ABC
} TypeKeys;
@interface BaseManager : NSObject

@property (nonatomic,assign) Language language;
@property (nonatomic,assign) TypeKeys type;

SINGLETON_INTERFACE

- (NSArray *)wordsForLanguage:(Language)language type:(TypeKeys)type forKey:(NSString *)key;
- (void)wordsForKey:(NSString *)key result:(BaseManagerSearchResult)resultBlock;


@end
