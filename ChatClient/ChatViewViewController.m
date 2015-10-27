//
//  ChatViewViewController.m
//  ChatClient
//
//  Created by renzym on 10/26/15.
//  Copyright © 2015 renzym. All rights reserved.
//

#import "ChatViewViewController.h"

@interface ChatViewViewController ()

@end

@implementation ChatViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_inputStream setDelegate:self];
    [_outputStream setDelegate:self];
    messages = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMessage:(UIButton *)sender {
    NSString *response  = [NSString stringWithFormat:@"msg:%@", _inputMessageField.text];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [_outputStream write:[data bytes] maxLength:[data length]];
    _inputMessageField.text = @""; // clean the field
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
            
        case NSStreamEventHasBytesAvailable:
            if (theStream == _inputStream) {
                
                uint8_t buffer[2048];
                int len;
                
                while ([_inputStream hasBytesAvailable]) {
                    len = (int)[_inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        output = [[output componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
                        if (nil != output) {
                            NSLog(@"server said: %@", output);
                            [self messageReceived:output];
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
            
        case NSStreamEventEndEncountered:
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            break;
            
        default:
            NSLog(@"Unknown event");
    }
    
}

- (void) messageReceived:(NSString *)message {
    
    [messages addObject:message];
    [self.tView reloadData];
    
    NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
    [self.tView scrollToRowAtIndexPath:topIndexPath
                      atScrollPosition:UITableViewScrollPositionMiddle
                              animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ChatCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *s = (NSString *) [messages objectAtIndex:indexPath.row];
    cell.textLabel.text = s;
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return messages.count;;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
