//
//  JsonSerialization.h
//  HangOut
//
//  Created by Mark Lv on 14-8-22.
//  Copyright (c) 2014年 1st Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonSerialization : NSObject<NSURLConnectionDataDelegate>
{
    NSData *downloadData;
    NSMutableDictionary *serializedDictionary;
    NSURLRequest *_request;
    

}

@property(nonatomic,retain)NSURLRequest *request;

-(id)initWithRequest:(NSURLRequest *)request;
-(NSMutableDictionary *)getSerialized;

@end
