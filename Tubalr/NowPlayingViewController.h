//
//  NowPlayingViewController.h
//  Tubalr
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
