//
//  ViewController.m
//  usc-hyperloop-ios
//
//  Created by Erik Strottmann on 10/11/15.
//  Copyright © 2015 USC Hyperloop. All rights reserved.
//

#import "ViewController.h"
//#import <Socket_IO_Client_Swift/Socket_IO_Client_Swift-Swift.h>
#import "socket.IO/SocketIO.h"

@interface ViewController () <SocketIODelegate>

//@property (nonatomic, strong) SocketIOClient *socket;
@property (nonatomic, strong) SocketIO *socket;
@property (nonatomic, weak) IBOutlet UIButton *connectButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.socket = [[SocketIO alloc] initWithDelegate:self];
    
    /*
    // Socket.IO-Swift
    
    self.socket = [[SocketIOClient alloc] initWithSocketURL:@"localhost:1337" opts:nil];
    
    [self.socket onAny:^(SocketAnyEvent *data) {
        NSLog(@"Received socket event!!!");
    }];
     */
    
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
    
    NSDictionary *reqData = @{ @"url": @"/data" /*, @"data": @12*/ };
    
    [self.socket sendEvent:@"get" withData:reqData andAcknowledge:^(id resData) {
        NSLog(@"received ack data: %@", resData);
    }];
    
    /*
    [self.socket emitWithAck:@"get" withItems:@[reqData]](0, ^(NSArray* resData) {
        NSLog(@"got ack with data: %@", resData);
    });
     */
}

- (IBAction)toggleConnection:(id)sender {
    NSLog(@"Button: connect");
    
    [self.socket connectToHost:@"localhost" onPort:1337];
    
    /*
    //handshake
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:1337/"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    //converts response to string (index.html)
    NSString* stringFromData = [[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding];
    NSLog(@"data converted to string ==> string = %@", stringFromData);
    
    [self.socket connect];
//    [self.socket connectWithTimeoutAfter:10 withTimeoutHandler:^{
//        NSLog(@"connection timeout");
//    }];
     */
}

@end
