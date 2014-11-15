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

@property (nonatomic, retain) RLMRealm *realm;

@end

@implementation BaseManager

#define FILENAME @"Words.realm"

SINGLETON_IMPLEMENTATION(BaseManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Words.realm"];
        NSError *error;
        _realm = [RLMRealm realmWithPath:path readOnly:YES error:&error];
        
    }
    
    return self;
}

- (NSArray *)wordsForLanguage:(Language)language type:(TypeKeys)type forKey:(NSString *)key
{
    Class lanClass;
    switch (type) {
        case 0:
            lanClass = [RWordRus class];
            break;
        default:
            lanClass = [RWordEng class];
            break;
    }
    
    NSString *typeKey;
    switch (type) {
        case 0:
            typeKey = @"abckey";
            break;
        default:
            typeKey = @"qwrtykey";
            break;
    }
    
    RLMResults *words = [lanClass objectsWhere:@"%@ = '%@'",typeKey,key];
    
    return nil;
}

@end
