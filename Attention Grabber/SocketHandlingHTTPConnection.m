//
//  SocketHandlingHTTPConnection.m
//  Attention Grabber
//
//  Created by Rory Mulligan on 2/17/17.
//  Copyright © 2017 Rory Mulligan. All rights reserved.
//

#import "SocketHandlingHTTPConnection.h"
#import "WebSocket.h"
#import "HTTPFileResponse.h"

@implementation SocketHandlingHTTPConnection

-(NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    if([path isEqualToString:@"/"]) {
        return [[HTTPFileResponse alloc] initWithFilePath:[[NSBundle mainBundle] pathForResource:@"client" ofType:@"html"] forConnection:self];
    }
    
    return [super httpResponseForMethod:method URI:path];
}

-(WebSocket *)webSocketForURI:(NSString *)path {
    if([path isEqualToString:@"/ws"]) {
        return [[WebSocket alloc] initWithRequest:request socket:asyncSocket];
    }
    
    return [super webSocketForURI:path];
}

@end
