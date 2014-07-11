//
//  ImagePageViewController.m
//  ReadAll
//
//  Created by Cheng Yi on 7/11/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "ImagePageViewController.h"
#import "CRApp.h"

@interface ImagePageViewController ()

@end

@implementation ImagePageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) doMySearch:(NSString*) url pageCondition:(PageCondition *)pc{
    NSString* referer = [CRApp getTemplate:[self.book getId]].referer;
    [self.wsClient asyncGetImage:url referer:referer ppParam:pc postProcessor:self];
    [_imageView addSubview:self.av];
    [self.av startAnimating];
}

-(void) doMyPostProcess:(NSData*) result{
    UIImage* img = [UIImage imageWithData:result];
    if (img!=nil){
        self.imageView.image = img;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
