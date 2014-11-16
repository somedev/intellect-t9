//
//  BaseManager.m
//  IntellectT9
//
//  Created by Алексей Шадура on 15.11.14.
//  Copyright (c) 2014 Intellectsoft. All rights reserved.
//

#import "BaseManager.h"
#import "RWordEng.h"
#import "RWordRus.h"

#define EQUAL @"="
#define BEGINSWITH @"BEGINSWITH"

#define LIMIT 20

@interface BaseManager ()

@property (nonatomic, retain) RLMRealm* realm;

@end

@implementation BaseManager

#define FILENAME @"Words.realm"

SINGLETON_IMPLEMENTATION(BaseManager)

- (instancetype)init
{
    self = [super init];
    if (self) {

        if (![[NSFileManager defaultManager] fileExistsAtPath:self.path]) {
            NSString* original = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:FILENAME];
            NSError* error;
            [[NSFileManager defaultManager] copyItemAtPath:original toPath:self.path error:&error];
        }
        _realm = [RLMRealm realmWithPath:self.path];
    }

    return self;
}

- (NSString*)path
{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [NSString stringWithFormat:@"%@/%@", path, FILENAME];
    return path;
}

- (void)wordsForKey:(NSString*)key result:(BaseManagerSearchResult)resultBlock
{
    __weak BaseManager* wSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [wSelf wordsForLanguage:_language type:_type forKey:key command:EQUAL result:^(NSArray *equal) {
            dispatch_async(dispatch_get_main_queue(), ^{
                resultBlock(equal);
            });
        }];
    });
}

- (void)wordsStartWithKey:(NSString*)key result:(BaseManagerSearchResult)resultBlock
{
    __weak BaseManager* wSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [wSelf wordsForLanguage:_language type:_type forKey:key command:BEGINSWITH result:^(NSArray *equal) {
            dispatch_async(dispatch_get_main_queue(), ^{
                resultBlock(equal);
            });
        }];
    });
}

- (void)wordsForLanguage:(KeyboardLang)language
                    type:(KeyboardType)type
                  forKey:(NSString*)key
                 command:(NSString*)command
                  result:(BaseManagerSearchResult)resultBlock
{
    RLMRealm* curentRealm;
    if ([NSThread isMainThread]) {
        curentRealm = _realm;
    }
    else {
        curentRealm = [RLMRealm realmWithPath:self.path];
    }

    NSString* typeKey;
    DLog(@"lang %li", language);
    switch (type) {
    case KeyboardTypeABC: {
        typeKey = @"abckey";
    } break;
    default:
        typeKey = @"qwrtykey";
        break;
    }

    NSString* query = [NSString stringWithFormat:@"%@ %@ '%@'", typeKey, command, key];

    if ([command isEqualToString:BEGINSWITH]) {
        query = [NSString stringWithFormat:@"%@ AND %@ != '%@'", query, typeKey, key];
    }

    RLMResults* results;

    switch (language) {
    case KeyboardLangRus:
        results = [RWordRus objectsInRealm:curentRealm where:query];
        break;
    default:
        results = [RWordEng objectsInRealm:curentRealm where:query];
        break;
    }

    DLog(@" type %@ qr %@", [results objectClassName], typeKey);

    results = [results sortedResultsUsingProperty:@"frequency" ascending:NO];

    NSMutableArray* equal = [NSMutableArray array];

    for (int i = 0; i < MIN(results.count, LIMIT); i++) {
        RWord* word = [results objectAtIndex:i];

        [equal addObject:word.word];
    }

    resultBlock(equal);
}

@end
