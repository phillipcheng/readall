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

@interface FirstViewController () 
            
@property(nonatomic) CRBookWSClient* wsClient;
@property(nonatomic) NSMutableArray* readings; //id<Reading>
@property(nonatomic) NSMutableArray* covers;//UIImage*

@end

NSString* const CELL_ID=@"Reading";

@implementation FirstViewController
            
- (void)viewDidLoad {
    NSLog(@"viewDidLoad called");
    [super viewDidLoad];
    _wsClient = [[CRBookWSClient alloc]init];
    _readings = [@[] mutableCopy];
    _covers = [@[] mutableCopy];
    _rootCatId = @"999999";
    _curVol = [[Volume RootVolumes] objectForKey:_rootCatId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doSearch:(id)sender {
    [_wsClient asyncGetReadingsByParam:[_searchTxt text] catId:_rootCatId offset:0 limit:20 postProcessor:self];
}
- (IBAction)doPrev:(id)sender {
}
- (IBAction)doNext:(id)sender {
}

-(void) postProcess:(NSString*) searchTxt searchCat:(NSString*) catId offset:(int) offset limit:(int) limit result:(NSArray*) result{
    [_readings removeAllObjects];
    [_readings addObjectsFromArray:result];
    //populate the corresponding cover image array with NSNull
    [_covers removeAllObjects];
    for (int i=0; i<[result count]; i++) {
        [_covers addObject:[NSNull null]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_readingCV reloadData];
    });
}

-(void) postProcess:(NSString*) url result:(NSData*) result ppParam:(id) ppParam{
    UIImage* img = [UIImage imageWithData:result];
    SearchCondition* sc=(SearchCondition*)ppParam;
    if (([sc.searchTxt isEqualToString:[_searchTxt text]])
        && ([sc.volId isEqualToString:_curVol.volId])
             &&(sc.pageNum == [[_curPageTxt text]intValue])
                && (img!=nil)){
        [_covers setObject:img atIndexedSubscript:[sc.indexPath row]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_readingCV reloadItemsAtIndexPaths:@[sc.indexPath]];
        });
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
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ReadingViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    id<Reading> reading=_readings[indexPath.row];
    NSString* coverUrl=[reading getCoverUri];
    if (coverUrl==nil && [reading isKindOfClass:[Book class]]){
        coverUrl = [((Book*)reading) getPageUrl:1];
    }
    if (coverUrl==nil){
        NSLog(@"cover url not found for: %@", [reading description]);
    }
    id img = [_covers objectAtIndex:[indexPath row]];
    if (img==[NSNull null]){
        img = [UIImage imageNamed:@"resources.bundle/empty_cover.jpg"];
        //
        SearchCondition* sc = [[SearchCondition alloc]init];
        sc.searchTxt=[_searchTxt text];
        sc.volId = _curVol.volId;
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
    }else{
        
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
    }
}
@end
