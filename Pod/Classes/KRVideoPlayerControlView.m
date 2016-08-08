//
//  KRVideoPlayerControlView.m
//  KRKit
//
//  Created by aidenluo on 5/23/15.
//  Copyright (c) 2015 36kr. All rights reserved.
//

#import "KRVideoPlayerControlView.h"

static const CGFloat kVideoControlBarHeight = 28.0;
static const CGFloat kVideoControlAnimationTimeinterval = 0.3;
static const CGFloat kVideoControlTimeLabelWidth = 32.0;
static const CGFloat kVideoControlTimeLabelFontSize = 8.0;
static const CGFloat kVideoControlBarAutoFadeOutTimeinterval = 5.0;
static const CGFloat kVideoControlPlayButtonSize = 64;

@interface KRVideoPlayerControlView ()

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UILabel *totalTimeLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIImageView *timeLengthIcon;
@property (nonatomic, strong) UILabel *timeLengthLabel;

@end

@implementation KRVideoPlayerControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.topBar];
        [self.topBar addSubview:self.closeButton];
        [self addSubview:self.bottomBar];
        [self addSubview:self.playButton];
        [self addSubview:self.pauseButton];
        [self addSubview:self.timeLengthIcon];
        [self addSubview:self.timeLengthLabel];
        self.playButton.hidden = YES;
        self.pauseButton.hidden = YES;
        [self.bottomBar addSubview:self.fullScreenButton];
        [self.bottomBar addSubview:self.progressSlider];
        [self.bottomBar addSubview:self.currentTimeLabel];
        [self.bottomBar addSubview:self.totalTimeLabel];
        [self addSubview:self.indicatorView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.topBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), CGRectGetWidth(self.bounds), kVideoControlBarHeight);
    self.closeButton.frame = CGRectMake(CGRectGetWidth(self.topBar.bounds) - CGRectGetWidth(self.closeButton.bounds), CGRectGetMinX(self.topBar.bounds), CGRectGetWidth(self.closeButton.bounds), CGRectGetHeight(self.closeButton.bounds));
    self.bottomBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetHeight(self.bounds) - kVideoControlBarHeight, CGRectGetWidth(self.bounds), kVideoControlBarHeight);
    self.currentTimeLabel.frame = CGRectMake(0, CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.currentTimeLabel.bounds)/2, CGRectGetWidth(self.currentTimeLabel.bounds), CGRectGetHeight(self.currentTimeLabel.bounds));
    self.fullScreenButton.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - CGRectGetWidth(self.fullScreenButton.bounds), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.fullScreenButton.bounds)/2, CGRectGetWidth(self.fullScreenButton.bounds), CGRectGetHeight(self.fullScreenButton.bounds));
    self.totalTimeLabel.frame = CGRectMake(CGRectGetMinX(self.fullScreenButton.frame) - CGRectGetWidth(self.totalTimeLabel.bounds), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.totalTimeLabel.bounds)/2, CGRectGetWidth(self.totalTimeLabel.bounds), CGRectGetHeight(self.totalTimeLabel.bounds));
    self.progressSlider.frame = CGRectMake(CGRectGetMaxX(self.currentTimeLabel.frame), 0, CGRectGetMinX(self.totalTimeLabel.frame) - CGRectGetMaxX(self.currentTimeLabel.frame), kVideoControlBarHeight);
    self.playButton.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)-11);
    self.timeLengthIcon.frame = CGRectMake(CGRectGetMinX(self.playButton.frame) + 4, CGRectGetMaxY(self.playButton.frame) + 6, 18, 18);
    self.timeLengthLabel.frame = CGRectMake(CGRectGetMaxX(self.timeLengthIcon.frame) + 6, CGRectGetMinY(self.timeLengthIcon.frame) + 6, 30, 10);
    self.pauseButton.center = self.playButton.center;
    self.indicatorView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.isBarShowing = YES;
}

- (void)animateHide
{
    if (!self.isBarShowing) {
        return;
    }
    [UIView animateWithDuration:kVideoControlAnimationTimeinterval animations:^{
        self.topBar.alpha = 0.0;
        self.bottomBar.alpha = 0.0;
        self.playButton.alpha = 0.0;
        self.pauseButton.alpha = 0.0;
        self.timeLengthIcon.alpha = 0.0;
        self.timeLengthLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.isBarShowing = NO;
    }];
}

- (void)animateShow
{
    if (self.isBarShowing) {
        return;
    }
    [UIView animateWithDuration:kVideoControlAnimationTimeinterval animations:^{
        self.topBar.alpha = 1.0;
        self.bottomBar.alpha = 1.0;
        self.playButton.alpha = 1.0;
        self.pauseButton.alpha = 1.0;
        self.timeLengthLabel.alpha = 1.0;
        self.timeLengthIcon.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.isBarShowing = YES;
        [self autoFadeOutControlBar];
    }];
}

- (void)autoFadeOutControlBar
{
    if (!self.isBarShowing) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:kVideoControlBarAutoFadeOutTimeinterval];
}

- (void)cancelAutoFadeOutControlBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
}

- (void)onTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (self.isBarShowing) {
            [self animateHide];
        } else {
            [self animateShow];
        }
    }
}

#pragma mark - Property

- (UIView *)topBar
{
    if (!_topBar) {
        _topBar = [UIView new];
        _topBar.backgroundColor = [UIColor clearColor];
    }
    return _topBar;
}

- (UIView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [UIView new];
        _bottomBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _bottomBar;
}

- (UIButton *)playButton
{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:[self videoImageName:@"jc-video-player-play"]] forState:UIControlStateNormal];
        _playButton.contentMode = UIViewContentModeCenter;
        _playButton.bounds = CGRectMake(0, 0, kVideoControlPlayButtonSize, kVideoControlPlayButtonSize);
    }
    return _playButton;
}

- (UIButton *)pauseButton
{
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton setImage:[UIImage imageNamed:[self videoImageName:@"jc-video-player-pause"]] forState:UIControlStateNormal];
        _pauseButton.contentMode = UIViewContentModeCenter;
        _pauseButton.bounds = CGRectMake(0, 0, kVideoControlPlayButtonSize, kVideoControlPlayButtonSize);
    }
    return _pauseButton;
}

- (UIButton *)fullScreenButton
{
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:[self videoImageName:@"jc-video-player-fullscreen"]] forState:UIControlStateNormal];
        _fullScreenButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _fullScreenButton;
}

- (UISlider *)progressSlider
{
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] init];
        [_progressSlider setThumbImage:[UIImage imageNamed:[self videoImageName:@"jc-video-player-point"]] forState:UIControlStateNormal];
        [_progressSlider setMinimumTrackTintColor:[UIColor colorWithRed:255/255.0 green:64/255.0 blue:64/255.0 alpha:1]];
        [_progressSlider setMaximumTrackTintColor:[UIColor colorWithRed:183/255.0 green:184/255.0 blue:184/255.0 alpha:1]];
        _progressSlider.value = 0.f;
        _progressSlider.continuous = YES;
    }
    return _progressSlider;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:[self videoImageName:@"kr-video-player-close"]] forState:UIControlStateNormal];
        _closeButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _closeButton;
}

- (UILabel *)currentTimeLabel
{
    if (!_currentTimeLabel) {
        _currentTimeLabel = [UILabel new];
        _currentTimeLabel.backgroundColor = [UIColor clearColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:kVideoControlTimeLabelFontSize];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.bounds = CGRectMake(0, 0, kVideoControlTimeLabelWidth, kVideoControlTimeLabelFontSize);
    }
    return _currentTimeLabel;
}

- (UILabel *)totalTimeLabel
{
    if (!_totalTimeLabel) {
        _totalTimeLabel = [UILabel new];
        _totalTimeLabel.backgroundColor = [UIColor clearColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:kVideoControlTimeLabelFontSize];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.bounds = CGRectMake(0, 0, kVideoControlTimeLabelWidth, kVideoControlTimeLabelFontSize);
    }
    return _totalTimeLabel;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_indicatorView stopAnimating];
    }
    return _indicatorView;
}

- (UIImageView *)timeLengthIcon {
    if (!_timeLengthIcon) {
        _timeLengthIcon = [[UIImageView alloc] init];
        _timeLengthIcon.image = [UIImage imageNamed:[self videoImageName:@"jc-video-player-length"]];
        _timeLengthIcon.bounds = CGRectMake(0, 0, 18, 18);
    }
    return _timeLengthIcon;
}

- (UILabel *)timeLengthLabel {
    if (!_timeLengthLabel) {
        _timeLengthLabel = [[UILabel alloc] init];
        _timeLengthLabel.textAlignment = NSTextAlignmentLeft;
        _timeLengthLabel.font = [UIFont systemFontOfSize:10];
        _timeLengthLabel.textColor = [UIColor whiteColor];
    }
    return _timeLengthLabel;
}

#pragma mark - Private Method

- (NSString *)videoImageName:(NSString *)name
{
    if (name) {
        NSString *path = [NSString stringWithFormat:@"KRVideoPlayer.bundle/%@",name];
        return path;
    }
    return nil;
}

@end
