//
//  XViewController.m
//  MyFirstApp
//
//  Created by mac on 8/16/13.
//  Copyright (c) 2013 landyu. All rights reserved.
//

#import "XViewController.h"
#import "XSocketTest.h"
//#import <sys/socket.h>
//#import <netinet/in.h>//sockaddr_in
//#import <arpa/inet.h>//inet_addr()
//#import <unistd.h>
//#import <sys/ioctl.h>

@interface XViewController ()

@end

@implementation XViewController
@synthesize lblLightValue;
//@synthesize socket;
@synthesize txtIpAddr;
@synthesize txtIpPort;
@synthesize _lblInfo;


NSString *ghost ;
NSString *gport;
//@synthesize host;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //[UIApplication sharedApplication].statusBarHidden = NO;
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(applicationDidEnterBackground)
//                                                 name:UIApplicationDidEnterBackgroundNotification
//                                               object:[UIApplication sharedApplication]];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(applicationWillEnterForeground)
//                                                 name:UIApplicationWillEnterForegroundNotification
//                                               object:[UIApplication sharedApplication]];
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
	// Do any additional setup after loading the view, typically from a nib.
    _lblInfo.text = @"OFF LINE";
    lblLightValue.text = @"0";
    
    txtIpAddr.text = @"192.168.18.207";
    txtIpPort.text = @"54321";
    
    host = txtIpAddr.text;
    port = txtIpPort.text;
    
    txtIpAddr.keyboardType = UIKeyboardTypeDecimalPad;
    txtIpPort.keyboardType = UIKeyboardTypeDecimalPad;
    m_fd = -1;
    //connSucc = NO;
    //ghost = [[[NSString alloc] initWithString:@"192.168.18.10"] autorelease];
    //gport = [[[NSString alloc] initWithString:@"80"] autorelease];
    //_lblInfo.textColor = [UIColor greenColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_lblInfo release];
    [lblLightValue release];
    [txtIpAddr release];
    [txtIpPort release];
    [super dealloc];
}
- (IBAction)pressButton:(UIButton *)sender
{
   
    NSString *title = [sender titleForState:UIControlStateNormal];
    
    
    if ([title isEqualToString:@"Connect"])
    {
        if (-1 != m_fd) {
            return;
        }
            host = txtIpAddr.text;
            port = txtIpPort.text;
         _lblInfo.text = @"Connecting.....";
        NSLog(@"IP Addr : %@:%@", host, port);
        m_fd = socket(AF_INET, SOCK_STREAM, 0);
        if (-1 == m_fd) {
            NSLog(@"Failed to create socket.");
            return ;
        }
        
        
        socketParameters.sin_family = AF_INET;
        socketParameters.sin_addr.s_addr = inet_addr([host UTF8String]);
        socketParameters.sin_port = htons([port intValue]);
        
        //设置非阻塞
        //unsigned long noblock = 1;
        //int retVar = ioctl(m_fd,FIONBIO,&noblock);
//        int flags = fcntl(m_fd, F_GETFL, 0);
//        
//        if (flags < 0) {
//            perror("get socket flags fail.\n");
//            close(m_fd);
//            return;
//        }
//        
//        if (fcntl(m_fd, F_SETFL, flags | O_NONBLOCK) < 0) {
//            perror("set socket O_NONBLOCK fail.\n");
//            close(m_fd);
//            return;
//        }

        struct timeval  connTimeout;
        connTimeout.tv_sec = 5;
        connTimeout.tv_usec = 0;
        int ret = [XSocketTest myConnect:&m_fd pSocketAddr:(const struct sockaddr *)&socketParameters socketLen:sizeof(socketParameters) blockFlag:NO timeOut:&connTimeout];
        
        if (-1 == ret)
        {
            //NSLog(@"connect dailed !!!!!");
            _lblInfo.text = @"OFF LINE";
            close(m_fd);
            m_fd = -1;
            return;
        }
        else if(0 == ret)
        {
           _lblInfo.text = @"ON LINE";
        }
        //int ret = connect(m_fd, (struct sockaddr *) &socketParameters, sizeof(socketParameters));
//        {
//            NSLog(@"Connect error");
//            _lblInfo.text = @"OFF LINE";
//            close(m_fd);
//            m_fd = -1;
//            return;
//        }
        
//        if (-1 == ret) {
//            //链接失败
//            fd_set set;
//            FD_ZERO(&set);
//            FD_SET(m_fd, &set);
//            
//            struct timeval  connTimeout;
//            connTimeout.tv_sec = 5;
//            connTimeout.tv_usec = 0;
//            
//            ret = select(m_fd+1, NULL, &set, NULL, &connTimeout);
//            FD_ISSET(m_fd, &set);
//            if (ret > 0) {
//                int error = 0;
//                unsigned int sockLen = 4;//SOCKET长度为INT （4）,不能填错，重要！！！
//            getsockopt(m_fd, SOL_SOCKET, SO_ERROR, &error, &sockLen);
//                
//                if (0 == error)
//                {
//                    //ret = connect(m_fd, (struct sockaddr *) &socketParameters, sizeof(socketParameters));
//                    
//                    connSucc = YES;
//                }
//                
//            }
//            else if(ret ==0)
//            {
//                perror("timeout !!!\n");
//            }
//            
//            flags = fcntl(m_fd, F_GETFL,0);
//            flags &= ~O_NONBLOCK;
//            fcntl(m_fd,F_SETFL, flags);
//            
//            if (NO == connSucc) {
//                _lblInfo.text = @"OFF LINE";
//                close(m_fd);
//                m_fd = -1;
//                return;
//            }
//
        
        
        //}
    }
    else if([title isEqualToString:@"Disconnect"])
    {
         _lblInfo.text = @"Disconnecting......";
        if (-1 == m_fd) {
            
            _lblInfo.text = @"OFF LINE";
            return ;
        }
        
        close(m_fd);
        m_fd = -1;
         _lblInfo.text = @"OFF LINE";
        
        
        
    }
//    NSString *s = [[[NSString alloc] initWithFormat:@"you press %@ button", title] autorelease];
//    
//    _lblInfo.text = s;
//    [s release];
}

NSString *son = @"ON";
NSString *soff =@"OFF";
- (IBAction)playOrStop:(UISwitch *)sender {
    
    if (-1 == m_fd)
    {
        return;
    }
    
//    if (NO == connSucc) {
//        return;
//    }
    NSData* rsp_data = [[[NSData alloc] init] autorelease];//
    if (sender.on)
    {
        struct timeval  connTimeout;
        connTimeout.tv_sec = 5;
        connTimeout.tv_usec = 0;
        if (NO == [XSocketTest socketIsWriteable:&m_fd timeOut:&connTimeout])
        {
            NSLog(@"socket can not be written.....");
            close(m_fd);
            m_fd = -1;
            return ;
        }
        NSData* req_data =[[[NSData alloc]initWithData:[@"ON\r\n" dataUsingEncoding:NSUTF8StringEncoding]]autorelease];
        
        
        int ret = send(m_fd, [req_data bytes], [req_data length], 0);
        if (ret < 0)
        {
            NSLog(@"send data error!");
            return;
        }


    }
    else
    {
        struct timeval  connTimeout;
        connTimeout.tv_sec = 5;
        connTimeout.tv_usec = 0;
        if (NO == [XSocketTest socketIsWriteable:&m_fd timeOut:&connTimeout])
        {
            NSLog(@"socket can not be written.....");
            close(m_fd);
            m_fd = -1;
            return ;
        }
         NSData* req_data =[[[NSData alloc]initWithData:[@"OFF\r\n" dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
        int ret = send(m_fd, [req_data bytes], [req_data length], 0);
        if (ret < 0)
        {
            NSLog(@"send data error!");
            return;
        }

    }
    
    //[rsp_data release];
    
    //NSLog(@"rsp_data ->str :%@", [[[NSString alloc]initWithBytes:[rsp_data bytes] length:[rsp_data length] encoding:NSUTF8StringEncoding]autorelease]);
}

- (IBAction)lightValue:(id)sender {
    
    UISlider *slider = (UISlider *)sender;
    int progressAsInt = (int)roundf(slider.value);
    NSString *lV =  [NSString stringWithFormat:@"%d\r\n", progressAsInt];
    lblLightValue.text = lV;
    if (-1 == m_fd)
    {
        return;
    }
    
    struct timeval  connTimeout;
    connTimeout.tv_sec = 5;
    connTimeout.tv_usec = 0;
    if (NO == [XSocketTest socketIsWriteable:&m_fd timeOut:&connTimeout])
    {
        NSLog(@"socket can not be written.....");
        close(m_fd);
        m_fd = -1;
        return ;
    }
    
    
    if (-1 == m_fd)
    {
        return;
    }
    NSData* rsp_data = [[[NSData alloc] init] autorelease];
    NSData* req_data =[[[NSData alloc]initWithData:[lV dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
    int ret = send(m_fd, [req_data bytes], [req_data length], 0);
    if (ret < 0)
    {
        NSLog(@"send data error!");
        return;
    }

    
}



//- (void)socket:(GCDAsyncSocket *)sock willDisconnectWithError:(NSError *)err
//{
//    NSLog(@"onSocket:%p willDisconnectWithError:%@", sock, err);
//}
//- (void)socketDidDisconnect:(GCDAsyncSocket *)sock
//{
//    //断开连接了
//    NSLog(@"onSocketDidDisconnect:%p", sock);
//}






- (IBAction)ipAddBackgroundTap:(id)sender
{
    [txtIpAddr resignFirstResponder];
    [txtIpPort resignFirstResponder];

}



@end













