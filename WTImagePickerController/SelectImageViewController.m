//
//  SelectImageViewController.m
//  TakePhoto
//
//  Created by SongWentong on 14/11/17.
//  Copyright (c) 2014年 SongWentong. All rights reserved.
//

#import "SelectImageViewController.h"

@interface SelectImageViewController () <UIScrollViewDelegate>
{
    UIScrollView *myScrollView;
    UIImageView *imageViewToZoom;
    UIView *rectView;
}
@end

@implementation SelectImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat screenWidth = 320;
    myScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    myScrollView.delegate = self;
    
    myScrollView.minimumZoomScale = 1.0;
    myScrollView.maximumZoomScale = 4.0;
    myScrollView.backgroundColor = [UIColor redColor];
//    myScrollView.layer.borderColor = [UIColor whiteColor].CGColor;
//    myScrollView.layer.borderWidth = 1.0;
    myScrollView.clipsToBounds = NO;
    myScrollView.contentInset = UIEdgeInsetsMake(37, 0, 468-320, 0);
//    myScrollView.alwaysBounceHorizontal = NO;
//    myScrollView.alwaysBounceVertical = NO;
    [self.view addSubview:myScrollView];
    
    
    imageViewToZoom = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    imageViewToZoom.image = self.editImage;
    CGSize imageSize = _editImage.size;
    CGFloat heightForImageView = (imageSize.height*320)/imageSize.width;
    imageViewToZoom.frame = CGRectMake(0, 0, 320, heightForImageView);
    myScrollView.contentSize = CGSizeMake(320, heightForImageView);
    imageViewToZoom.userInteractionEnabled = NO;
    [myScrollView addSubview:imageViewToZoom];
    
    
    
    rectView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, screenWidth, screenWidth)];
    rectView.userInteractionEnabled = NO;
    rectView.backgroundColor = [UIColor clearColor];
    rectView.layer.borderColor = [UIColor whiteColor].CGColor;
    rectView.layer.borderWidth = 1.0;
    [self.view addSubview:rectView];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(done)];
    
    self.navigationItem.rightBarButtonItem = item;
}


-(UIImage*)currentImage
{
    UIImage *image = nil;
//    contentOffset
    CGFloat zoomScale = myScrollView.zoomScale;
    CGFloat xBeishu = _editImage.size.width/320;
    CGFloat yBeishu = _editImage.size.height/568;
    CGFloat width = 320/zoomScale*xBeishu;
    CGPoint p = myScrollView.contentOffset;
    CGRect area = CGRectMake((p.x)*xBeishu, (p.y+100)*yBeishu, width, width);
    image = [self cropImageWithImage:_editImage andArea:area];
    return image;
}

-(UIImage*)cropImageWithImage:(UIImage*)image andArea:(CGRect)area
{
//    CGRect area = CGRectMake(0, 0, minWidth, minWidth);
    CGImageRef returnImage = CGImageCreateWithImageInRect(image.CGImage, area);
    UIImage *result = [UIImage imageWithCGImage:returnImage scale:1.0 orientation:UIImageOrientationRight];
    if (!result) {
//        UIImage *newImage = [UIImage imageWithCGImage:image.CGImage scale:0.5 orientation:UIImageOrientationUp];
//        return [self cropImageWithImage:newImage andArea:area];
    }
    return result;
}
-(void)done
{
    UIImage *currentImage = [self currentImage];
    [_delegate selectImageDidSelectImage:self
                                   image:currentImage];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageViewToZoom;
}

@end
