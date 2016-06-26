//
//  ThresholdManager.h
//  DropTheBeat
//
//  Created by Peter Chen on 2016-06-25.
//  Copyright © 2016 CoreDevo. All rights reserved.
//

#ifndef ConfigurationManager_h
#define ConfigurationManager_h

#import <Foundation/Foundation.h>
#import "CameraViewController.h"

@interface ConfigurationManager : NSObject {
	int lowH;
	int lowS;
	int lowV;
	int highH;
	int highS;
	int highV;

	NSMutableDictionary *filePathsDict;

	NSInteger currentDisplayFilter;
}

@property(nonatomic) int lowH;
@property(nonatomic) int lowS;
@property(nonatomic) int lowV;
@property(nonatomic) int highH;
@property(nonatomic) int highS;
@property(nonatomic) int highV;
@property(atomic) NSMutableDictionary *filePathsDict;
@property(nonatomic) NSInteger currentDisplayFilter;

+(ConfigurationManager *) sharedManager;

-(void) setDisplayingFilterWithTag: (NSInteger)tag;

@end

#endif /* ThresholdManager_h */