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

- (id) init {
	if (self = [super init]) {
		lowH = 0;
		lowS = 0;
		lowV = 0;
		highH = 179;
		highS = 255;
		highV = 255;
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

@end