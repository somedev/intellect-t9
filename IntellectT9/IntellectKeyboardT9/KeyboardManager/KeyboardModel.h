//
//  KeyboardModel.h
//  IntellectT9
//
//  Created by Eduard Panasiuk on 11/16/14.
//  Copyright (c) 2014 Intellectsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyboardModel : NSObject

- (NSArray*)keysForKeyNumber:(NSInteger)keyNumber
                keyboardType:(KeyboardType)keyboardType
                    language:(KeyboardLang)language;

- (NSArray*)keyNumbersFromText:(NSString*)text
                  keyboardType:(KeyboardType)keyboardType
                      language:(KeyboardLang)language;

@end
