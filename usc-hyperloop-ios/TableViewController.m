//
//  TableViewController.m
//  usc-hyperloop-ios
//
//  Created by Erik Strottmann on 10/14/15.
//  Copyright © 2015 USC Hyperloop. All rights reserved.
//

#import "TableViewController.h"
#import "socket.IO/SocketIO.h"
#import "socket.IO/SocketIOPacket.h"

@interface TableViewController () <SocketIODelegate>

@property (nonatomic, strong) SocketIO *socket;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    self.socket = [[SocketIO alloc] initWithDelegate:self];
    
    [self.socket connectToHost:@"localhost" onPort:1337];
    // connectToHost:onPort:
    
    NSDictionary *reqData = @{ @"url": @"/data" };
    
    [self.socket sendEvent:@"get" withData:reqData andAcknowledge:^(id resData) {
        
        if ([resData isKindOfClass:[NSString class]]) {
            NSString *resString = (NSString *)resData;
            
            NSData *data = [resString dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *fullDataArray = [self parseJSON:data];
            
            for (NSDictionary *dict in fullDataArray) {
                // add to dataArray
                NSString *valString = dict[@"val"];
                
                [self.dataArray addObject:valString];
            }
            
            [self.tableView reloadData];
            
            NSIndexPath* ipath = [NSIndexPath indexPathForRow:[self.dataArray count]-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
        } else {
            NSLog(@"Data wasn't a string! %@", resData);
        }
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Parse JSON

- (id)parseJSON:(NSData *)data {
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error) {
        NSLog(@"Error parsing JSON: %@", [error localizedDescription]);
        return nil;
    }
    
    return object;
}

#pragma mark - SocketIO delegate

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet {
    NSData *data = [[packet data] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *parsedJSON = [self parseJSON:data];
    
    NSString *niceValString = parsedJSON[@"args"][0][@"data"][@"val"];
    [self.dataArray addObject:niceValString];

    [self.tableView reloadData];
    
    NSIndexPath* ipath = [NSIndexPath indexPathForRow:[self.dataArray count]-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dataCellReuseIdentifier" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dataCellReuseIdentifier"];
    }
    
    [[cell textLabel] setText:self.dataArray[[indexPath row]]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
