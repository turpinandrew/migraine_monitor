//
//  YHSocket.m
//  psypad
//
//  Created by LiuYuHan on 12/7/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import "YHSocket.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>


@implementation YHSocket

@synthesize clientSocket,result;
@synthesize ipAdress,port;
@synthesize receiveData;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _finishFlag = 0;
    }
    return self;
}

- (instancetype)initWithIP:(NSString *)ipText andPortNo:(int)portNo{
    if (self = [super init]) {
        _finishFlag = 0;
        ipAdress = ipText;
        port = portNo;
    }
    return self;
}

-(NSString *) receiveStringWithMessage: (NSString *)message{
    if ([self connectWithIP:ipAdress andPort:port]) {
        [self sendMessage:message];
        while (_finishFlag == 0) {}
        _finishFlag = 0;
        //NSLog(@"%@",receiveData);
        return [[NSString alloc]initWithData:receiveData encoding:NSUTF8StringEncoding];
    }else{
        return @"Connection failed.";
    }
}

-(NSData *) receiveDataWithMessage: (NSString *)message{
    if ([self connectWithIP:ipAdress andPort:port]) {
        [self sendMessage:message];
        while (_finishFlag == 0) {}
        _finishFlag = 0;
        //NSLog(@"%@",receiveData);
        return receiveData;
    }else{
        return [@"Connection failed." dataUsingEncoding:NSUTF8StringEncoding];;
    }
}


- (BOOL)connectWithIP:(NSString *)hostText andPort:(int)port {
    //NSLog(@"%@,%d",hostText,port);
    clientSocket = - 1;
    clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (clientSocket <= 0){
        NSLog(@"Connection failed.");
        return NO;
    }
    //Connect
    struct sockaddr_in serverAddress;
    serverAddress.sin_family = AF_INET;
    serverAddress.sin_addr.s_addr = inet_addr(ipAdress.UTF8String);
    serverAddress.sin_port = htons(port);
    result = connect(clientSocket, (const struct sockaddr *)&serverAddress, sizeof(serverAddress));
    if (clientSocket > 0 && result >= 0) {
        return YES;
    }else {
        NSLog(@"Connection failed.");
        [self disConnection];
        return NO;
    }
}

- (BOOL)checkConnection{
    return [self connectWithIP:ipAdress andPort:port];
}


- (void)disConnection {
    if (clientSocket > 0) {
        close(clientSocket);
        clientSocket = -1;
    }
}


- (void)sendMessage: (NSString *)message{
    if (clientSocket > 0 && result >= 0) {
        sigset_t set;
        sigemptyset(&set);
        sigaddset(&set, SIGPIPE);
        sigprocmask(SIG_BLOCK, &set, NULL);
        ssize_t sendLen = send(clientSocket, message.UTF8String, strlen(message.UTF8String), 0);
        //NSLog(@"Sent: %ld", sendLen);
        if (sendLen > 0) {
            [self receiveDataFromServer];
        }
    }
}


- (void)receiveDataFromServer {
    _finishFlag = 0;
    char readBuffer[1460] = {0};
    receiveData = [[NSMutableData alloc]init];
    
    long OrgBr = recv(clientSocket, readBuffer, sizeof(readBuffer), 0);
    while (OrgBr > 0) {
        [receiveData appendBytes:readBuffer length:OrgBr];
        OrgBr = recv(clientSocket, readBuffer, sizeof(readBuffer), 0);
    }
    _finishFlag = 1;
    [self disConnection];
}

@end
