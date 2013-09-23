//
//  XViewController.h
//  MyFirstApp
//
//  Created by mac on 8/16/13.
//  Copyright (c) 2013 landyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <netinet/in.h>//sockaddr_in
int m_fd;
NSString * host;
NSString * port;
struct sockaddr_in socketParameters;
@interface XViewController : UIViewController
{
    
    
    
    //GCDAsyncSocket *socket;
}
@property (retain, nonatomic) IBOutlet UILabel *_lblInfo;
- (IBAction)ipAddBackgroundTap:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *txtIpAddr;
@property (retain, nonatomic) IBOutlet UITextField *txtIpPort;
- (IBAction)pressButton:(UIButton *)sender;
- (IBAction)playOrStop:(UISwitch *)sender;
- (IBAction)lightValue:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lblLightValue;

@end
