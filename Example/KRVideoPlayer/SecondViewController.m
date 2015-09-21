//
//  SecondViewController.m
//  KRVideoPlayer
//
//  Created by aidenluo on 5/23/15.
//  Copyright (c) 2015 36kr. All rights reserved.
//

#import "SecondViewController.h"

NSString *PausePlayerNotification = @"PausePlayerNotification";

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:PausePlayerNotification object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setVideo:[NSURL URLWithString:@"http://krtv.qiniudn.com/150522nextapp"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.bounds.size.width*(9.0/16.0);
}

@end

@implementation Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.clipsToBounds = NO;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.player = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, width, width*(9.0/16.0))];
    [self.contentView addSubview:self.player.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.player selector:@selector(pause) name:PausePlayerNotification object:nil];
}

- (void)setVideo:(NSURL *)url {
    self.player.contentURL = url;
}

@end

