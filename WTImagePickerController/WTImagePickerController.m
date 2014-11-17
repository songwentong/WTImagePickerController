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
@interface WTImagePickerController() <WTImagePickerVCDelegate>
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
    SelectImageViewController *a = [[SelectImageViewController alloc] init];
//    vc.delegate = self;
    [self.navigationController pushViewController:a animated:YES];
}

-(void)wtImagePickerVCDidCancal:(WTImagePickerVC*)vc
{
    [self.delegate wtimagePickerControllerDidCancel:self];
}


@end
