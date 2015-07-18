//
//  PDKDataFromDictionaryTransformer.m
//  PDKTModelBuilder
//
//  Created by ANTONIO JIMÉNEZ MARTÍNEZ on 18/7/15.
//  Copyright (c) 2015 Produkt. All rights reserved.
//

#import "PDKDataFromDictionaryTransformer.h"

@implementation PDKDataFromDictionaryTransformer
- (id)transformValueFromObject:(id)object {
    if (!object || [object isEqual:[NSNull null]] || ![object isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return (NSData *)[NSKeyedArchiver archivedDataWithRootObject:object];
}
@end
