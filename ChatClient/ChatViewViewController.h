//
//  ChatViewViewController.h
//  ChatClient
//
//  Created by renzym on 10/26/15.
//  Copyright © 2015 renzym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewViewController : UIViewController  <NSStreamDelegate, UITableViewDelegate, UITableViewDataSource> {
NSMutableArray * messages;
}

@property (weak, nonatomic) NSInputStream *inputStream;
@property (weak, nonatomic) NSOutputStream *outputStream;

@property (weak, nonatomic) IBOutlet UITextField *inputMessageField;
@property (weak, nonatomic) IBOutlet UITableView *tView;
- (IBAction)sendMessage:(UIButton *)sender;

@end
