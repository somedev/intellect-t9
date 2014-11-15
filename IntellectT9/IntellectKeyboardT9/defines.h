//
//  defines.h
//  IntellectT9
//
//  Created by Eduard Panasiuk on 11/15/14.
//  Copyright (c) 2014 Intellectsoft. All rights reserved.
//

#ifndef IntellectT9_defines_h
#define IntellectT9_defines_h

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define SINGLETON_INTERFACE +(instancetype)sharedInstance;
#define SINGLETON_IMPLEMENTATION(_CLASS_NAME_)                                         \
    +(instancetype)sharedInstance                                                      \
    {                                                                                  \
        __strong static _CLASS_NAME_* sharedInstance = nil;                            \
        static dispatch_once_t onceToken;                                              \
        dispatch_once(&onceToken, ^{ sharedInstance = [[_CLASS_NAME_ alloc] init]; }); \
        return sharedInstance;                                                         \
    }

#define MANAGER [BaseManager sharedInstance]
#define KEYBOARD_MANAGER [KeyboardManager sharedInstance]

#endif
