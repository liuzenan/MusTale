//
//  NSString+URLEncoding.m
//  MusTale
//
//  Created by Jiao Jing Ping on 23/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "NSString+URLEncoding.h"
@implementation NSString (URLEncoding)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
	return (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)self,NULL,(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(encoding));
}
@end
