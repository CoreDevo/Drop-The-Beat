//
//  SettingViewController.m
//  DropTheBeat
//
//  Created by Peter Chen on 2016-06-25.
//  Copyright © 2016 CoreDevo. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

NSArray *_textFields;
NSArray *_selectButtons;
BOOL _videoDetecting = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
	_bgmFilePathText.tag	= SETTING_TAG_BGM;
	_audio1FilePathText.tag = SETTING_TAG_AUDIO1;
	_audio2FilePathText.tag = SETTING_TAG_AUDIO2;
	_audio3FilePathText.tag = SETTING_TAG_AUDIO3;
	_audio4FilePathText.tag = SETTING_TAG_AUDIO4;
	_audio5FilePathText.tag = SETTING_TAG_AUDIO5;

	_bgmFileSelectButton.tag	= SETTING_TAG_BGM;
	_audio1FileSelectButton.tag = SETTING_TAG_AUDIO1;
	_audio2FileSelectButton.tag = SETTING_TAG_AUDIO2;
	_audio3FileSelectButton.tag = SETTING_TAG_AUDIO3;
	_audio4FileSelectButton.tag = SETTING_TAG_AUDIO4;
	_audio5FileSelectButton.tag = SETTING_TAG_AUDIO5;

	_audio1View.audioTag = SETTING_TAG_AUDIO1;
	_audio2View.audioTag = SETTING_TAG_AUDIO2;
	_audio3View.audioTag = SETTING_TAG_AUDIO3;
	_audio4View.audioTag = SETTING_TAG_AUDIO4;
	_audio5View.audioTag = SETTING_TAG_AUDIO5;

	_textFields = @[_bgmFilePathText,
					_audio1FilePathText,
					_audio2FilePathText,
					_audio3FilePathText,
					_audio4FilePathText,
					_audio5FilePathText];
	_selectButtons = @[_bgmFileSelectButton,
					   _audio1FileSelectButton,
					   _audio2FileSelectButton,
					   _audio3FileSelectButton,
					   _audio4FileSelectButton,
					   _audio5FileSelectButton];

	for (NSButton *button in _selectButtons) {
		[button setTarget:self];
		[button setAction:@selector(selectButtonPressed:)];
	}

	[_startButton setEnabled:NO];
	[_startButton setTarget:self];
	[_startButton setAction:@selector(startButtonPressed:)];
	[_loadFilesButton setTarget:self];
	[_loadFilesButton setAction:@selector(loadFilesButton:)];

	[self loadUserDefaults];
}

- (void)loadUserDefaults {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *tags = @[[NSNumber numberWithInteger:SETTING_TAG_BGM],
					  [NSNumber numberWithInteger:SETTING_TAG_AUDIO1],
					  [NSNumber numberWithInteger:SETTING_TAG_AUDIO2],
					  [NSNumber numberWithInteger:SETTING_TAG_AUDIO3],
					  [NSNumber numberWithInteger:SETTING_TAG_AUDIO4],
					  [NSNumber numberWithInteger:SETTING_TAG_AUDIO5]];
	for (NSNumber *tag in tags) {
		NSString *key = [NSString stringWithFormat:@"FILE_PATH_%@", tag];
		NSURL *url = [defaults URLForKey:key];
		if (url != nil) {
			NSTextField *textField = [_textFields objectAtIndex:[_textFields indexOfObjectPassingTest:^BOOL(NSTextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
				return obj.tag == [tag integerValue];
			}]];
			[textField setStringValue:[url absoluteString]];
			[[ConfigurationManager sharedManager].filePathsDict setObject:url forKey:tag];
		}
	}
}

- (void)selectButtonPressed: (NSButton *)button {
	NSOpenPanel *panel =[NSOpenPanel openPanel];
	[panel setCanChooseFiles:YES];
	[panel setCanChooseDirectories:NO];
	[panel setAllowsMultipleSelection:NO];
	[panel setCanChooseDirectories:NO];

	NSArray *allowedFileTypes = @[@"mp3", @"aac"];
	[panel setAllowedFileTypes:allowedFileTypes];

	NSInteger clicked = [panel runModal];
	if (clicked == NSFileHandlingPanelOKButton) {
		NSURL *url = [[panel URLs] firstObject];
		if (url != nil) {
			NSLog(@"Selected Audio: %@", url);
			NSTextField *textField = [_textFields objectAtIndex:[_textFields indexOfObjectPassingTest:^BOOL(NSTextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
				return obj.tag == button.tag;
			}]];
			[textField setStringValue:[url absoluteString]];
			[[ConfigurationManager sharedManager].filePathsDict setObject:url forKey: [NSNumber numberWithInteger:button.tag]];
			[[NSUserDefaults standardUserDefaults] setURL:url forKey:[NSString stringWithFormat:@"FILE_PATH_%@", [NSNumber numberWithInteger:button.tag]]];
		}
	}
}

- (void)startButtonPressed: (NSButton *)button {
	if (!_videoDetecting) {
		_videoDetecting = YES;
		[_startButton setTitle:@"Stop"];
		[[AudioPlayer sharedInstance] start];
		[[NSNotificationCenter defaultCenter] postNotificationName:DBDetectStartNotification object:self];
	} else {
		_videoDetecting = NO;
		[_startButton setTitle:@"Start"];
		[[AudioPlayer sharedInstance] stop];
		[[NSNotificationCenter defaultCenter] postNotificationName:DBDetectStopNotification object:self];
	}
}

- (void)loadFilesButton: (NSButton *)button {
	[[AudioPlayer sharedInstance] loadAudioFile:[ConfigurationManager sharedManager].filePathsDict complete:^(BOOL success) {
		[_startButton setEnabled:YES];
	}];
}

@end
