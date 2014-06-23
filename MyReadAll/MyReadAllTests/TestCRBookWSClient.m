//
//  TestCRBookWSClient.m
//  MyReadAll
//
//  Created by Cheng Yi on 6/18/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "../MyReadAll/CRBookWSClient.h"

@interface TestCRBookWSClient : XCTestCase
@property (nonatomic) CRBookWSClient* wsClient;
@end

@implementation TestCRBookWSClient

- (void)setUp {
    [super setUp];
    _wsClient = [[CRBookWSClient alloc]init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetVolumesByPCat {
    NSArray* array = [_wsClient getVolumesByPCat:@"DMZJ.MH" offset:0 limit:10];
    XCTAssertTrue([array count]==10);
    NSLog(@"%@%d%@%@", @"count:", [array count], @" content:", [array description]);
}

- (void)testGetVolumesLike {
    NSArray* array = [_wsClient getVolumesLike:@"%ac%" offset:0 limit:10];
    XCTAssertTrue([array count]==10);
    NSLog(@"%@%d%@%@", @"count:", [array count], @" content:", [array description]);
}

- (void)testGetVCByPCat {
    int count = [_wsClient getVCByPCat:@"DMZJ.MH"];
    XCTAssertTrue(count>10000);
}

- (void)testGetVCLike {
    int count = [_wsClient getVCLike:@"%ac%"];
    XCTAssertTrue(count>50);
}

- (void) testGetVolumeById{
    Volume* v = [_wsClient getVolumeById:@"DMZJ.MH"];
    NSLog(@"%@", [v description]);
}

- (void)testGetBooksByCat {
    NSArray* array = [_wsClient getBooksByCat:@"433-370" offset:0 limit:10];
    XCTAssertTrue([array count]==8);
    NSLog(@"%@%d%@%@", @"count:", [array count], @" content:", [array description]);
}

- (void)testGetBooksLike {
    NSArray* array = [_wsClient getBooksByName:@"%01%" offset:0 limit:10];
    XCTAssertTrue([array count]==10);
    NSLog(@"%@%d%@%@", @"count:", [array count], @" content:", [array description]);
}

- (void)testGetBCByCat {
    int count = [_wsClient getBCByCat:@"433-370"];
    XCTAssertTrue(count==8);
}

- (void)testGetBCByName {
    int count = [_wsClient getBCByName:@"%01%"];
    NSLog(@"%d", count);
    XCTAssertTrue(count>100);
}

- (void) testGetBookById{
    Book* b = [_wsClient getBookById:@"0zzxs-8521"];
    NSLog(@"%@", [b description]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
