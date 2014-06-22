//
//  PageViewController.m
//  MyReadAll
//
//  Created by Cheng Yi on 6/21/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "PageViewController.h"
#import "CRBookWSClient.h"
#import "PageCondition.h"

@interface PageViewController ()

@property(nonatomic) CRBookWSClient* wsClient;

@end

@implementation PageViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    _wsClient = [[CRBookWSClient alloc]init];
}

-(void)viewDidAppear:(BOOL)animated {
    NSString* url = [_book getPageUrl:_curPage];
    PageCondition* pc = [[PageCondition alloc]init];
    pc.book = _book;
    pc.pageNum = _curPage;
    [_wsClient asyncGetImage:url ppParam:pc postProcessor:self];
}

-(void) postProcess:(NSString*) url result:(NSData*) result ppParam:(id) ppParam{
    UIImage* img = [UIImage imageWithData:result];
    PageCondition* pc=(PageCondition*)ppParam;
    if ((pc.book==_book) && (pc.pageNum == _curPage)
        && (img!=nil)){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = img;
            });
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation




@end
