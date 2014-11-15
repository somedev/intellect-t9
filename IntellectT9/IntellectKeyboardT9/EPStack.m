//
// Created by Eduard Panasiuk on 30.09.13.
// Copyright (c) 2013 Eduard Panasiuk
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "EPStack.h"

const NSInteger cEPStackDefaultCapacity = 20;

@interface EPStack ()
@property (nonatomic, strong) NSMutableArray* data;
@end

@implementation EPStack
@synthesize maxCapacity = _maxCapacity;

- (NSUInteger)count
{
    return self.data.count;
}

- (id)init
{
    return [self initWithMaxCapacity:cEPStackDefaultCapacity];
}

- (id)initWithMaxCapacity:(NSUInteger)capacity
{
    self = [super init];
    if (self) {
        _maxCapacity = capacity;
        self.data = [NSMutableArray arrayWithCapacity:_maxCapacity];
    }
    return self;
}

- (id)pop
{
    if (self.data.count > 0) {
        id object = self.data.lastObject;
        [self.data removeLastObject];
        return object;
    }
    return nil;
}

- (void)clear
{
    [self.data removeAllObjects];
}

- (void)push:(id)object
{
    [self.data addObject:object];
    if (self.data.count > self.maxCapacity) {
        [self.data removeObjectAtIndex:0];
    }
}

- (void)pushArray:(NSArray*)array
{
    for (id obj in array) {
        [self push:obj];
    }
}

- (id)peak
{
    if (self.data.count > 0) {
        id object = self.data.lastObject;
        return object;
    }
    return nil;
}

- (NSArray*)allItems
{
    return [self.data copy];
}

@end