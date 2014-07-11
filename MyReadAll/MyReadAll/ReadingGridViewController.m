//
//  ReadingGridViewController.m
//  ReadAll
//
//  Created by Cheng Yi on 7/10/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "ReadingGridViewController.h"
#import "ReadingImageCell.h"

@interface ReadingGridViewController ()
@property(nonatomic) NSMutableArray* covers;//UIImage*

@end

NSString* const IMAGE_CELL_ID=@"ReadingImageCell";

@implementation ReadingGridViewController


static NSString* rootCat=nil;

-(NSString*) getRootCatList{
    if (rootCat==nil||[@"" isEqualToString:rootCat]){
        rootCat = [[NSString alloc]init];
        rootCat = [rootCat stringByAppendingFormat:@"999999"];
        rootCat = [rootCat stringByAppendingFormat:@","];
        rootCat = [rootCat stringByAppendingFormat:@"999998"];
    }
    return rootCat;
}

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
    _covers = [@[] mutableCopy];
    [super setType:TYPE_PIC];
    [super setColumnNum:3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//post process for the list of reading get from search
-(void) postProcess:(NSString*) searchTxt searchCat:(NSString*) catId offset:(int) offset limit:(int) limit
             result:(SearchResult*) result err:(NSError *)err{
    [super postProcess:searchTxt searchCat:catId offset:offset limit:limit result:result err:err];
    
    //populate the corresponding cover image array with NSNull
    [_covers removeAllObjects];
    for (int i=0; i<[result.readings count]; i++) {
        [_covers addObject:[NSNull null]];
    }
}

//post process for the each reading got
-(void) postProcess:(NSString*) url result:(NSData*) result ppParam:(id) ppParam err:(NSError *)err{
    UIImage* img = [UIImage imageWithData:result];
    SearchCondition* sc=(SearchCondition*)ppParam;
    if (([sc.searchTxt isEqualToString:[super.searchTxt text]]||(sc.searchTxt==[super.searchTxt text]))
        //&& ([sc.volId isEqualToString:_curVolId])
        &&(sc.pageNum == [[super.curPageTxt text]intValue])
        && (img!=nil)){
        [_covers setObject:img atIndexedSubscript:[sc.indexPath row]];
        dispatch_queue_t main = dispatch_get_main_queue();
        dispatch_block_t block = ^{
            [self.readingCV reloadItemsAtIndexPaths:@[sc.indexPath]];
        };
        if ([NSThread isMainThread]){
            block();
        }else{
            dispatch_async(main, block);
        }
    }
}

//process for each cells
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ReadingImageCell *cell = [cv dequeueReusableCellWithReuseIdentifier:IMAGE_CELL_ID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    id<Reading> reading=self.readings[indexPath.row];
    //this cell may be reused, i need to check
    [cell setRid:[reading getId]];
    [cell setSelReadings:self.selReadings];
    
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
        sc.searchTxt=[self.searchTxt text];
        sc.volId = self.curVolId;
        sc.pageNum = [[self.curPageTxt text] intValue];
        sc.indexPath = indexPath;
        sc.reading = reading;
        
        NSString* referer=[CRApp getTemplate:[reading getId]].referer;
        
        [self.wsClient asyncGetImage:coverUrl referer:referer ppParam:sc postProcessor:self];
    }
    cell.imageView.image=img;
    return cell;
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
