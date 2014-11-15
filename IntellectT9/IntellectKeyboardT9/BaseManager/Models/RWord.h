//
//  Word.h
//  base
//
//  Created by Алексей Шадура on 15.11.14.
//  Copyright (c) 2014 IntellectSoft. All rights reserved.
//

#import <Realm/Realm.h>

@interface RWord : RLMObject

@property NSString *word;
@property NSInteger qwrtykey;
@property NSUInteger abckey;
@property NSUInteger frequency;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Word>
RLM_ARRAY_TYPE(Word)
