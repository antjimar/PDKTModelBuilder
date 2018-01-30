//
//  PDKTLongTransformer.m
//  PDKTModelBuilder
//
//  Created by Javier Cadiz on 30/01/2018.
//  Copyright © 2018 Produkt. All rights reserved.
//

#import "PDKTLongTransformer.h"

@implementation PDKTLongTransformer
- (id)tranformValueFromObject:(id)object {
    if (![object respondsToSelector:@selector(longLongValue)]) {
        return [NSNumber numberWithLongLong:0];
    }

    return [NSNumber numberWithLongLong:[object longLongValue]];
}
@end
