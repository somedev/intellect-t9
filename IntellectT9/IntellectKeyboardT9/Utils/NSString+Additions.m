//
//  NSString+Additions.m
//  IntellectT9
//
//  Created by Eduard Panasiuk on 11/17/14.
//  Copyright (c) 2014 Intellectsoft. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)
- (BOOL)endsWithWordSeparator
{
    return [self hasSuffix:@" "] || [self hasSuffix:@"\n"];
}
@end
