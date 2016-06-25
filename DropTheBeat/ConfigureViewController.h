//
//  ConfigureViewController.h
//  DropTheBeat
//
//  Created by Peter Chen on 2016-06-25.
//  Copyright © 2016 CoreDevo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ThresholdManager.h"

@interface ConfigureViewController : NSViewController

@property (weak) IBOutlet NSSlider *lowHueSlider;
@property (weak) IBOutlet NSSlider *highHueSlider;
@property (weak) IBOutlet NSSlider *lowSatSlider;
@property (weak) IBOutlet NSSlider *highSatSlider;
@property (weak) IBOutlet NSSlider *lowBrightSlider;
@property (weak) IBOutlet NSSlider *highBrightSlider;
@property (weak) IBOutlet NSTextField *lowHueValue;
@property (weak) IBOutlet NSTextField *highHueValue;
@property (weak) IBOutlet NSTextField *lowSatValue;
@property (weak) IBOutlet NSTextField *highSatValue;
@property (weak) IBOutlet NSTextField *lowBrightValue;
@property (weak) IBOutlet NSTextField *highBrightValue;

@end
