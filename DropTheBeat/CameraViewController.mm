//
//  ViewController.m
//  DropTheBeat
//
//  Created by Peter Chen on 2016-06-25.
//  Copyright © 2016 CoreDevo. All rights reserved.
//

#import "CameraViewController.h"

NSString * const DBDetectStartNotification = @"DBDetectStartNotification";
NSString * const DBDetectStopNotification  = @"DBDetectStopNotification";
NSString * const DBShouldPlayBGMNotification = @"DBShouldPlayBGMNotification";
NSString * const DBShouldPlayAudioNotification = @"DBShouldPlayAudioNotification";

@implementation CameraViewController

NSTimer *_refreshTimer;

int previousBluePixel=0;
int previousYellowPixel=0;
int previousGreenPixel=0;
int previousRedPixel=0;
int previousPinkPixel=0;
int previousPurplePixel=0;

int counter=0; //credit to pis chen
bool musicActivated = false;
bool shouldDetect = false;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.capture = new cv::VideoCapture(0);

	_refreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.017 target:self selector: @selector(updateCamera) userInfo:nil repeats: YES];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startDetecting) name:DBDetectStartNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopDetecting) name:DBDetectStopNotification object:nil];
}

- (void) startDetecting {
	shouldDetect = true;
}

- (void) stopDetecting {
	shouldDetect = false;
	musicActivated = false;
	previousBluePixel = 0;
	previousYellowPixel = 0;
	previousGreenPixel = 0;
	previousRedPixel = 0;
	previousPinkPixel = 0;
	previousPurplePixel = 0;
}

- (void) updateCamera {
	cv::Mat matFrame;
	if(self.capture->read(matFrame)) {
		NSImage *frame = [NSImage imageWithCVMat:matFrame];
		self.originCameraView.image = frame;

		if (!shouldDetect) { return; }

		counter++;
		if (counter>=1){
			counter=0;

			
			if (!musicActivated){
				if ([self detectFrameColor:matFrame detectingColor:PixelColorYellow lowH:88 highH:129 lowS:100 highS:255 lowV:25 highV:145]){
					std::cout<<"Blue is pressed"<<std::endl;
					musicActivated = true;
					[[NSNotificationCenter defaultCenter] postNotificationName:DBShouldPlayBGMNotification object:self];
					//Blue button is pressed, activated
				}

			}else{
				if ([self detectFrameColor:matFrame detectingColor:PixelColorYellow lowH:22 highH:36 lowS:100 highS:255 lowV:100 highV:255]){
					std::cout<<"Yellow is pressed"<<std::endl;
					[[NSNotificationCenter defaultCenter] postNotificationName:DBShouldPlayAudioNotification
																		object:self
																	  userInfo:@{@"tag":[NSNumber numberWithInteger:SETTING_TAG_AUDIO1]}];
					//Yellow button is pressed
				}
				
				if ([self detectFrameColor:matFrame detectingColor:PixelColorPink lowH:165 highH:180 lowS:100 highS:255 lowV:100 highV:255]){
					std::cout<<"Pink is pressed"<<std::endl;
					[[NSNotificationCenter defaultCenter] postNotificationName:DBShouldPlayAudioNotification
																		object:self
																	  userInfo:@{@"tag":[NSNumber numberWithInteger:SETTING_TAG_AUDIO2]}];
					//Pink button is pressed
				}
				
				if ([self detectFrameColor:matFrame detectingColor:PixelColorGreen lowH:73 highH:90 lowS:70 highS:255 lowV:40 highV:125]){
					std::cout<<"Green is pressed"<<std::endl;
					[[NSNotificationCenter defaultCenter] postNotificationName:DBShouldPlayAudioNotification
																		object:self
																	  userInfo:@{@"tag":[NSNumber numberWithInteger:SETTING_TAG_AUDIO3]}];
					//Green button is pressed
				}
				
				if ([self detectFrameColor:matFrame detectingColor:PixelColorPurple lowH:120 highH:160 lowS:70 highS:255 lowV:1 highV:100]){
					[[NSNotificationCenter defaultCenter] postNotificationName:DBShouldPlayAudioNotification
																		object:self
																	  userInfo:@{@"tag":[NSNumber numberWithInteger:SETTING_TAG_AUDIO4]}];
					std::cout<<"Purple is pressed"<<std::endl;
					//Purple button is pressed
				}
				
				if ([self detectFrameColor:matFrame detectingColor:PixelColorRed lowH:0 highH:8 lowS:171 highS:255 lowV:130 highV:255]){
					std::cout<<"red is pressed"<<std::endl;
					[[NSNotificationCenter defaultCenter] postNotificationName:DBShouldPlayAudioNotification
																		object:self
																	  userInfo:@{@"tag":[NSNumber numberWithInteger:SETTING_TAG_AUDIO5]}];
					//Red button is pressed
				}
			}
			
			
		}
		
		

	}
}

- (cv::Mat) processFrame: (const cv::Mat&)frame {
	cv::Mat hsvFrame;
	cv::cvtColor(frame, hsvFrame, CV_BGR2HSV);

	int lowH  = [ConfigurationManager sharedManager].lowH;
	int highH = [ConfigurationManager sharedManager].highH;
	int lowS  = [ConfigurationManager sharedManager].lowS;
	int highS = [ConfigurationManager sharedManager].highS;
	int lowV  = [ConfigurationManager sharedManager].lowV;
	int highV = [ConfigurationManager sharedManager].highV;

	cv::Mat imgThresholded;

	cv::inRange(hsvFrame, cv::Scalar(lowH, lowS, lowV), cv::Scalar(highH, highS, highV), imgThresholded); //Threshold the image

	//morphological opening (remove small objects from the foreground)
	cv::erode(imgThresholded, imgThresholded, getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)) );
	cv::dilate( imgThresholded, imgThresholded, getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)) );

	//morphological closing (fill small holes in the foreground)
	cv::dilate( imgThresholded, imgThresholded, getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)) );
	cv::erode(imgThresholded, imgThresholded, getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)) );
	
	cv::cvtColor(imgThresholded, imgThresholded, CV_GRAY2BGR);
	return imgThresholded;
}


- (BOOL) detectFrameColor: (const cv::Mat&)frame detectingColor:(enum PixelColor)detectingColor lowH:(int)lowH highH:(int)highH lowS:(int)lowS highS:(int)highS lowV:(int)lowV highV:(int)highV{
	cv::Mat hsvFrame;
	cv::cvtColor(frame, hsvFrame, CV_BGR2HSV);
	cv::Mat imgThresholded;
	cv::inRange(hsvFrame, cv::Scalar(lowH, lowS, lowV), cv::Scalar(highH, highS, highV), imgThresholded); //Threshold the image
	//morphological opening (remove small objects from the foreground)
	cv::erode(imgThresholded, imgThresholded, getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)) );
	cv::dilate( imgThresholded, imgThresholded, getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)) );

	//morphological closing (fill small holes in the foreground)
	cv::dilate( imgThresholded, imgThresholded, getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)) );
	cv::erode(imgThresholded, imgThresholded, getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)) );

	if ([ConfigurationManager sharedManager].currentDisplayFilter == detectingColor) {
		cv::Mat bgrFrame;
		cv::cvtColor(imgThresholded, bgrFrame, CV_GRAY2BGR);
		NSImage *processedFrame = [[NSImage alloc] initWithCVMat:bgrFrame];
		self.processedCameraView.image = processedFrame;
	}

	int currentPixel = cv::countNonZero(imgThresholded);
	int previousPixel;
	switch (detectingColor) {
		case PixelColorBlue:
			previousPixel = previousBluePixel;
			previousBluePixel = currentPixel;
			break;
		case PixelColorYellow:
			previousPixel = previousYellowPixel;
			previousYellowPixel = currentPixel;
			break;
		case PixelColorGreen:
			previousPixel = previousGreenPixel;
			previousGreenPixel = currentPixel;
			break;
		case PixelColorRed:
			previousPixel = previousRedPixel;
			previousRedPixel = currentPixel;
			break;
		case PixelColorPurple:
			previousPixel = previousPurplePixel;
			previousPurplePixel = currentPixel;
			break;
		case PixelColorPink:
			previousPixel = previousPinkPixel;
			previousPinkPixel = currentPixel;
			break;
  default:
			break;
	}

	return previousPixel>2*currentPixel;
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}

@end
