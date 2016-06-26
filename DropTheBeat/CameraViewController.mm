//
//  ViewController.m
//  DropTheBeat
//
//  Created by Peter Chen on 2016-06-25.
//  Copyright © 2016 CoreDevo. All rights reserved.
//

#import "CameraViewController.h"

NS_ENUM(NSInteger, PixelColor) {
	PixelColorBlue,
	PixelColorYellow,
	PixelColorGreen,
	PixelColorRed,
	PixelColorPink,
	PixelColorPurple
};

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

		counter++;
		if (counter>=1){
			counter=0;

			
			if (!musicActivated){
				if ([self detectFrameColor:matFrame detectingColor:PixelColorYellow lowH:88 highH:129 lowS:100 highS:255 lowV:25 highV:145]){
					std::cout<<"Blue is pressed"<<std::endl;
					musicActivated = true;
					//Blue button is pressed, activated
				}

			}else{
				if ([self detectFrameColor:matFrame detectingColor:PixelColorYellow lowH:22 highH:36 lowS:100 highS:255 lowV:100 highV:255]){
					std::cout<<"Yellow is pressed"<<std::endl;
					//Yellow button is pressed
				}
				
				if ([self detectFrameColor:matFrame detectingColor:PixelColorPink lowH:165 highH:180 lowS:100 highS:255 lowV:100 highV:255]){
					std::cout<<"Pink is pressed"<<std::endl;
					//Pink button is pressed
				}
				
				if ([self detectFrameColor:matFrame detectingColor:PixelColorGreen lowH:73 highH:85 lowS:100 highS:255 lowV:50 highV:125]){
					std::cout<<"Green is pressed"<<std::endl;
					//Green button is pressed
				}
				
				if ([self detectFrameColor:matFrame detectingColor:PixelColorPurple lowH:120 highH:160 lowS:100 highS:255 lowV:1 highV:75]){
					std::cout<<"Purple is pressed"<<std::endl;
					//Purple button is pressed
				}
				
				if ([self detectFrameColor:matFrame detectingColor:PixelColorRed lowH:0 highH:8 lowS:171 highS:255 lowV:130 highV:255]){
					std::cout<<"red is pressed"<<std::endl;
					//Red button is pressed
				}
			}
			
			
		}
		
		

	}
}

- (cv::Mat) processFrame: (cv::Mat)frame {
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


- (BOOL) detectFrameColor: (cv::Mat)frame detectingColor:(enum PixelColor)detectingColor lowH:(int)lowH highH:(int)highH lowS:(int)lowS highS:(int)highS lowV:(int)lowV highV:(int)highV{
	cv::Mat hsvFrame;
	cv::cvtColor(frame, hsvFrame, CV_RGB2HSV);
	cv::Mat imgThresholded;
	cv::inRange(hsvFrame, cv::Scalar(lowH, lowS, lowV), cv::Scalar(highH, highS, highV), imgThresholded); //Threshold the image
	//morphological opening (remove small objects from the foreground)
	cv::erode(imgThresholded, imgThresholded, getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)) );
	cv::dilate( imgThresholded, imgThresholded, getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)) );
	
	//morphological closing (fill small holes in the foreground)
	cv::dilate( imgThresholded, imgThresholded, getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)) );
	cv::erode(imgThresholded, imgThresholded, getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)) );
	
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
