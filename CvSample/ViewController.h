//
//  ViewController.h
//  CvSample
//
//  Created by 巧 清家 on 12/07/22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImage* image;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loadButton;
- (IBAction)pushLoadButton:(id)sender;

@end
