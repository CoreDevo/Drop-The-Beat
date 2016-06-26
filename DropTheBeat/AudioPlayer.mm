//
//  AudioPlayer.m
//  DropTheBeat
//
//  Created by Peter Chen on 2016-06-25.
//  Copyright © 2016 CoreDevo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioPlayer.h"

@implementation AudioPlayer

BOOL _running = NO;
NSMutableDictionary *_fileDatas;
AVAudioPlayer *_bgmPlayer;
NSMutableArray *_currentPlayers;

+ (AudioPlayer *) sharedInstance {
	static AudioPlayer *instance = nil;
	@synchronized (self) {
		if (instance == nil) {
			instance = [[self alloc] init];
		}
	}
	return instance;
}

- (id) init {
	if (self = [super init]) {
		_fileDatas = [[NSMutableDictionary alloc] init];
		_currentPlayers = [[NSMutableArray alloc] init];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBackgroundMusic) name:DBShouldPlayBGMNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playAudioWithTag:) name:DBShouldPlayAudioNotification object:nil];
	}
	return self;
}

- (void) loadAudioFile:(NSDictionary *)filePaths complete:(AudioPlayerLoadFileCompleteCallback)onComplete {
	dispatch_group_t loadGroup = dispatch_group_create();
	for (NSNumber *key in filePaths) {
		__block NSNumber *tag = key;
		__block NSURL *url = [filePaths objectForKey:tag];
		dispatch_group_enter(loadGroup);
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			NSData *fileData = [[NSData alloc] initWithContentsOfURL:url];
			@synchronized (self) {
				[_fileDatas setObject:fileData forKey:tag];
			}
			dispatch_group_leave(loadGroup);
		});
	}

	dispatch_group_notify(loadGroup, dispatch_get_main_queue(), ^{
		onComplete(true);
	});
}

- (void) start {
	_running = YES;
}

- (void) stop {
	_running = NO;
	if (_bgmPlayer != nil) {
		[_bgmPlayer stop];
		_bgmPlayer = nil;
	}
	for (AVAudioPlayer *player in _currentPlayers) {
		[player stop];
	}
	[_currentPlayers removeAllObjects];
}

- (void) playBackgroundMusic {
	if (!_running) { return; }
	NSLog(@"Should play background music");
	NSData *bgmData = [_fileDatas objectForKey:[NSNumber numberWithInteger:SETTING_TAG_BGM]];
	if (bgmData != nil) {
		_bgmPlayer = [[AVAudioPlayer alloc] initWithData:bgmData error:nil];
		[_bgmPlayer setNumberOfLoops:-1];
		[_bgmPlayer prepareToPlay];
		if ([_bgmPlayer play]) {
			NSLog(@"Playing BGM");
		}
	}
}

- (void) playAudioWithTag: (NSNotification*)notification {
	if (!_running) { return; }
	NSNumber *tag = [[notification userInfo] objectForKey:@"tag"];
	NSLog(@"Should play audio with tag %@", tag);
	NSData *audioData = [_fileDatas objectForKey: tag];
	if (audioData != nil) {
		NSError *error;
		AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
		if (error != nil) {
			NSLog(@"Encounter Error: %@", error);
			return;
		}
		[player setDelegate:self];
		[_currentPlayers addObject:player];
		[player prepareToPlay];
		if ([player play]) {
			NSLog(@"Playing audio with tag %@", tag);
		}
	}
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	[_currentPlayers removeObject:player];
}

@end