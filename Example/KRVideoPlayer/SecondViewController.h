//
//  SecondViewController.h
//  KRVideoPlayer
//
//  Created by aidenluo on 5/23/15.
//  Copyright (c) 2015 36kr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRVideoPlayerController.h"

@interface SecondViewController : UITableViewController

@end

@interface Cell : UITableViewCell
@property (nonatomic, strong) KRVideoPlayerController *player;
- (void)setVideo:(NSURL *)url;
@end