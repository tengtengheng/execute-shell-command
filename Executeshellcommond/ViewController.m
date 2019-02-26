//
//  ViewController.m
//  Executeshellcommond
//
//  Created by mx1614 on 2/26/19.
//  Copyright © 2019 ludy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController()
@property (nonatomic, strong) NSTask *task;
@property (nonatomic, strong) NSURL *currentURL;

@property (weak) IBOutlet NSTextField *shellTextField;
@property (weak) IBOutlet NSButton *currentFolder;
@property (unsafe_unretained) IBOutlet NSTextView *resultTextView;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

//选择初始文件
- (IBAction)currentFolder:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseDirectories = YES;
    NSInteger result = [openPanel runModal];
    if (result == NSModalResponseOK) {
        _currentURL = openPanel.URL;
    }
}


- (IBAction)shellCommand:(id)sender {
    self.resultTextView.string = @"";
    self.task = [[NSTask alloc] init];
    self.task.arguments = @[@"-l", @"-c", _shellTextField.stringValue];
    self.task.launchPath = @"/bin/bash";
    self.task.currentDirectoryURL = _currentURL;
    
    NSPipe *outPip = [[NSPipe alloc] init];
    [self.task setStandardOutput:outPip];
    
    NSPipe *errorPip = [[NSPipe alloc] init];
    [self.task setStandardError:errorPip];
    
    [self.task launch];
    [self.task waitUntilExit];
    
    NSData *outData = [[outPip fileHandleForReading] availableData];
    [outPip.fileHandleForReading readInBackgroundAndNotify];
    
    NSData *errorData = [[errorPip fileHandleForReading] availableData];
    [errorPip.fileHandleForReading readInBackgroundAndNotify];
    
    NSString *outString = [[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
    NSString *errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
    
    if (outString.length > 0) {
        self.resultTextView.string = outString;
        self.resultTextView.textColor = [NSColor greenColor];
    }
    
    if (errorString > 0) {
        //self.resultTextView.string = errorString;
    }
}



- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
