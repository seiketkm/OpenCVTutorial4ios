//
//  ViewController.m
//  CvSample
//
//  Created by 巧 清家 on 12/07/22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize imageView;
@synthesize loadButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setLoadButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)pushLoadButton:(id)sender {
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        return;
    }
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:picker animated:YES];
}

- (void) imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *temp = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // convert
    cv::Mat m;
    UIImageToMat(temp, m);
    cv::cvtColor(m, m, CV_BGR2GRAY);
    imageView.image = temp;
    //imageView.image = MatToUIImage(m);
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

// for OpenCV function
static UIImage* MatToUIImage(const cv::Mat& m) {
    CV_Assert(m.depth() == CV_8U);
    NSData *data = [NSData dataWithBytes:m.data length:m.elemSize()*m.total()];
    CGColorSpaceRef colorSpace = m.channels() == 1 ?
    CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB();
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(m.cols, m.cols, m.elemSize1()*8, m.elemSize()*8,
                                        m.step[0], colorSpace, kCGImageAlphaNoneSkipLast|kCGBitmapByteOrderDefault,
                                        provider, NULL, false, kCGRenderingIntentDefault);
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef); CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace); return finalImage;
}

static void UIImageToMat(const UIImage* image, cv::Mat& m) {
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width, rows = image.size.height;
    m.create(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    CGContextRef contextRef = CGBitmapContextCreate(m.data, m.cols, m.rows, 8,
                                                    m.step[0], colorSpace, kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef); CGColorSpaceRelease(colorSpace);
}
@end
