//
//  WTImagePickerController.m
//  WTImagePickerController
//
//  Created by SongWentong on 14/11/13.
//  Copyright (c) 2014年 SongWentong. All rights reserved.
//

#import "WTImagePickerController.h"

@implementation WTImagePickerController
- (instancetype)init
{
    self = [super init];
    if (self) {
//        UIImagePickerController
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
@end
