//
//  NowPlayingViewController.h
//  Tubalr
//
//  Created by Chad Zeluff on 1/7/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVView.h"

typedef enum {
    justSearch,
    similarSearch,
    genreSearch,
    redditSearch
}SearchType;

@interface NowPlayingViewController : UIViewController

- (id)initWithSearchString:(NSString *)string searchType:(SearchType)searchType;

@property (nonatomic, strong) AVView *playerView;

@end
