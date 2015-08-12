//
//  OUtility.m
//  tdzs
//
//  Created by xu dongming on 21/7/15.
//  Copyright (c) 2015 xu dongming. All rights reserved.
//

#import "OUtility.h"

@implementation OUtility

+(NSString*) NSDataToHex:(NSData*)data
{
    NSUInteger bytesCount = data.length;
    const char *hexChars = "0123456789ABCDEF";
    const unsigned char *dataBuffer = data.bytes;
    char *chars = malloc(sizeof(char) * (bytesCount * 2 + 1));
    char *s = chars;
    for (unsigned i = 0; i < bytesCount; ++i) {
        *s++ = hexChars[((*dataBuffer & 0xF0) >> 4)];
        *s++ = hexChars[(*dataBuffer & 0x0F)];
        dataBuffer++;
    }
    *s = '\0';
    NSString *hexString = [NSString stringWithUTF8String:chars];
    free(chars);
    return hexString;
}

@end
