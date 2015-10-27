//
//  ViewController.h
//  ChatClient
//
//  Created by renzym on 10/26/15.
//  Copyright © 2015 renzym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSStreamDelegate> {
NSInputStream *inputStream;
NSOutputStream *outputStream;
}
@property (weak, nonatomic) IBOutlet UITextField *inputNameField;
- (IBAction)joinChat:(UIButton *)sender;

@end

