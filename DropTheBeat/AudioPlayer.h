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

typedef void (^AudioPlayerLoadFileCompleteCallback)(BOOL success);

@interface AudioPlayer : NSObject {

}

+ (AudioPlayer *) sharedInstance;

- (void) loadAudioFile: (NSDictionary *)filePaths complete:(AudioPlayerLoadFileCompleteCallback)onComplete;

- (void) start;
- (void) stop;
- (void) playBackgroundMusic;

@end

#endif /* AudioPlayer_h */
