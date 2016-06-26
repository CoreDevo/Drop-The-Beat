//
//  ThresholdManager.h
//  DropTheBeat
//
//  Created by Peter Chen on 2016-06-25.
//  Copyright © 2016 CoreDevo. All rights reserved.
//

#ifndef ConfigurationManager_h
#define ConfigurationManagerr_h

#import <Foundation/Foundation.h>


@interface ConfigurationManager : NSObject {
	int lowH;
	int lowS;
	int lowV;
	int highH;
	int highS;
	int highV;

	NSMutableDictionary *filePathsDict;

	NSString *bgmFilePath;
	NSString *audio1FilePath;
	NSString *audio2FilePath;
	NSString *audio3FilePath;
	NSString *audio4FilePath;
	NSString *audio5FilePath;
}

@property(nonatomic) int lowH;
@property(nonatomic) int lowS;
@property(nonatomic) int lowV;
@property(nonatomic) int highH;
@property(nonatomic) int highS;
@property(nonatomic) int highV;
@property(atomic) NSMutableDictionary *filePathsDict;

+(ConfigurationManager *) sharedManager;

@end

#endif /* ThresholdManager_h */