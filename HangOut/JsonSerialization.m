//
//  JsonSerialization.m
//  HangOut
//
//  Created by Mark Lv on 14-8-22.
//  Copyright (c) 2014年 1st Group. All rights reserved.
//

#import "JsonSerialization.h"

@implementation JsonSerialization

@synthesize request = _request;

-(id)initWithRequest:(NSURLRequest *)request
{
    self = [super init];
    if(self){
        _request = request;
    }
    return self;
}

-(NSMutableDictionary *)getSerialized
{
    downloadData = [NSURLConnection sendSynchronousRequest:_request returningResponse:nil error:nil];
    serializedDictionary = [NSJSONSerialization JSONObjectWithData:downloadData options:NSJSONReadingMutableContainers error:nil];
    for (NSString *s in [serializedDictionary allKeys])
    {
        NSLog(@"%@  %@",s,[serializedDictionary valueForKey:s]);
    }
    //    [connection release];
    //    [downloadData release];
    return serializedDictionary;
//    [serializedDictionary release];
}





@end
