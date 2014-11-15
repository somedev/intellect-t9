//
//  BaseManager.h
//  IntellectT9
//
//  Created by Алексей Шадура on 15.11.14.
//  Copyright (c) 2014 Intellectsoft. All rights reserved.
//

#define SINGLETON_INTERFACE +(instancetype)sharedInstance;
#define SINGLETON_IMPLEMENTATION(_CLASS_NAME_)                                         \
+(instancetype)sharedInstance                                                      \
{                                                                                  \
    __strong static _CLASS_NAME_ *sharedInstance = nil;                            \
    static dispatch_once_t onceToken;                                              \
    dispatch_once(&onceToken, ^{ sharedInstance = [[_CLASS_NAME_ alloc] init]; }); \
    return sharedInstance;                                                         \
}

#define MANAGER [BaseManager sharedInstance]

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

typedef enum{
    Eng = 0,
    Rus
}Language;

typedef enum{
    QWERTY = 0,
    ABC
}TypeKeys;
@interface BaseManager : NSObject

SINGLETON_INTERFACE

- (NSArray *)wordsForLanguage:(Language)language type:(TypeKeys)type forKey:(NSString *)key;

@end
