//
//  NSDictionary+objectForKeyList.h
//  Tubalr
//
//  Created by Chad Zeluff on 1/11/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (objectForKeyList)
- (id)objectForKeyList:(id)key, ...;
@end
