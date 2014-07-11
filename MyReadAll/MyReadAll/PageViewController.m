//
//  PageViewController.m
//  MyReadAll
//
//  Created by Cheng Yi on 6/21/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "PageViewController.h"
#import "CRBookWSClient.h"
#import "CRApp.h"

@interface PageViewController ()


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
    //add loading indicator
    _av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _av.frame=CGRectMake(145, 160, 25, 25);
    _av.tag  = 1;
}

-(void) doSearch{
    NSString* url = [_book getPageUrl:_curPage];
    PageCondition* pc = [[PageCondition alloc]init];
    pc.book = _book;
    pc.pageNum = _curPage;
    _totalPageLbl.text = [NSString stringWithFormat:@"%d", _book.totalpage];
    _curPageTxt.text = [NSString stringWithFormat:@"%d", _curPage];
    [self doMySearch:url pageCondition:pc];

}

-(void)viewDidAppear:(BOOL)animated {
    [self doSearch];
}

-(void) postProcess:(NSString*) url result:(NSData*) result ppParam:(id) ppParam err:(NSError *)err{
    PageCondition* pc=(PageCondition*)ppParam;
    if ((pc.book==_book) && (pc.pageNum == _curPage)){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self doMyPostProcess:result];
                //remove the loading indicator
                [_av removeFromSuperview];
            });
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextPage:(id)sender {
    if (_curPage<_book.totalpage){
        _curPage++;
        [self doSearch];
    }
}

- (IBAction)prevPage:(id)sender {
    if (_curPage>1){
        _curPage--;
        [self doSearch];
    }
}
- (IBAction)setPage:(id)sender {
    int page = [[_curPageTxt text]intValue];
    if (page<=_book.totalpage && page>=1){
        _curPage = page;
        [self doSearch];
    }
}
@end
