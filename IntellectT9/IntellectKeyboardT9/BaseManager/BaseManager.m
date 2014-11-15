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

- (void)wordsForKey:(NSString*)key language:(Language)language type:(TypeKeys)type result:(BaseManagerSearchResult)resultBlock
{
    __weak BaseManager* wSelf = self;
    NSArray* result = [wSelf wordsForLanguage:language type:type forKey:key];
    resultBlock(result);
}

- (NSArray*)wordsForLanguage:(Language)language type:(TypeKeys)type forKey:(NSString*)key
{
    RLMRealm* curentRealm;
    if ([NSThread isMainThread]) {
        curentRealm = _realm;
    }
    else {
        curentRealm = [RLMRealm realmWithPath:self.path];
    }

    NSString* typeKey;
    DLog(@"lang %i",language);
    switch (type) {
    case ABC: {
        typeKey = @"abckey";
    } break;
    default:
        typeKey = @"qwrtykey";
        break;
    }

    NSString* query = [NSString stringWithFormat:@"%@ = '%@'", typeKey, key];

    RLMResults* results;

    switch (type) {
    case Rus:
        results = [RWordRus objectsInRealm:curentRealm where:query];
        break;
    default:
        results = [RWordEng objectsInRealm:curentRealm where:query];
        break;
    }
    
    DLog(@" type %@",[results objectClassName]);
    
    results = [results sortedResultsUsingProperty:@"frequency" ascending:NO];

    NSMutableArray* words = [NSMutableArray array];

    for (int i = 0; i < results.count; i++) {
        RWord* word = [results objectAtIndex:i];
        [words addObject:word.word];
    }

    return words;
}

@end
