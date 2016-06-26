//
//  AudioPlayer.h
//  DropTheBeat
//
//  Created by Peter Chen on 2016-06-25.
//  Copyright © 2016 CoreDevo. All rights reserved.
//

#ifndef AudioPlayer_h
#define AudioPlayer_h

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CameraViewController.h"
#import "SettingViewController.h"

typedef void (^AudioPlayerLoadFileCompleteCallback)(BOOL success);

@interface AudioPlayer : NSObject <AVAudioPlayerDelegate> {

}

+ (AudioPlayer *) sharedInstance;

- (void) loadAudioFile: (NSDictionary *)filePaths complete:(AudioPlayerLoadFileCompleteCallback)onComplete;

- (void) start;
- (void) stop;
- (void) playBackgroundMusic;
- (void) playAudioWithTag: (NSNumber*)tag;

@end

#endif /* AudioPlayer_h */
