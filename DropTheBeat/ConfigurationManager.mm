//
//  ThresholdManager.m
//  DropTheBeat
//
//  Created by Peter Chen on 2016-06-25.
//  Copyright © 2016 CoreDevo. All rights reserved.
//

#import "ConfigurationManager.h"

@implementation ConfigurationManager

@synthesize lowH;
@synthesize lowS;
@synthesize lowV;
@synthesize highH;
@synthesize highS;
@synthesize highV;
@synthesize filePathsDict;
@synthesize currentDisplayFilter;

- (id) init {
	if (self = [super init]) {
		lowH = 0;
		lowS = 0;
		lowV = 0;
		highH = 179;
		highS = 255;
		highV = 255;

		filePathsDict = [[NSMutableDictionary alloc] init];
	}
	return self;
}

+ (ConfigurationManager *) sharedManager {
	static ConfigurationManager *sharedConfigurationManager = nil;
	@synchronized (self) {
		if (sharedConfigurationManager == nil) {
			sharedConfigurationManager =[[self alloc] init];
		}
	}
	return sharedConfigurationManager;
}

- (void) setDisplayingFilterWithTag:(NSInteger)tag {
	switch(tag){
		case SETTING_TAG_AUDIO1:
			currentDisplayFilter = PixelColorYellow;
			break;
		case SETTING_TAG_AUDIO2:
			currentDisplayFilter = PixelColorPink;
			break;
		case SETTING_TAG_AUDIO3:
			currentDisplayFilter = PixelColorGreen;
			break;
		case SETTING_TAG_AUDIO4:
			currentDisplayFilter = PixelColorPurple;
			break;
		case SETTING_TAG_AUDIO5:
			currentDisplayFilter = PixelColorRed;
			break;
		default:
			break;
	}
}


@end