//
//  NowPlayingViewController.h
//  Tubalr
//
//  Created by Chad Zeluff on 1/7/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    justSearch,
    similarSearch
}SearchType;

@interface NowPlayingViewController : UIViewController

- (id)initWithSearchString:(NSString *)string searchType:(SearchType)searchType;

@end
