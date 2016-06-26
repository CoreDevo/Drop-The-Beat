//
//  SettingViewController.h
//  DropTheBeat
//
//  Created by Peter Chen on 2016-06-25.
//  Copyright © 2016 CoreDevo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ConfigurationManager.h"
#import "AudioPlayer.h"

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

@end
