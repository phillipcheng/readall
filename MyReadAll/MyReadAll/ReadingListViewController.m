//
//  ReadingListViewController.m
//  ReadAll
//
//  Created by Cheng Yi on 7/7/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "ReadingListViewController.h"
#import "ReadingRowCell.h"

@interface ReadingListViewController ()
@end

NSString* const ROW_CELL_ID=@"ReadingRowCell";

@implementation ReadingListViewController

static NSString* rootCat=nil;

-(NSString*) getRootCatList{
    if (rootCat==nil||[@"" isEqualToString:rootCat]){
        rootCat = [[NSString alloc]init];
        rootCat = [rootCat stringByAppendingFormat:@"999996"];
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
    [super setType:TYPE_NOVEL];
    [super setColumnNum:1];
    [super setHeight:30];
    
    [super postLoad];
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
}

//process for each cells
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ReadingRowCell *cell = [cv dequeueReusableCellWithReuseIdentifier:ROW_CELL_ID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    id<Reading> reading=self.readings[indexPath.row];
    //this cell may be reused, i need to check
    [cell setRid:[reading getId]];
    [cell setSelReadings:self.selReadings];
    [cell myInit];
    cell.titleLbl.text = [reading getName];
    cell.authorLbl.text = [reading getAuthor];
    cell.itemNumLbl.text = [NSString stringWithFormat:@"%d", [reading getItemNum]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
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
