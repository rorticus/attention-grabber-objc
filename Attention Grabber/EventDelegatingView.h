//
//  EventDelegatingView.h
//  Attention Grabber
//
//  Created by Rory Mulligan on 2/17/17.
//  Copyright © 2017 Rory Mulligan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class EventDelegatingView;

@protocol EventDelegatingViewProtocol

-(void) keyUp:(NSEvent *) event inView:(EventDelegatingView *)view;
-(void) keyDown:(NSEvent *) event inView:(EventDelegatingView *)view;

@end

@interface EventDelegatingView : NSView

@property (weak) IBOutlet id<EventDelegatingViewProtocol> delegate;

@end
