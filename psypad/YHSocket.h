//
//  YHSocket.h
//  psypad
//
//  Created by LiuYuHan on 12/7/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHSocket : NSObject

- (instancetype)init;
- (instancetype)initWithIP:(NSString *)ipText andPortNo:(int)portNo;
-(NSString *) receiveStringWithMessage: (NSString *)message;
-(NSData *) receiveDataWithMessage: (NSString *)message;
- (BOOL)checkConnection;

@property (nonatomic, copy) NSString *ipAdress;
@property (nonatomic, assign) UInt16 port;

@property (nonatomic,assign) int clientSocket;
@property (nonatomic,assign) int result;

@property (nonatomic, assign) int finishFlag;

@property (nonatomic, strong) NSMutableData *receiveData;

@end
