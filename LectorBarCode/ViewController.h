//
//  ViewController.h
//  LectorBarCode
//
//  Created by Juan Morillo on 19/10/14.
//  Copyright (c) 2014 Juan Morillo. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

@interface ViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) AVCaptureDevice* device;
@property (strong, nonatomic) AVCaptureDeviceInput* input;
@property (strong, nonatomic) AVCaptureMetadataOutput* output;
@property (strong, nonatomic) AVCaptureSession* session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer* preview;

@property (nonatomic) BOOL codeDetected;

@end
