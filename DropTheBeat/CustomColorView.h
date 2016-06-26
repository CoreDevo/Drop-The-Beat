//
//  CustomColorView.h
//  DropTheBeat
//
//  Created by Peter Chen on 2016-06-25.
//  Copyright © 2016 CoreDevo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CustomColorView : NSView {
	NSColor *backgroundColor;
}

@property(strong) IBInspectable NSColor *backgroundColor;

@end
