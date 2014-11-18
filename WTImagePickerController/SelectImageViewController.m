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
    
    
    
    self.navigationController.navigationBarHidden = YES;
    
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
//
//    myScrollView.alwaysBounceHorizontal = NO;
//    myScrollView.alwaysBounceVertical = NO;
    [self.view addSubview:myScrollView];

    
    imageViewToZoom = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    imageViewToZoom.image = self.editImage;
    CGSize imageSize = _editImage.size;
    CGFloat heightForImageView = (imageSize.height*320)/imageSize.width;
    imageViewToZoom.frame = CGRectMake(0, -20, 320, heightForImageView);
    myScrollView.contentSize = CGSizeMake(320, heightForImageView-20);
    
    

    myScrollView.contentInset = UIEdgeInsetsMake(0, 0, screenHeight-320, 0);
    
    
    imageViewToZoom.userInteractionEnabled = NO;
    [myScrollView addSubview:imageViewToZoom];
    
    
    
    rectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth)];
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
    
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitButton setTitle:@"确定"
                  forState:UIControlStateNormal];
    commitButton.frame = CGRectMake(0, 0, 320, 100);
    [self.view addSubview:commitButton];
    [commitButton addTarget:self
                     action:@selector(done)
           forControlEvents:UIControlEventTouchUpInside];
}


-(UIImage*)currentImage
{
    UIImage *image = nil;
//    contentOffset
    CGFloat zoomScale = myScrollView.zoomScale;


    CGFloat width = _editImage.size.width/zoomScale;
    CGPoint p = myScrollView.contentOffset;
    CGFloat x = _editImage.size.width*p.x/320;
    
    
    CGFloat yTimes = _editImage.size.height/CGRectGetHeight(imageViewToZoom.frame);
    CGFloat y = (p.y+20)*yTimes;
    CGRect area = CGRectMake(x, y, width, width);
    image = [self cropImageWithImage:_editImage andArea:area];
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    return image;
}

-(UIImage*)cropImageWithImage:(UIImage*)image andArea:(CGRect)area
{
    CGImageRef returnImage = CGImageCreateWithImageInRect(image.CGImage, area);
    UIImage *result = [UIImage imageWithCGImage:returnImage
                                          scale:1.0
                                    orientation:UIImageOrientationRight];
    CFBridgingRelease(returnImage);
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
