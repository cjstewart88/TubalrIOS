//
//  NSDictionary+objectForKeyList.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/11/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "NSDictionary+objectForKeyList.h"

@implementation NSDictionary (objectForKeyList)

- (id)objectForKeyList:(id)key, ...
{
    id object = self;
    va_list ap;
    va_start(ap, key);
    for ( ; key; key = va_arg(ap, id))
        object = [object objectForKey:key];
    
    va_end(ap);
    return object;
}

@end
