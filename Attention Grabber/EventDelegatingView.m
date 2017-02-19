//
//  EventDelegatingView.m
//  Attention Grabber
//
//  Created by Rory Mulligan on 2/17/17.
//  Copyright © 2017 Rory Mulligan. All rights reserved.
//

#import "EventDelegatingView.h"

@implementation EventDelegatingView

-(void)keyUp:(NSEvent *)event {
    [self.delegate keyUp:event inView:self];
}

-(void)keyDown:(NSEvent *)event {
    [self.delegate keyDown:event inView:self];
}

-(BOOL)canBecomeKeyView {
    return YES;
}

-(BOOL)acceptsFirstResponder {
    return YES;
}

@end
