//
//  PDKTDataFromURLImageTransformer.m
//  PDKTModelBuilder
//
//  Created by ANTONIO JIMÉNEZ MARTÍNEZ on 19/7/15.
//  Copyright (c) 2015 Produkt. All rights reserved.
//

#import "PDKTDataFromURLImageTransformer.h"

@implementation PDKTDataFromURLImageTransformer
- (id)tranformValueFromObject:(id)object {
    if (!object || [object isEqual:[NSNull null]] || ![object isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSURL *imageURL = [NSURL URLWithString:object];
    NSData *data = [NSData dataWithContentsOfURL:imageURL];
    return data;
}
@end
