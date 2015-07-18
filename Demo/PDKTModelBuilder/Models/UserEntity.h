//
//  UserEntity.h
//  PDKTModelBuilder
//
//  Created by ANTONIO JIMÉNEZ MARTÍNEZ on 18/7/15.
//  Copyright (c) 2015 Produkt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PictureEntity;

@interface UserEntity : NSManagedObject

@property (nonatomic, retain) NSDate * entityUpdateDate;
@property (nonatomic, retain) id userBlogURL;
@property (nonatomic, retain) NSString * userEmail;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * userModificationDateUnixTimestamp;
@property (nonatomic, retain) NSSet *hasPictures;
@end

@interface UserEntity (CoreDataGeneratedAccessors)

- (void)addHasPicturesObject:(PictureEntity *)value;
- (void)removeHasPicturesObject:(PictureEntity *)value;
- (void)addHasPictures:(NSSet *)values;
- (void)removeHasPictures:(NSSet *)values;

@end
