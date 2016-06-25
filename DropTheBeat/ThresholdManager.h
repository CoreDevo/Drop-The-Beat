//
//  ThresholdManager.h
//  DropTheBeat
//
//  Created by Peter Chen on 2016-06-25.
//  Copyright © 2016 CoreDevo. All rights reserved.
//

#ifndef ThresholdManager_h
#define ThresholdManager_h

#import <Foundation/Foundation.h>


@interface ThresholdManager : NSObject {
	int lowH;
	int lowS;
	int lowV;
	int highH;
	int highS;
	int highV;
}

@property(nonatomic) int lowH;
@property(nonatomic) int lowS;
@property(nonatomic) int lowV;
@property(nonatomic) int highH;
@property(nonatomic) int highS;
@property(nonatomic) int highV;

+(ThresholdManager *) sharedManager;

@end

#endif /* ThresholdManager_h */