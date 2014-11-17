//
//  WTImagePickerVC.h
//  TakePhoto
//
//  Created by SongWentong on 14/11/17.
//  Copyright (c) 2014年 SongWentong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTImagePickerVC;
@protocol WTImagePickerVCDelegate <NSObject>

-(void)wtImagePickerVC:(WTImagePickerVC*)vc didPickImage:(UIImage*)image;
-(void)wtImagePickerVCDidCancal:(WTImagePickerVC*)vc;

@end

@interface WTImagePickerVC : UIViewController
@property (nonatomic,weak) id <WTImagePickerVCDelegate> delegate;
@end
