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

- (NSString *)lastTextComponent
{
    NSString* trimmedString = [[self stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if (trimmedString.length <= 0) {
        return nil;
    }
    
    //find spaces in text
    NSArray* stringsSeparatedBySpaces = [trimmedString componentsSeparatedByString:@" "];
    trimmedString = stringsSeparatedBySpaces.lastObject;
    
    if (trimmedString.length <= 0) {
        return nil;
    }
    
    return trimmedString;
}
@end
