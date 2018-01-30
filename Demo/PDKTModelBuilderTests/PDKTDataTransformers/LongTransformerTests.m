//
//  LongTransformerTests.m
//  PDKTModelBuilderTests
//
//  Created by Javier Cadiz on 30/01/2018.
//  Copyright © 2018 Produkt. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PDKTLongTransformer.h"

@interface LongTransformerTests : XCTestCase
@property (strong,nonatomic) PDKTLongTransformer *longTransformer;
@end

@implementation LongTransformerTests

- (void)setUp {
    [super setUp];
    self.longTransformer = [PDKTLongTransformer new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIsOfKindNumber {
    XCTAssert([[self.longTransformer tranformValueFromObject:@"31536000000"] isKindOfClass:NSClassFromString(@"__NSCFNumber")]);
}

- (void)testLongFromString {
    NSNumber *number = [self.longTransformer tranformValueFromObject:@"31536000000"];
    XCTAssertEqual([number longLongValue], 31536000000);
}

@end
