//
//  ThresholdManager.m
//  DropTheBeat
//
//  Created by Peter Chen on 2016-06-25.
//  Copyright © 2016 CoreDevo. All rights reserved.
//

#import "ThresholdManager.h"

@implementation ThresholdManager

@synthesize lowH;
@synthesize lowS;
@synthesize lowV;
@synthesize highH;
@synthesize highS;
@synthesize highV;

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

+ (ThresholdManager *) sharedManager {
	static ThresholdManager *sharedThresholdManager = nil;
	@synchronized (self) {
		if (sharedThresholdManager == nil) {
			sharedThresholdManager =[[self alloc] init];
		}
	}
	return sharedThresholdManager;
}

@end