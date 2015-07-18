//
//  NSManagedObjectModelsTests.m
//  PDKTModelBuilder
//
//  Created by Daniel García García on 11/11/14.
//  Copyright (c) 2014 Produkt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "UserEntity.h"
#import "PictureEntity.h"
#import "PDKTModelBuilder+CoreData.h"
#import "InMemoryCoreDataStack.h"

@interface NSManagedObjectModelsTests : XCTestCase
@property (strong,nonatomic) InMemoryCoreDataStack *coreDataStack;
@property (nonatomic,readonly) NSManagedObjectContext *managedObjectContext;
@end

@implementation NSManagedObjectModelsTests

- (void)setUp {
    [super setUp];
    self.coreDataStack = [[InMemoryCoreDataStack alloc]initWithModelName:@"PDKTModelBuilder"];
}

- (NSManagedObjectContext *)managedObjectContext{
    return self.coreDataStack.managedObjectContext;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNSManagedObjectCreation {
    NSDictionary *userDictionary = @{
                                     @"id":@"1",
                                     @"name":@"John Doe",
                                     @"email":@"john.doe@apple.com",
                                     @"blog_url":@"www.tumblr.com/johndoe"
                                     };
    
    UserEntity *user = [UserEntity updateOrInsertIntoManagedObjectContext:self.managedObjectContext withDictionary:userDictionary];
    XCTAssertEqualObjects(user.userId, @"1");
    XCTAssertEqualObjects(user.userName, @"John Doe");
    XCTAssertEqualObjects(user.userEmail, @"john.doe@apple.com");
    XCTAssertEqualObjects(user.userBlogURL, [NSURL URLWithString:@"www.tumblr.com/johndoe"]);
    
    
    
    
    NSDictionary *pictureDictionary = @{
                                        @"id":@"1",
                                        @"url":@"www.apple.com/images/picture.jpg",
                                        @"published_on":@"1415735002"
                                        };
    
    PictureEntity *picture = [PictureEntity updateOrInsertIntoManagedObjectContext:self.managedObjectContext withDictionary:pictureDictionary];
    XCTAssertEqualObjects(picture.pictureId, @"1");
    XCTAssertEqualObjects(picture.picturePublishedDate, [NSDate dateWithTimeIntervalSince1970:1415735002]);
    XCTAssertEqualObjects(picture.pictureURL, [NSURL URLWithString:@"www.apple.com/images/picture.jpg"]);
    
}

- (void)testEntityUpdateDate {
    NSMutableDictionary *userDictionary = [@{
                                             @"id":@"1",
                                             @"name":@"John Doe",
                                             @"email":@"john.doe@apple.com",
                                             @"blog_url":@"www.tumblr.com/johndoe"
                                         } mutableCopy];
    
    UserEntity *user = [UserEntity updateOrInsertIntoManagedObjectContext:self.managedObjectContext withDictionary:userDictionary];
    XCTAssertNotNil(user.entityUpdateDate);
    NSDate *updateDate = user.entityUpdateDate;
    
    [userDictionary setObject:@"john.doe@apple.es" forKey:@"email"];
    user = [UserEntity updateOrInsertIntoManagedObjectContext:self.managedObjectContext withDictionary:userDictionary];
    XCTAssertNotNil(user.entityUpdateDate);
    XCTAssertNotEqualObjects(user.entityUpdateDate, updateDate);
}

- (void)testNSManagedObjectsRelationships {
    NSDictionary *userDictionary = @{
                                     @"id":@"1",
                                     @"name":@"John Doe",
                                     @"email":@"john.doe@apple.com",
                                     @"blog_url":@"www.tumblr.com/johndoe",
                                     @"pictures":@[
                                                  @{
                                                    @"id":@"1",
                                                    @"url":@"www.apple.com/images/picture.jpg",
                                                    @"published_on":@"1415735002"
                                                    },
                                                  @{
                                                    @"id":@"2",
                                                    @"url":@"www.apple.com/images/picture2.jpg",
                                                    @"published_on":@"1415735002"
                                                    }
                                         ]
                                     };
    
    UserEntity *user = [UserEntity updateOrInsertIntoManagedObjectContext:self.managedObjectContext withDictionary:userDictionary];
    XCTAssertNotNil(user.hasPictures);
    XCTAssertNotEqual(user.hasPictures.count, 0);
    for (PictureEntity *picture in user.hasPictures) {
        XCTAssert([picture isKindOfClass:[PictureEntity class]]);
        
        // Check inverse relationship
        XCTAssertEqualObjects(picture.author, user);
    }
}

- (void)testAPIResponseHotFix {
    NSDictionary *userDictionary = @{
                                     @"id":@"1",
                                     @"name":@"John Doe",
                                     @"email":@"john.doe@apple.com",
                                     @"blog":@{
                                             @"John Doe's blog"
                                             @"url":@"www.tumblr.com/johndoe"
                                     },
                                     @"user_pictures":@[
                                             @{
                                                 @"id":@"1",
                                                 @"url":@"www.apple.com/images/picture.jpg",
                                                 @"published_on":@"1415735002"
                                                 },
                                             @{
                                                 @"id":@"2",
                                                 @"url":@"www.apple.com/images/picture2.jpg",
                                                 @"published_on":@"1415735002"
                                                 }
                                             ]
                                     };
    
    UserEntity *user = [UserEntity updateOrInsertIntoManagedObjectContext:self.managedObjectContext withDictionary:userDictionary];
    XCTAssertNotNil(user.hasPictures);
    XCTAssertNotEqual(user.hasPictures.count, 0);
    for (PictureEntity *picture in user.hasPictures) {
        XCTAssert([picture isKindOfClass:[PictureEntity class]]);
        
        // Check inverse relationship
        XCTAssertEqualObjects(picture.author, user);
    }
}

- (void)testEqualComparableAttributes {
    NSDictionary *userDictionary = @{
                                     @"id":@"1",
                                     @"name":@"John Doe",
                                     @"email":@"john.doe@apple.com",
                                     @"blog_url":@"www.tumblr.com/johndoe",
                                     @"updated_at": @1437216918
                                     };
    
    UserEntity *user = [UserEntity updateOrInsertIntoManagedObjectContext:self.managedObjectContext withDictionary:userDictionary];
    XCTAssertEqualObjects(user.userId, @"1");
    XCTAssertEqualObjects(user.userName, @"John Doe");
    XCTAssertEqualObjects(user.userEmail, @"john.doe@apple.com");
    XCTAssertEqualObjects(user.userBlogURL, [NSURL URLWithString:@"www.tumblr.com/johndoe"]);
    
    NSDate *dateSaved = user.entityUpdateDate;
    
    UserEntity *userUpdated = [UserEntity updateOrInsertIfNeededIntoManagedObjectContext:self.managedObjectContext withDictionary:userDictionary];
    XCTAssertEqualObjects(userUpdated.userId, @"1");
    XCTAssertEqualObjects(userUpdated.userName, @"John Doe");
    XCTAssertEqualObjects(userUpdated.userEmail, @"john.doe@apple.com");
    XCTAssertEqualObjects(userUpdated.userBlogURL, [NSURL URLWithString:@"www.tumblr.com/johndoe"]);
    XCTAssertEqualObjects(userUpdated.entityUpdateDate, dateSaved);
}

- (void)testNotEqualComparableAttributes {
    NSDictionary *userDictionary = @{
                                     @"id":@"1",
                                     @"name":@"John Doe",
                                     @"email":@"john.doe@apple.com",
                                     @"blog_url":@"www.tumblr.com/johndoe",
                                     @"updated_at": @1437216918
                                     };
    
    UserEntity *user = [UserEntity updateOrInsertIntoManagedObjectContext:self.managedObjectContext withDictionary:userDictionary];
    XCTAssertEqualObjects(user.userId, @"1");
    XCTAssertEqualObjects(user.userName, @"John Doe");
    XCTAssertEqualObjects(user.userEmail, @"john.doe@apple.com");
    XCTAssertEqualObjects(user.userBlogURL, [NSURL URLWithString:@"www.tumblr.com/johndoe"]);
    
    NSDate *dateSaved = user.entityUpdateDate;
    
    NSDictionary *userDictionaryUpdated = @{
                                     @"id":@"1",
                                     @"name":@"John Doe Updated",
                                     @"email":@"john.doe@apple.com",
                                     @"blog_url":@"www.tumblr.com/johndoe",
                                     @"updated_at": @1437216919
                                     };
    
    UserEntity *userUpdated = [UserEntity updateOrInsertIfNeededIntoManagedObjectContext:self.managedObjectContext withDictionary:userDictionaryUpdated];
    XCTAssertEqualObjects(userUpdated.userId, @"1");
    XCTAssertEqualObjects(userUpdated.userName, @"John Doe Updated");
    XCTAssertEqualObjects(userUpdated.userEmail, @"john.doe@apple.com");
    XCTAssertEqualObjects(userUpdated.userBlogURL, [NSURL URLWithString:@"www.tumblr.com/johndoe"]);
    XCTAssertNotEqualObjects(userUpdated.entityUpdateDate, dateSaved);
}

@end
