//
//  AVView.h
//  Tubalr
//
//  Created by Chad Zeluff on 1/13/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

@interface AVView : UIView

@property (nonatomic, retain) AVPlayer* player;

- (void)setPlayer:(AVPlayer*)player;
- (void)setVideoFillMode:(NSString *)fillMode;

@end
