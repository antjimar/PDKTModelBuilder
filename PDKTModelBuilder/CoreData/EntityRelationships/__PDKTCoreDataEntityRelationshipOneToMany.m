//
//  __PDKTCoreDataEntityRelationshipOneToMany.m
//  PDKTModelBuilder
//
//  Created by Daniel García García on 07/10/14.
//  Copyright (c) 2014 Produkt. All rights reserved.
//

#import "__PDKTCoreDataEntityRelationshipOneToMany.h"

@implementation __PDKTCoreDataEntityRelationshipOneToMany
- (void)parseRelationshipInDictionary:(NSDictionary *)dictionary withEntity:(NSManagedObject *)entity relationshipProperty:(NSString *)relationshipProperty inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    id relationshipData = [dictionary valueForKeyPath:self.keyPath];
    if ([relationshipData isKindOfClass:[NSArray class]]) {
        NSArray *relationshipDataArray = (NSArray *)relationshipData;
        if ([relationshipDataArray count] > 0) {
            
            // get set of current entities
            NSSet *relationShipSet = [entity valueForKey:relationshipProperty];
            // list of currents id's
            NSMutableArray *currentIds = [[NSMutableArray alloc] init];
            if (relationShipSet.count > 0) {
                NSManagedObject *entity = relationShipSet.allObjects.firstObject;
                if ([entity conformsToProtocol: @protocol(PDKTModelBuilderCoreDataEntity)]) {
                    NSString *objectIdName = [[(id<PDKTModelBuilderCoreDataEntity>)entity class] entityIdPropertyName];
                    for (NSManagedObject *relationShipEntity in relationShipSet.allObjects) {
                        if ([relationShipEntity conformsToProtocol: @protocol(PDKTModelBuilderCoreDataEntity)]) {
                            NSString *objectIdValue = [relationShipEntity valueForKey:objectIdName];
                            [currentIds addObject:objectIdValue];
                        }
                    }
                    
                    // here, currentIds has a list of entities ids saved in the data base
                    
                    // get ids from json to compare
                    // id property binding
                    NSDictionary *propertiesBindings = [[(id<PDKTModelBuilderCoreDataEntity>)entity class] propertiesBindings];
                    NSString *sourcePath = [propertiesBindings valueForKey:objectIdName];
                    
                    NSMutableArray *serverIds = [[NSMutableArray alloc] init];
                    for (NSDictionary *relationshipItem in relationshipDataArray) {
                        [serverIds addObject:[relationshipItem objectForKey:sourcePath]];
                    }
                    
                    // ids for entities to remove from data base
                    NSMutableArray *entitiesIdsToRemove = [NSMutableArray arrayWithArray:currentIds];
                    [entitiesIdsToRemove removeObjectsInArray:serverIds];
                    
                    // remove
                    for (NSManagedObject *relationShipEntity in relationShipSet.allObjects) {
                        if ([relationShipEntity conformsToProtocol: @protocol(PDKTModelBuilderCoreDataEntity)]) {
                            NSString *objectIdValue = [relationShipEntity valueForKey:objectIdName];
                            if ([entitiesIdsToRemove containsObject:objectIdValue]) {
                                [managedObjectContext deleteObject:relationShipEntity];
                            }
                        }
                    }
                    
                    // update current entities
                    for (NSDictionary *relationshipItem in relationshipDataArray) {
                        id item = [self parseItemData:relationshipItem withClass:self.relatedClass inManagedObjectContext:managedObjectContext];
                        if (item) {
                            [self addItem:item toEntity:entity toColletionInPropertyWithName:relationshipProperty relationShipSet: relationShipSet];
                        }
                    }
                }
            } else {
                // current object doesn't have relationship data and we have to add all data array from json (new entities to add)
                for (NSDictionary *relationshipItem in relationshipDataArray) {
                    id item = [self parseItemData:relationshipItem withClass:self.relatedClass inManagedObjectContext:managedObjectContext];
                    if (item) {
                        [self addItem:item toEntity:entity toColletionInPropertyWithName:relationshipProperty relationShipSet: relationShipSet];
                    }
                }
            }
        } else {
            [self removeInContext:managedObjectContext relationshipProperty:relationshipProperty entity:entity];
        }
    }
}
- (id)parseItemData:(NSDictionary *)itemData withClass:(Class)itemClass inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    return [itemClass updateOrInsertIntoManagedObjectContext:managedObjectContext withDictionary:itemData];
}
- (void)addItem:(id)item toEntity:(NSManagedObject *)entity toColletionInPropertyWithName:(NSString *)relationshipPropertyName relationShipSet:(NSSet *)relationShipSet {
    if (![relationShipSet containsObject:item]) {
        NSString *addObjectsSelectorName = [NSString stringWithFormat:@"add%@Object:", [relationshipPropertyName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[relationshipPropertyName substringToIndex:1] capitalizedString]]];
        SEL selector = NSSelectorFromString(addObjectsSelectorName);
        if ([entity respondsToSelector:selector]) {
            NSMethodSignature *methodSignature = [entity methodSignatureForSelector:selector];
            NSInvocation *methodInvocation = [NSInvocation invocationWithMethodSignature:methodSignature];
            [methodInvocation setSelector:selector];
            [methodInvocation setTarget:entity];
            [methodInvocation setArgument:&item atIndex:2];
            [methodInvocation invoke];
        }
    }
}

#pragma mark - Private
- (void)removeInContext:(NSManagedObjectContext *)managedObjectContext relationshipProperty:(NSString *)relationshipProperty entity:(NSManagedObject *)entity {
    for (NSManagedObject *element in [entity valueForKey:relationshipProperty]) {
        [managedObjectContext deleteObject:element];
    }
}

@end
