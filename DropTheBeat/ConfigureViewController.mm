//
//  ConfigureViewController.m
//  DropTheBeat
//
//  Created by Peter Chen on 2016-06-25.
//  Copyright © 2016 CoreDevo. All rights reserved.
//

#import "ConfigureViewController.h"

@interface ConfigureViewController ()

@end

@implementation ConfigureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	_lowHueSlider.minValue = 0;
	_lowHueSlider.maxValue = 179;
	_highHueSlider.minValue = 0;
	_highHueSlider.maxValue = 179;
	_lowSatSlider.minValue = 0;
	_lowSatSlider.maxValue = 255;
	_highSatSlider.minValue = 0;
	_highSatSlider.maxValue = 255;
	_lowBrightSlider.minValue = 0;
	_lowBrightSlider.maxValue = 255;
	_highBrightSlider.minValue = 0;
	_highBrightSlider.maxValue = 255;

	[_lowHueSlider setDoubleValue:0];
	[_highHueSlider setDoubleValue:179];
	[_lowSatSlider setDoubleValue:0];
	[_highSatSlider setDoubleValue:255];
	[_lowBrightSlider setDoubleValue:0];
	[_highBrightSlider setDoubleValue:255];

	[_lowHueValue setStringValue: [NSString stringWithFormat:@"%d", 0]];
	[_highHueValue setStringValue: [NSString stringWithFormat:@"%d", 179]];
	[_lowSatValue setStringValue: [NSString stringWithFormat:@"%d", 0]];
	[_highSatValue setStringValue: [NSString stringWithFormat:@"%d", 255]];
	[_lowBrightValue setStringValue: [NSString stringWithFormat:@"%d", 0]];
	[_highBrightValue setStringValue: [NSString stringWithFormat:@"%d", 255]];

	[_lowHueSlider setTarget:self];
	[_lowHueSlider setAction:@selector(lowHueChanged:)];
	[_highHueSlider setTarget:self];
	[_highHueSlider setAction:@selector(highHueChanged:)];
	[_lowSatSlider setTarget:self];
	[_lowSatSlider setAction:@selector(lowSatChanged:)];
	[_highSatSlider setTarget:self];
	[_highSatSlider setAction:@selector(highSatChanged:)];
	[_lowBrightSlider setTarget:self];
	[_lowBrightSlider setAction:@selector(lowBrightChanged:)];
	[_highBrightSlider setTarget:self];
	[_highBrightSlider setAction:@selector(highBrightChanged:)];


    // Do view setup here.
}

// Slider Value handle

- (void) lowHueChanged:(NSSlider *)slider {
	int value = (int)slider.doubleValue;
	[ThresholdManager sharedManager].lowH = value;
	[_lowHueValue setStringValue: [NSString stringWithFormat:@"%d", value]];
}

- (void) highHueChanged:(NSSlider *)slider {
	int value = (int)slider.doubleValue;
	[ThresholdManager sharedManager].highH = value;
	[_highHueValue setStringValue: [NSString stringWithFormat:@"%d", value]];
}

- (void) lowSatChanged:(NSSlider *)slider {
	int value = (int)slider.doubleValue;
	[ThresholdManager sharedManager].lowS = value;
	[_lowSatValue setStringValue: [NSString stringWithFormat:@"%d", value]];
}

- (void) highSatChanged:(NSSlider *)slider {
	int value = (int)slider.doubleValue;
	[ThresholdManager sharedManager].highS = value;
	[_highSatValue setStringValue: [NSString stringWithFormat:@"%d", value]];
}

- (void) lowBrightChanged:(NSSlider *)slider {
	int value = (int)slider.doubleValue;
	[ThresholdManager sharedManager].lowV = value;
	[_lowBrightValue setStringValue: [NSString stringWithFormat:@"%d", value]];
}

- (void) highBrightChanged:(NSSlider *)slider {
	int value = (int)slider.doubleValue;
	[ThresholdManager sharedManager].highV = value;
	[_highBrightValue setStringValue: [NSString stringWithFormat:@"%d", value]];
}


@end
