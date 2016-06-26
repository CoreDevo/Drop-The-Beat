//
//  ViewController.h
//  DropTheBeat
//
//  Created by Peter Chen on 2016-06-25.
//  Copyright © 2016 CoreDevo. All rights reserved.
//

#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#import <opencv2/highgui.hpp>
#import <opencv2/imgproc.hpp>
#endif

#import <Cocoa/Cocoa.h>
#import "NSImage+OpenCV.h"
#import "ConfigurationManager.h"
#import "SettingViewController.h"

typedef NS_ENUM(NSInteger, PixelColor) {
	PixelColorBlue,
	PixelColorYellow,
	PixelColorGreen,
	PixelColorRed,
	PixelColorPink,
	PixelColorPurple,
	PixelColorNone
};

extern NSString * const DBDetectStartNotification;
extern NSString * const DBDetectStopNotification;
extern NSString * const DBShouldPlayBGMNotification;
extern NSString * const DBShouldPlayAudioNotification;

@interface CameraViewController : NSViewController

@property (weak) IBOutlet NSImageView *originCameraView;
@property (weak) IBOutlet NSImageView *processedCameraView;

@property(atomic) cv::VideoCapture *capture;

@end

