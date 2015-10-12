//
//  ViewController.m
//  usc-hyperloop-ios
//
//  Created by Erik Strottmann on 10/11/15.
//  Copyright © 2015 USC Hyperloop. All rights reserved.
//

#import "ViewController.h"
#import <Socket_IO_Client_Swift/Socket_IO_Client_Swift-Swift.h>

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIButton *connectButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Socket.IO
    
    SocketIOClient* socket = [[SocketIOClient alloc] initWithSocketURL:@"localhost:1337" opts:nil];
    
    [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
    }];
    
    [socket on:@"chat" callback:^(NSArray *data, SocketAckEmitter *ack) {
        NSLog(@"received 'chat' event with data: %@", data);
    }];
    
    /*
    [socket on:@"currentAmount" callback:^(NSArray* data, SocketAckEmitter* ack) {
        double cur = [[data objectAtIndex:0] floatValue];
        
        [socket emitWithAck:@"canUpdate" withItems:@[@(cur)]](0, ^(NSArray* data) {
            [socket emit:@"update" withItems:@[@{@"amount": @(cur + 2.50)}]];
        });
        
        [ack with:@[@"Got your currentAmount, ", @"dude"]];
    }];
    */
    
    [socket connect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)sendMessage:(id)sender {
    NSLog(@"Button: send message");
}

- (IBAction)toggleConnection:(id)sender {
    NSLog(@"Button: connect");
}

@end
