//
//  ViewController.m
//  ChatClient
//
//  Created by renzym on 10/26/15.
//  Copyright © 2015 renzym. All rights reserved.
//

#import "ViewController.h"
#import "ChatViewViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initNetworkCommunication];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)joinChat:(UIButton *)sender {
    NSString *response = [NSString stringWithFormat:@"iam:%@", _inputNameField.text];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    [self performSegueWithIdentifier:@"goToChatViewController" sender:nil];
    //[self.view bringSubviewToFront:self.chatView];
}

-(void) initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"localhost", 80, &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"goToChatViewController"]) {
        ChatViewViewController *cvc = [segue destinationViewController];
        cvc.inputStream = inputStream;
        cvc.outputStream = outputStream;
    }
}
@end
