//
//  NetworkUtils.m
//  Attention Grabber
//
//  Created by Rory Mulligan on 2/17/17.
//  Copyright © 2017 Rory Mulligan. All rights reserved.
//

#import "NetworkUtils.h"

@implementation NetworkUtils

+(NSString *)ipAddress {
    for(NSString *address in [[NSHost currentHost] addresses]) {
        if([[address componentsSeparatedByString:@"."] count] == 4) {
            return address;
        }
    }
    
    return @"Invalid IP";
}

@end
