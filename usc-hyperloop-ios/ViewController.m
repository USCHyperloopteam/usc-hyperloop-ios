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

@property (nonatomic, strong) SocketIOClient *socket;
@property (nonatomic, weak) IBOutlet UIButton *connectButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Socket.IO
    
    self.socket = [[SocketIOClient alloc] initWithSocketURL:@"localhost:1337/data" opts:nil];
    
    [self.socket onAny:^(SocketAnyEvent *data) {
        NSLog(@"Received socket event!!!");
    }];
    
    /*
    [socket on:@"connect" callback:^(NSArray *data, SocketAckEmitter *ack) {
        NSLog(@"socket connected");
    }];
    
    [socket on:@"disconnect" callback:^(NSArray *data, SocketAckEmitter *ack) {
        NSLog(@"socket disconnected");
    }];
    
    [socket on:@"chat" callback:^(NSArray *data, SocketAckEmitter *ack) {
        NSLog(@"received 'chat' event with data: %@", data);
    }];
    */
    
//    [self.socket connect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)sendMessage:(id)sender {
    NSLog(@"Button: send message");
    
    [self.socket emit:@"data" withItems:@[@12]];
}

- (IBAction)toggleConnection:(id)sender {
    NSLog(@"Button: connect");
    
    [self.socket connect];
//    [self.socket connectWithTimeoutAfter:10 withTimeoutHandler:^{
//        NSLog(@"connection timeout");
//    }];
}

@end
