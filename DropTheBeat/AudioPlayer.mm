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

+ (AudioPlayer *) sharedInstance {
	static AudioPlayer *instance = nil;
	@synchronized (self) {
		if (instance == nil) {
			instance = [[self alloc] init];
		}
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
}

- (void) playBackgroundMusic {
	if (!_running) { return; }
}

@end