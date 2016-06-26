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

+ (AudioPlayer *) sharedInstance {
	static AudioPlayer *instance = nil;
	@synchronized (self) {
		if (instance == nil) {
			instance = [[self alloc] init];
		}
	}
	return self;
}

@end