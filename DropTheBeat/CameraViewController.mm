//
//  ViewController.m
//  DropTheBeat
//
//  Created by Peter Chen on 2016-06-25.
//  Copyright © 2016 CoreDevo. All rights reserved.
//

#import "CameraViewController.h"

@implementation CameraViewController

NSTimer *_refreshTimer;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.capture = new cv::VideoCapture(0);

	_refreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.017 target:self selector: @selector(updateCamera) userInfo:nil repeats: YES];
	
	// Do any additional setup after loading the view.
}

- (void) updateCamera {
	cv::Mat matFrame;
	if(self.capture->read(matFrame)) {
		NSImage *frame = [NSImage imageWithCVMat:matFrame];

		self.originCameraView.image = frame;
		cv::Mat rawProcessedFrame = [self processFrame:matFrame];
		NSImage *processedFrame = [NSImage imageWithCVMat:rawProcessedFrame];
		self.processedCameraView.image = processedFrame;
	}
}

- (cv::Mat) processFrame: (cv::Mat)frame {
	cv::Mat hsvFrame;
	cv::cvtColor(frame, hsvFrame, CV_BGR2HSV);

	int lowH  = [ThresholdManager sharedManager].lowH;
	int highH = [ThresholdManager sharedManager].highH;
	int lowS  = [ThresholdManager sharedManager].lowS;
	int highS = [ThresholdManager sharedManager].highS;
	int lowV  = [ThresholdManager sharedManager].lowV;
	int highV = [ThresholdManager sharedManager].highV;

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

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}

@end
