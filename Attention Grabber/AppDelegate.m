//
//  AppDelegate.m
//  Attention Grabber
//
//  Created by Rory Mulligan on 2/17/17.
//  Copyright © 2017 Rory Mulligan. All rights reserved.
//

#import "AppDelegate.h"
#import "NetworkUtils.h"
#import "EventDelegatingView.h"
#import "HTTPServer.h"
#import "SocketHandlingHTTPConnection.h"
#import "WebSocket.h"

@interface AppDelegate () <EventDelegatingViewProtocol> {
    HTTPServer *httpServer;
}

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *statusLabel;
@property (weak) IBOutlet NSTextField *helpLabel;
@property (weak) IBOutlet NSTextField *connectionLabel;
@property (strong) NSString *ipAddress;
@property (assign) BOOL isActive;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.window.titlebarAppearsTransparent = YES;
    self.window.titleVisibility = YES;
    self.window.movableByWindowBackground = YES;
    
    httpServer = [[HTTPServer alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.ipAddress = [NetworkUtils ipAddress];
        
        [httpServer setInterface:self.ipAddress];
        [httpServer setPort:8080];
        [httpServer setConnectionClass:[SocketHandlingHTTPConnection class]];
        
        NSError *error;
        if(![httpServer start:&error]) {
            NSLog(@"Error starting HTTP Server, %@", error);
        }

        dispatch_sync(dispatch_get_main_queue(), ^{
            [self updateUI];
        });
    });
    
    self.isActive = NO;
        
    [[NSNotificationCenter defaultCenter] addObserverForName:@"HTTPUpdated" object:nil queue:DISPATCH_QUEUE_PRIORITY_DEFAULT usingBlock:^(NSNotification * _Nonnull note) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUI];
        });
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:WebSocketDidDieNotification object:nil queue:DISPATCH_QUEUE_PRIORITY_DEFAULT usingBlock:^(NSNotification * _Nonnull note) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUI];
        });
    }];
    
    [self updateUI];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

-(BOOL) isConnected {
    return httpServer.isRunning;
}

-(void)keyUp:(NSEvent *)event inView:(EventDelegatingView *)view {
    [self turnOff];
}

-(void)keyDown:(NSEvent *)event inView:(EventDelegatingView *)view {
    [self turnOn];
}

-(void) updateUI {
    if(![self isConnected]) {
        self.window.backgroundColor = [NSColor yellowColor];
        self.statusLabel.textColor = [NSColor blackColor];
        self.statusLabel.stringValue = @"Please Wait...";
        
        self.helpLabel.textColor = [NSColor blackColor];
        self.helpLabel.stringValue = @"Your network address is being detected.\nThis should take less than a minute.";
        
        self.connectionLabel.hidden = YES;
    } else {
        if(self.isActive) {
            self.window.backgroundColor = [NSColor whiteColor];
            
            self.statusLabel.textColor = [NSColor blackColor];
            self.helpLabel.textColor = [NSColor blackColor];
            self.connectionLabel.textColor = [NSColor blackColor];
        } else {
            self.window.backgroundColor = [NSColor blackColor];
            
            self.statusLabel.textColor = [NSColor whiteColor];
            self.helpLabel.textColor = [NSColor whiteColor];
            self.connectionLabel.textColor = [NSColor whiteColor];
        }
        
        if(httpServer.numberOfWebSocketConnections == 0) {
            self.statusLabel.stringValue = @"Ready!";
        } else {
            self.statusLabel.stringValue = [NSString stringWithFormat:@"%ld connection%@", httpServer.numberOfWebSocketConnections, httpServer.numberOfWebSocketConnections == 1 ? @"" : @"s"];
        }
        
        self.helpLabel.stringValue = @"On another computer, open up a web browser to:";
        
        self.connectionLabel.hidden = NO;
        
        if(self.ipAddress) {
            self.connectionLabel.stringValue = [NSString stringWithFormat:@"http://%@/", self.ipAddress];
        } else {
            self.connectionLabel.stringValue = @"(detecting network address...)";
        }
    }
}

-(void) turnOn {
    if(self.isActive == NO) {
        NSLog(@"on");
        self.isActive = YES;
        [self updateUI];
        
        [httpServer sendToAllWebSockets:@"on"];
    }
}

-(void) turnOff {
    if(self.isActive == YES) {
        NSLog(@"off");
        
        self.isActive = NO;
        
        [self updateUI];
        
        [httpServer sendToAllWebSockets:@"off"];
    }
}

-(IBAction) urlClicked {
    
}

@end
