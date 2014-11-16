//
//  BaseManager.h
//  IntellectT9
//
//  Created by Алексей Шадура on 15.11.14.
//  Copyright (c) 2014 Intellectsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

typedef void (^BaseManagerSearchResult)(NSArray* words);

@interface BaseManager : NSObject

@property (nonatomic, assign) KeyboardLang language;
@property (nonatomic, assign) KeyboardType type;

SINGLETON_INTERFACE

- (void)wordsForLanguage:(KeyboardLang)language
                    type:(KeyboardType)type
                  forKey:(NSString*)key
                 command:(NSString*)command
                  result:(BaseManagerSearchResult)resultBlock;
- (void)wordsForKey:(NSString*)key result:(BaseManagerSearchResult)resultBlock;
- (void)wordsStartWithKey:(NSString*)key result:(BaseManagerSearchResult)resultBlock;

@end
