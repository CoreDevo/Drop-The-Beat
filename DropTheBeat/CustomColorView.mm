//
//  CustomColorView.m
//  DropTheBeat
//
//  Created by Peter Chen on 2016-06-25.
//  Copyright © 2016 CoreDevo. All rights reserved.
//

#import "CustomColorView.h"

@implementation CustomColorView
@synthesize backgroundColor;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

	[backgroundColor set];
	NSRectFill([self bounds]);
}

@end
