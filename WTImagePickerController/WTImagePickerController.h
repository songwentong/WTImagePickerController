//
//  WTImagePickerController.h
//  WTImagePickerController
//
//  Created by SongWentong on 14/11/13.
//  Copyright (c) 2014年 SongWentong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WTImagePickerControllerDelegate;








@interface WTImagePickerController : UINavigationController
@property (nonatomic,weak) id <WTImagePickerControllerDelegate,UINavigationControllerDelegate> delegate;
@property(nonatomic)           BOOL                                  allowsEditing;


//拍照
- (void)takePicture NS_AVAILABLE_IOS(3_1);

//开始拍摄
- (BOOL)startVideoCapture NS_AVAILABLE_IOS(4_0);
//停止拍摄
- (void)stopVideoCapture  NS_AVAILABLE_IOS(4_0);


@property(nonatomic) UIImagePickerControllerCameraCaptureMode cameraCaptureMode NS_AVAILABLE_IOS(4_0); // default is UIImagePickerControllerCameraCaptureModePhoto
@property(nonatomic) UIImagePickerControllerCameraDevice      cameraDevice      NS_AVAILABLE_IOS(4_0); // default is UIImagePickerControllerCameraDeviceRear
@property(nonatomic) UIImagePickerControllerCameraFlashMode   cameraFlashMode   NS_AVAILABLE_IOS(4_0); // default is UIImagePickerControllerCameraFlashModeAuto.
// cameraFlashMode controls the still-image flash when cameraCaptureMode is Photo. cameraFlashMode controls the video torch when cameraCaptureMode is Video.
@end

@protocol WTImagePickerControllerDelegate <NSObject>

- (void)imagePickerController:(WTImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(WTImagePickerController *)picker;

@end