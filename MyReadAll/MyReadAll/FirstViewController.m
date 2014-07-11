//
//  FirstViewController.m
//  MyReadAll
//
//  Created by Cheng Yi on 6/14/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "FirstViewController.h"
#import "FileCache.h"
#import "Volume.h"
#import "PageViewController.h"
#import "SearchResult.h"


@interface FirstViewController () 
@property(nonatomic) float screenWidth;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //_curVolId is set before load
    if (_selReadings==nil) {
        _selReadings = [[NSMutableArray alloc]init];
    }
    _wsClient = [CRApp getWSClient];
    _readings = [@[] mutableCopy];
    _curPage = 1;
    _appToolBar = [[AppToolBar alloc]init:self navCtrl:self.navigationController];
    [self.navigationItem setRightBarButtonItems:[_appToolBar getButtonArray]];
    
    //set type, columnNum by subClass
    
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float x=screenRect.size.width;
    float y=screenRect.size.height;
    _screenWidth = x<y?x:y;//always set to smaller dimension
    int width = _screenWidth/_columnNum -_readingLayout.minimumInteritemSpacing;
    int height = _height;
    if (_type==TYPE_PIC)
        height = width*3/2;
    NSLog(@"reading collection view width: %d, height:%d", width, height);//collection view bounds in pixel
    [self.readingLayout setItemSize:CGSizeMake(width, height)];//item size in points
    [self doSearch:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doSearch:(id)sender {
    NSString* userId=@"";
    NSString* catId=_curVolId;
    if ([CRApp isMyReading]){
        userId = [CRApp getUserId];
        //in myreading mode, userId will not be nil
    }else{
        userId=@"";
        if (catId==nil){
            catId=[self getRootCatList];
        }
    }
    
    int itemOffset = (_curPage-1)* CRApp.itemsPerPage;
    [_wsClient asyncGetReadingsByParam:[_searchTxt text] catId:catId userId:userId type:_type offset:itemOffset limit:CRApp.itemsPerPage postProcessor:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        _curPageTxt.text = [NSString stringWithFormat:@"%d", _curPage];
    });
}
- (IBAction)doPrev:(id)sender {
    if (_curPage>1){
        _curPage--;
        [self doSearch:sender];
    }
    
}
- (IBAction)doNext:(id)sender {
    if (_curPage<_totalPage){
        _curPage++;
        [self doSearch:sender];
    }
}
- (IBAction)setPage:(id)sender {
    int page = [[_curPageTxt text]intValue];
    if (page>0 && page<_totalPage){
        _curPage=page;
        [self doSearch:sender];
    }
}
//post process for the list of reading get from search
-(void) postProcess:(NSString*) searchTxt searchCat:(NSString*) catId offset:(int) offset limit:(int) limit
             result:(SearchResult*) result err:(NSError *)err{
    [self.readings removeAllObjects];
    [self.readings addObjectsFromArray:result.readings];
    int itemsPerPage = CRApp.itemsPerPage;
    if (result.count%itemsPerPage==0){
        self.totalPage = result.count/itemsPerPage;
    }else{
        self.totalPage = result.count/itemsPerPage + 1;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.readingCV reloadData];
        self.totalPageLbl.text = [NSString stringWithFormat:@"%d", self.totalPage];
    });
}



#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [_readings count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<Reading> reading=_readings[indexPath.row];
    if ([reading isKindOfClass:[Book class]]){
        [self performSegueWithIdentifier:@"OpenBook" sender:reading];
    }else if ([reading isKindOfClass:[Volume class]]){
        [self performSegueWithIdentifier:@"OpenVolume" sender:reading];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OpenBook"]) {
        PageViewController *pvController = segue.destinationViewController;
        pvController.book = sender;
        pvController.curPage = 1;
    }else if([segue.identifier isEqualToString:@"OpenVolume"]) {
        FirstViewController *pvController = segue.destinationViewController;
        pvController.curVolId = [sender getId];
    }
}

-(NSArray*) getSelected{
    return _selReadings;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
}
@end
