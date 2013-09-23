//
//  XAppDelegate.m
//  MyFirstApp
//
//  Created by mac on 8/16/13.
//  Copyright (c) 2013 landyu. All rights reserved.
//

#import "XAppDelegate.h"

#import "XViewController.h"
#import "XSocketTest.h"

#import <sys/socket.h>
#import <netinet/in.h>//sockaddr_in
#import <arpa/inet.h>//inet_addr()
#import <sys/ioctl.h>

@implementation XAppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[XViewController alloc] initWithNibName:@"XViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"%@", NSStringFromSelector(_cmd));
    if (-1 != m_fd)
    {
        //NSLog(@"22222222222");
        close(m_fd);
        m_fd = -1;
        //connSucc = NO;
        self.viewController._lblInfo.text = @"OFF LINE";
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"%@", NSStringFromSelector(_cmd));
    if (-1 == m_fd)
    {
        m_fd = socket(AF_INET, SOCK_STREAM, 0);
        if (-1 == m_fd) {
            NSLog(@"Failed to create socket.");
            return ;
        }
        
        //struct sockaddr_in socketParameters;
        //socketParameters.sin_family = AF_INET;
        //socketParameters.sin_addr.s_addr = inet_addr([host UTF8String]);
        //socketParameters.sin_port = htons([port intValue]);
        //int flags = fcntl(m_fd, F_GETFL, 0);
        struct timeval  connTimeout;
        connTimeout.tv_sec = 15;
        connTimeout.tv_usec = 0;
        int ret = [XSocketTest myConnect:&m_fd pSocketAddr:(const struct sockaddr *)&socketParameters socketLen:sizeof(socketParameters) blockFlag:NO timeOut:&connTimeout];
        
        if (-1 == ret)
        {
            //NSLog(@"connect dailed !!!!!");
            self.viewController._lblInfo.text = @"OFF LINE";
            close(m_fd);
            m_fd = -1;
            return;
        }
        else if(0 == ret)
        {
            self.viewController._lblInfo.text = @"ON LINE";
        }

        
        

    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
