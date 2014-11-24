//
//  WTImagePickerVC.m
//  TakePhoto
//
//  Created by SongWentong on 14/11/17.
//  Copyright (c) 2014年 SongWentong. All rights reserved.
//

#import "WTImagePickerVC.h"
#import <AVFoundation/AVFoundation.h>
#import "SelectImageViewController.h"
@interface WTImagePickerVC ()
{
//    输入session
    AVCaptureSession *inputSession;
//    查看layer
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
    UIView *previewBGView;
    
//    视频输入
    AVCaptureDeviceInput * deviceInput;
    
//    图片输出
    AVCaptureStillImageOutput *imageOutPut;
    
//    拍照按钮
    UIButton *captureButton;
    
//    前后摄像头切换按钮
    UIButton *switchCameraButton;
    
    
    
//    取消按钮
    UIButton *cancelButton;
    
    
//    屏幕高度
    CGFloat screenHeight;
    
//    闪光灯效果
    NSMutableArray *flashModeButtons;
}
@end

@implementation WTImagePickerVC
static CGFloat screenWidth;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    flashModeButtons = [[NSMutableArray alloc] init];
    
    [self configDevice];
    [self configView];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    captureButton.userInteractionEnabled = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)configDevice
{
    inputSession = [[AVCaptureSession alloc] init];
    // Add inputs and outputs.
    [inputSession startRunning];
    
    if ([inputSession canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        [inputSession setSessionPreset:AVCaptureSessionPresetPhoto];
    }
    
    
    
    /*
     
     */
    
    //    NSArray *devices = [AVCaptureDevice devices];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    AVCaptureFlashMode *flashMode = device.flashMode;
    deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [inputSession beginConfiguration];
    [inputSession addInput:deviceInput];
    [inputSession commitConfiguration];
    
    
    previewBGView = [[UIView alloc] initWithFrame:self.view.bounds];
    captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:inputSession];
    captureVideoPreviewLayer.frame = CGRectMake(0, 130/2, screenWidth, screenHeight-138/2-70);
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResize;

    [previewBGView.layer addSublayer:captureVideoPreviewLayer];
    [self.view addSubview:previewBGView];
    
    imageOutPut = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG};
    [imageOutPut setOutputSettings:outputSettings];
    [inputSession beginConfiguration];
    [inputSession addOutput:imageOutPut];
    [inputSession commitConfiguration];
}

-(void)configView
{
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(0, screenHeight-72, 100, 72);
    [self.view addSubview:cancelButton];
    [cancelButton addTarget:self
                     action:@selector(cancelPressed)
           forControlEvents:UIControlEventTouchUpInside];
    
    //拍照
    captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    captureButton.frame = CGRectMake((screenWidth-62)/2, screenHeight-72, 62, 62);
    [captureButton setImage:[UIImage imageNamed:@"capture"]
                   forState:UIControlStateNormal];
    
    /*
    [captureButton setTitle:@"take photo"
                   forState:UIControlStateNormal];
     */
    [self.view addSubview:captureButton];
    [captureButton addTarget:self
               action:@selector(capture)
     forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //前后摄像头切换
    switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    switchCameraButton.frame = CGRectMake(screenWidth-72, 0, 50, 72);
//    switchCameraButton.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    [switchCameraButton setImage:[UIImage imageNamed:@"SwitchCamera"] forState:UIControlStateNormal];
    [switchCameraButton addTarget:self
                     action:@selector(switchBetweenDevices)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchCameraButton];

    
    
    NSArray *flashModeTitles = @[@"自动",@"打开",@"关闭"];
    for (int i=0; i<3; i++) {
        UIButton *flashModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [flashModeButton setTitle:flashModeTitles[i]
                         forState:UIControlStateNormal];
        CGFloat buttonWidth = 80;
        flashModeButton.frame = CGRectMake(i*buttonWidth, 0, buttonWidth, 72);
        [flashModeButton addTarget:self
                            action:@selector(flashModeButtonPressed:)
                  forControlEvents:UIControlEventTouchUpInside];
        [flashModeButtons addObject:flashModeButton];
        [self.view addSubview:flashModeButton];
        
        
        if (i==0) {
            AVCaptureSession *session = inputSession;
            AVCaptureDeviceInput *input = [session.inputs lastObject];
            AVCaptureDevice *device = input.device;

            [flashModeButton setTitleColor:[self colorWithFlash:device.flashActive] forState:UIControlStateNormal];
        }
        
        if (i==1) {
            [flashModeButton setTitleColor:[self colorWithFlash:YES]
                                  forState:UIControlStateNormal];
            flashModeButton.hidden = YES;
        }
        
        if (i==2) {
            [flashModeButton setTitleColor:[self colorWithFlash:NO]
                                  forState:UIControlStateNormal];
            flashModeButton.hidden = YES;
        }
    }
    
}



-(UIColor*)colorWithFlash:(BOOL)flag
{
    UIColor *color = nil;
    if (flag) {
//        254,203,247
//        开闪光灯
        color = [UIColor colorWithRed:254/255.0 green:195/255.0 blue:10/255.0 alpha:1.0];
    }else
    {
//        未开闪光灯
        color = [UIColor whiteColor];
    }
    return color;
}

-(void)flashModeButtonPressed:(UIButton*)sender
{
    AVCaptureSession *session = inputSession;
    AVCaptureDeviceInput *input = [session.inputs lastObject];
    AVCaptureDevice *device = input.device;
//    AVCaptureFlashMode flashMode = device.flashMode;
    
    NSInteger index = [flashModeButtons indexOfObject:sender];
    
    
    UIButton *button0 = flashModeButtons[0];
    UIButton *button1 = flashModeButtons[1];
    UIButton *button2 = flashModeButtons[2];
    NSArray *flashModeTitles = @[@"自动",@"打开",@"关闭"];
    [button0 setTitle:flashModeTitles[index] forState:UIControlStateNormal];
    switch (index) {
        case 0:
        {
            if (!button1.hidden) {
                BOOL flag = [device lockForConfiguration:nil];
                if (flag) {
                [device setFlashMode:AVCaptureFlashModeAuto];
                }
                
            }
            button1.hidden = !button1.hidden;
            button2.hidden = !button2.hidden;

        }
            break;
        case 1:
        {
            button1.hidden = YES;
            button2.hidden = YES;
            BOOL flag = [device lockForConfiguration:nil];
            if (flag) {
            [device setFlashMode:AVCaptureFlashModeOn];
            }
            

        }
            break;
        case 2:
        {
            button1.hidden = YES;
            button2.hidden = YES;
            BOOL flag = [device lockForConfiguration:nil];
            if (flag) {
            [device setFlashMode:AVCaptureFlashModeOff];
            }
            
        }
            break;
    }
    
    if (device.flashActive) {
        [button0 setTitleColor:[self colorWithFlash:YES]
                      forState:UIControlStateNormal];
    }else
    {
        [button0 setTitleColor:[self colorWithFlash:NO]
                      forState:UIControlStateNormal];
    }
}

-(void)cancelPressed
{
    [_delegate wtImagePickerVCDidCancal:self];
}


//拍照
-(void)capture
{

    captureButton.userInteractionEnabled = NO;
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in imageOutPut.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    [imageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection
                                             completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {

         //图像数据类型转换
         NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage * image = [[UIImage alloc] initWithData:imageData];
         

         [_delegate wtImagePickerVC:self didPickImage:image];
         
         
         
     }];
}


-(AVCaptureDeviceInput*)inputWithPosition:(AVCaptureDevicePosition)position
{

    __block AVCaptureDeviceInput *input = nil;
    [[AVCaptureDevice devices] enumerateObjectsUsingBlock:^(AVCaptureDevice *device, NSUInteger idx, BOOL *stop) {

        if (device.position == position) {
            input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        }
    }];
//
    return input;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)switchBetweenDevices
{
    
    AVCaptureSession *session = inputSession;
    AVCaptureDeviceInput *input = [session.inputs lastObject];
    AVCaptureDevice *device = input.device;
    AVCaptureDevicePosition position = device.position;
    AVCaptureDevicePosition newPosition;
    switch (position) {
        case AVCaptureDevicePositionBack:
        {
            //            back
            newPosition = AVCaptureDevicePositionFront;
        }
            break;
        case AVCaptureDevicePositionFront:
        {
            //            front
            newPosition = AVCaptureDevicePositionBack;
        }
            break;
            
        default:
            break;
    }

    
    
    
    
    [session beginConfiguration];
    
    [session removeInput:input];
    
    AVCaptureDeviceInput *newInput = [self inputWithPosition:newPosition];
    if (newInput) {
        [session addInput:newInput];
    }
    
    [session commitConfiguration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
