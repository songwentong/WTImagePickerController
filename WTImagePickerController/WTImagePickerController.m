//
//  WTImagePickerController.m
//  WTImagePickerController
//
//  Created by SongWentong on 14/11/13.
//  Copyright (c) 2014年 SongWentong. All rights reserved.
//

#import "WTImagePickerController.h"
#import <AVFoundation/AVFoundation.h>
#import "WTImagePickerVC.h"
#import "SelectImageViewController.h"
#import "UIImage+Rotate.h"
@interface WTImagePickerController() <WTImagePickerVCDelegate,SelectImageViewControllerDelegate>
@end;
@implementation WTImagePickerController
- (instancetype)init
{
    self = [super init];
    if (self) {
        WTImagePickerVC *vc = [[WTImagePickerVC alloc] init];
        vc.delegate = self;
        self.viewControllers = @[vc];
    }
    return self;
}


- (void)takePicture NS_AVAILABLE_IOS(3_1)
{
    
}




- (BOOL)startVideoCapture NS_AVAILABLE_IOS(4_0)
{
    return YES;
}
- (void)stopVideoCapture  NS_AVAILABLE_IOS(4_0)
{
}

#pragma mark - WTImagePickerVCDelegate
-(void)wtImagePickerVC:(WTImagePickerVC*)vc didPickImage:(UIImage*)image
{

    
    
    SelectImageViewController *vc2 = [[SelectImageViewController alloc] init];
//    UIImage *image2 = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationRight];
    
    vc2.editImage = [UIImage rotateImage:image];
//    UIImageWriteToSavedPhotosAlbum(vc2.editImage, nil, nil, nil);
    vc2.delegate = self;
    [self pushViewController:vc2 animated:YES];
}

-(void)cropImage
{
    
}

-(void)wtImagePickerVCDidCancal:(WTImagePickerVC*)vc
{
    [self.delegate wtimagePickerControllerDidCancel:self];
}

#pragma mark - SelectImageViewControllerDelegate
-(void)selectImageDidSelectImage:(SelectImageViewController*)vc
                           image:(UIImage*)image
{
    if (image) {
        NSDictionary *dict = @{@"image": image};
        [self.delegate wtimagePickerController:self
                 didFinishPickingMediaWithInfo:dict];
    }
    
}
-(void)selectImageDidSelectImageDidCancel:(SelectImageViewController*)vc
{
    [self.delegate wtimagePickerControllerDidCancel:self];
}


@end
