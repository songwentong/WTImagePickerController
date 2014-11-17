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

@end

@protocol WTImagePickerControllerDelegate <NSObject>

- (void)wtimagePickerController:(WTImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)wtimagePickerControllerDidCancel:(WTImagePickerController *)picker;

@end