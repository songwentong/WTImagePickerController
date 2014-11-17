//
//  SelectImageViewController.h
//  TakePhoto
//
//  Created by SongWentong on 14/11/17.
//  Copyright (c) 2014年 SongWentong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectImageViewController;
@protocol SelectImageViewControllerDelegate <NSObject>

-(void)selectImageDidSelectImage:(SelectImageViewController*)vc image:(UIImage*)image;
-(void)selectImageDidSelectImageDidCancel:(SelectImageViewController*)vc;

@end
@interface SelectImageViewController : UIViewController
@property (nonatomic , weak) id <SelectImageViewControllerDelegate> delegate;
@property (nonatomic,strong) UIImage *editImage;
@end
