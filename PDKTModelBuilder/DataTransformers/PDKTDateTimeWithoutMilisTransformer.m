//
//  PDKTDateTimeWithoutMilisTransformer.m
//  PDKTModelBuilder
//
//  Created by Antonio on 17/1/16.
//  Copyright © 2016 Produkt. All rights reserved.
//

#import "PDKTDateTimeWithoutMilisTransformer.h"

@implementation PDKTDateTimeWithoutMilisTransformer

- (id)tranformValueFromObject:(id)object {
    if (!object || [object isEqual:[NSNull null]]) {
        return nil;
    }
    NSString *objectDescription = [NSString stringWithFormat:@"%@", object];
    NSDate *date = nil;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:objectDescription];
    if ([alphaNumbersSet isSupersetOfSet:stringSet]) {
        date = [NSDate dateWithTimeIntervalSince1970:[objectDescription integerValue]];
    } else {
        static dispatch_once_t onceToken;
        static NSDateFormatter *entyPropertyDateFormatter;
        dispatch_once(&onceToken, ^{
            entyPropertyDateFormatter = [[NSDateFormatter alloc] init];
            entyPropertyDateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            entyPropertyDateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
            [entyPropertyDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        });
        date = [entyPropertyDateFormatter dateFromString:objectDescription];
    }
    return date;
}

@end
