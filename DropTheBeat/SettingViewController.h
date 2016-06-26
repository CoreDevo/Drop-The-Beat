//
//  SettingViewController.h
//  DropTheBeat
//
//  Created by Peter Chen on 2016-06-25.
//  Copyright © 2016 CoreDevo. All rights reserved.
//

#import "CustomColorView.h"
#import <Cocoa/Cocoa.h>
#import "CameraViewController.h"
#import "ConfigurationManager.h"
#import "AudioPlayer.h"

NSInteger const SETTING_TAG_BGM = 9;
NSInteger const SETTING_TAG_AUDIO1 = 1;
NSInteger const SETTING_TAG_AUDIO2 = 2;
NSInteger const SETTING_TAG_AUDIO3 = 3;
NSInteger const SETTING_TAG_AUDIO4 = 4;
NSInteger const SETTING_TAG_AUDIO5 = 5;

@class CustomColorView;

@interface SettingViewController : NSViewController
@property (weak) IBOutlet NSTextField *bgmFilePathText;
@property (weak) IBOutlet NSTextField *audio1FilePathText;
@property (weak) IBOutlet NSTextField *audio2FilePathText;
@property (weak) IBOutlet NSTextField *audio3FilePathText;
@property (weak) IBOutlet NSTextField *audio4FilePathText;
@property (weak) IBOutlet NSTextField *audio5FilePathText;
@property (weak) IBOutlet NSButton *bgmFileSelectButton;
@property (weak) IBOutlet NSButton *audio1FileSelectButton;
@property (weak) IBOutlet NSButton *audio2FileSelectButton;
@property (weak) IBOutlet NSButton *audio3FileSelectButton;
@property (weak) IBOutlet NSButton *audio4FileSelectButton;
@property (weak) IBOutlet NSButton *audio5FileSelectButton;
@property (weak) IBOutlet NSButton *startButton;
@property (weak) IBOutlet NSButton *loadFilesButton;
@property (weak) IBOutlet CustomColorView *audio1View;
@property (weak) IBOutlet CustomColorView *audio2View;
@property (weak) IBOutlet CustomColorView *audio3View;
@property (weak) IBOutlet CustomColorView *audio4View;
@property (weak) IBOutlet CustomColorView *audio5View;

@end
