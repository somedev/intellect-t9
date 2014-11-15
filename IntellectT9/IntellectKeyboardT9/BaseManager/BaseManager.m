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
        NSArray *result = [wSelf wordsForLanguage:_language type:_type forKey:key];
        dispatch_async(dispatch_get_main_queue(), ^{
            resultBlock(result);
        });
    });
}

- (NSArray*)wordsForLanguage:(Language)language type:(TypeKeys)type forKey:(NSString*)key
{
    RLMRealm *curentRealm;
    if ([NSThread isMainThread]) {
        curentRealm = _realm;
    } else
    {
        curentRealm = [RLMRealm realmWithPath:self.path];
    }
    Class lanClass;
    switch (type) {
    case 1:
        lanClass = [RWordRus class];
        break;
    default:
        lanClass = [RWordEng class];
        break;
    }

    NSString* typeKey;
    switch (type) {
    case 1:
        typeKey = @"abckey";
        break;
    default:
        typeKey = @"qwrtykey";
        break;
    }

    NSString* query = [NSString stringWithFormat:@"%@ = '%@'", typeKey, key];

    RLMResults* results = [RWordRus objectsInRealm:curentRealm where:query];
    results = [results sortedResultsUsingProperty:@"frequency" ascending:NO];
    
    NSMutableArray* words = [NSMutableArray array];

    for (int i = 0; i < results.count; i++) {
        RWord* word = [results objectAtIndex:i];
        [words addObject:word.word];
    }

    return words;
}

@end
