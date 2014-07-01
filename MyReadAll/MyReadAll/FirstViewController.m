//
//  FirstViewController.m
//  MyReadAll
//
//  Created by Cheng Yi on 6/14/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "FirstViewController.h"
#import "CRBookWSClient.h"
#import "ReadingViewCell.h"
#import "FileCache.h"
#import "SearchCondition.h"
#import "Volume.h"
#import "PageViewController.h"
#import "SearchResult.h"
#import "CRApp.h"


@interface FirstViewController () 
            
@property(nonatomic) CRBookWSClient* wsClient;
@property(nonatomic) NSMutableArray* readings; //id<Reading>
@property(nonatomic) NSMutableArray* covers;//UIImage*
@property(nonatomic) float screenWidth;
@property (nonatomic) NSMutableArray* selReadings; //selected readings
@end

NSString* const CELL_ID=@"Reading";

@implementation FirstViewController

static int columnNum = 3;
static NSString* rootCat=nil;

+(NSString*) getRootCatList{
    if (rootCat==nil||[@"" isEqualToString:rootCat]){
        rootCat = [[NSString alloc]init];
        rootCat = [rootCat stringByAppendingFormat:@"999999"];
        rootCat = [rootCat stringByAppendingFormat:@","];
        rootCat = [rootCat stringByAppendingFormat:@"999998"];
    }
    return rootCat;
}
-(void) setMyReadingMode{
    NSString* uid = [CRApp getUserId];
    if (uid!=nil && ![@"" isEqualToString:uid]){
        [_LoginBarButton setTitle:uid];
        [_addMyReadingsBtn setEnabled:true];
        [_delMyReadingsBtn setEnabled:true];
    }else{
        _LoginBarButton.title=@"Login";
        [_addMyReadingsBtn setEnabled:false];
        [_delMyReadingsBtn setEnabled:false];
    }
}

- (void)viewDidLoad {
    NSLog(@"viewDidLoad called");
    [super viewDidLoad];
    [self setMyReadingMode];
    [CRApp addAttrChangedListener:self];
    if (_selReadings==nil) {
        _selReadings = [[NSMutableArray alloc]init];
    }
    _wsClient = [CRApp getWSClient];
    _readings = [@[] mutableCopy];
    _covers = [@[] mutableCopy];
    _curPage = 1;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float x=screenRect.size.width;
    float y=screenRect.size.height;
    _screenWidth = x<y?x:y;//always set to smaller dimension
    int width = _screenWidth/columnNum -_readingLayout.minimumInteritemSpacing;
    int height = width*3/2;
    NSLog(@"reading collection view width: %d, height:%d", width, height);//collection view bounds in pixel
    [self.readingLayout setItemSize:CGSizeMake(width, height)];//item size in points
    [self doSearch:self];
}

- (IBAction)myReadingClick:(id)sender{
    if ([CRApp isMyReading]){
        [CRApp setMyReading:false];
        [_selMyReading setSelected:false];
    }else{
        [CRApp setMyReading:true];
        [_selMyReading setSelected:true];
        //myReading starting from nil
        _curVolId=nil;
    }
    [self doSearch:self];
}

- (IBAction)addMyReadings:(id)sender {
    NSString* uid = [CRApp getUserId];
    if (uid!=nil && ![@"" isEqualToString:uid]) {
        [_wsClient asyncAddMyReading:uid ids:_selReadings postProcessor:self];
    }else{
        NSLog(@"uid is nil");
    }
}

- (IBAction)delMyReadings:(id)sender {
    NSString* uid = [CRApp getUserId];
    if (uid!=nil && ![@"" isEqualToString:uid]) {
        [_wsClient asyncDelMyReading:uid ids:_selReadings postProcessor:self];
    }else{
        NSLog(@"uid is nil");
    }
    [self doSearch:self];
}

//for myreading post process
-(void) myReadingPostProcess:(NSString*) userName ids:(NSArray*) ids rowsAffected:(int) rowsAffected err:(NSError*) err{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    if (rowsAffected<=0){
        alert.title = @"Error";
        alert.message=@"might already added.";
    }else{
        alert.title = @"Succees";
        alert.message = [NSString stringWithFormat: @"%d records updated.", rowsAffected];
    }
    [_selReadings removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}

//for attribute changed listener
-(void) attrChanged:(id) sender attrName:(NSString*) attrName oldValue:(id) oldValue newValue:(id) newValue{
    if (sender==[CRApp class]){
        if ([attrName isEqualToString:@"userId"]){
            [self setMyReadingMode];
        }
    }
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
        if (userId==nil||[@"" isEqualToString:userId]){
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.title = @"Info";
            alert.message = @"Please login to use this feature.";
            [alert show];
            //set it back
            [CRApp setMyReading:false];
            [_selMyReading setSelected:false];
            return;
        }else{
            //keep catId to nil
        }
    }else{
        userId=@"";
        if (catId==nil){
            catId=[FirstViewController getRootCatList];
        }
    }
    
    int itemOffset = (_curPage-1)* CRApp.itemsPerPage;
    [_wsClient asyncGetReadingsByParam:[_searchTxt text] catId:catId userId:userId offset:itemOffset limit:CRApp.itemsPerPage postProcessor:self];
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
    [_readings removeAllObjects];
    [_readings addObjectsFromArray:result.readings];
    //populate the corresponding cover image array with NSNull
    [_covers removeAllObjects];
    for (int i=0; i<[result.readings count]; i++) {
        [_covers addObject:[NSNull null]];
    }
    
    int itemsPerPage = CRApp.itemsPerPage;
    if (result.count%itemsPerPage==0){
        _totalPage = result.count/itemsPerPage;
    }else{
        _totalPage = result.count/itemsPerPage + 1;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_readingCV reloadData];
        _totalPageLbl.text = [NSString stringWithFormat:@"%d", _totalPage];
    });
}

//post process for the cover image
-(void) postProcess:(NSString*) url result:(NSData*) result ppParam:(id) ppParam err:(NSError *)err{
    UIImage* img = [UIImage imageWithData:result];
    SearchCondition* sc=(SearchCondition*)ppParam;
    if (([sc.searchTxt isEqualToString:[_searchTxt text]]||(sc.searchTxt==[_searchTxt text]))
        //&& ([sc.volId isEqualToString:_curVolId])
             &&(sc.pageNum == [[_curPageTxt text]intValue])
                && (img!=nil)){
        [_covers setObject:img atIndexedSubscript:[sc.indexPath row]];
        dispatch_queue_t main = dispatch_get_main_queue();
        dispatch_block_t block = ^{
            [_readingCV reloadItemsAtIndexPaths:@[sc.indexPath]];
        };
        if ([NSThread isMainThread]){
            block();
        }else{
            dispatch_async(main, block);
        }
    }
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
//process for each cells
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ReadingViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    id<Reading> reading=_readings[indexPath.row];
    //this cell may be reused, i need to check
    [cell setRid:[reading getId]];
    [cell setSelReadings:_selReadings];
    
    if ([reading isKindOfClass:[Book class]]){
        Book* b = (Book*)reading;
        cell.imageLabel.text = [NSString stringWithFormat:@"%@(%d)", b.bookName, b.totalpage];
    }else if ([reading isKindOfClass:[Volume class]]){
        cell.readingTypeImageView.image = [UIImage imageNamed:@"book_volume.jpg"];
        Volume* v = (Volume*)reading;
        cell.imageLabel.text = [NSString stringWithFormat:@"%@(%d)", v.name, v.bookNum];
    }
    [cell myInit];
    NSString* coverUrl=[reading getCoverUri];
    if (coverUrl==nil && [reading isKindOfClass:[Book class]]){
        coverUrl = [((Book*)reading) getPageUrl:1];
    }
    if (coverUrl==nil){
        NSLog(@"cover url not found for: %@", [reading description]);
    }
    id img = [_covers objectAtIndex:[indexPath row]];
    if (img==[NSNull null]){
        img = [UIImage imageNamed:@"empty_cover.jpg"];
        //
        SearchCondition* sc = [[SearchCondition alloc]init];
        sc.searchTxt=[_searchTxt text];
        sc.volId = _curVolId;
        sc.pageNum = [[_curPageTxt text] intValue];
        sc.indexPath = indexPath;
        sc.reading = reading;
        [_wsClient asyncGetImage:coverUrl ppParam:sc postProcessor:self];
    }
    cell.imageView.image=img;
    return cell;
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

@end
