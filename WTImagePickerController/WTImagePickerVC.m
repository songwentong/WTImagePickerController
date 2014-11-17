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
    
//    视频输入
    AVCaptureDeviceInput * deviceInput;
    
//    图片输出
    AVCaptureStillImageOutput *imageOutPut;
}
@end

@implementation WTImagePickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self configDevice];
    [self configView];
    
    
    
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
    deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [inputSession beginConfiguration];
    [inputSession addInput:deviceInput];
    [inputSession commitConfiguration];
    
    
    CALayer *viewLayer = self.view.layer;
    captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:inputSession];
    captureVideoPreviewLayer.frame = CGRectMake(0, 138/2, 320, 852/2);
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResize;

    [viewLayer addSublayer:captureVideoPreviewLayer];
    
    
    imageOutPut = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG};
    [imageOutPut setOutputSettings:outputSettings];
    [inputSession beginConfiguration];
    [inputSession addOutput:imageOutPut];
    [inputSession commitConfiguration];
}

-(void)configView
{
    //拍照
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 568-100, 320, 100);
    [button setTitle:@"take photo"
            forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self
               action:@selector(capture)
     forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //前后摄像头切换
    UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    switchButton.frame = CGRectMake(320-50, 0, 50, 50);
    switchButton.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    [switchButton addTarget:self
                     action:@selector(switchBetweenDevices)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchButton];
}

//拍照
-(void)capture
{
    NSLog(@"capture");
    
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
         
//         UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
         /*
         image = [self cropimageWithImage:image];
         UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
         */
//         [_delegate wtImagePickerVC:self didPickImage:image];
         
         
         SelectImageViewController *vc = [[SelectImageViewController alloc] init];
         vc.editImage = image;
         [self.navigationController pushViewController:vc animated:YES];
     }];
}



-(UIImage*)cropimageWithImage:(UIImage*)image
{
    CGSize size = [image size];
    int minWidth = MIN(size.width, size.height);
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGRect area = CGRectMake(0, 0, minWidth, minWidth);
    CGImageRef returnImage =(CGImageCreateWithImageInRect(image.CGImage, area));
    UIImage *result = [UIImage imageWithCGImage:returnImage scale:1.0 orientation:UIImageOrientationRight];
    
    
    



    return result;
}


-(AVCaptureDeviceInput*)inputWithPosition:(AVCaptureDevicePosition)position
{
//    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    device.position = position;
    __block AVCaptureDeviceInput *input = nil;
    [[AVCaptureDevice devices] enumerateObjectsUsingBlock:^(AVCaptureDevice *device, NSUInteger idx, BOOL *stop) {
//        NSLog(@"%@",obj);
        if (device.position == position) {
            input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        }
    }];
//
    return input;
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
