//
//  ViewController.m
//  WTImagePickerController
//
//  Created by SongWentong on 14/11/13.
//  Copyright (c) 2014年 SongWentong. All rights reserved.
//

#import "ViewController.h"
#import "WTImagePickerController.h"
@interface ViewController () <WTImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *myImageView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button.frame = CGRectMake(0, 0, 200, 100);
    button.frame = self.view.bounds;
    [button setTitle:@"show image Picker"
            forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor]
                 forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(showImagePicker)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 320, 320)];
    [self.view addSubview:myImageView];
    myImageView.clipsToBounds = YES;
    myImageView.contentMode = UIViewContentModeScaleAspectFill;

}

-(void)showImagePicker
{
    WTImagePickerController *vc = [[WTImagePickerController alloc] init];
    vc.delegate = self;
    [self presentViewController:vc
                       animated:YES
                     completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WTImagePickerControllerDelegate
- (void)wtimagePickerController:(WTImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[@"image"];
    myImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)wtimagePickerControllerDidCancel:(WTImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
