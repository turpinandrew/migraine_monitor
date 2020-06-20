//
//  NSData+ReadPartialFIle.h
//  psypad
//  From
//    https://stackoverflow.com/questions/1415967/read-only-a-portion-of-a-file-from-disk-in-objective-c
//
//  Created by Andrew Turpin on 20/6/20.
//  Copyright © 2020 unimelb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData(DataWithContentsOfFileAtOffsetWithSize)
+ (NSData *) dataWithContentsOfFile:(NSString *)path atOffset:(off_t)offset withSize:(size_t)bytes;
@end

@implementation NSData(DataWithContentsOfFileAtOffsetWithSize)

+ (NSData *) dataWithContentsOfFile:(NSString *)path atOffset:(off_t)offset withSize:(size_t)bytes
{
  FILE *file = fopen([path UTF8String], "rb");
  if(file == NULL)
        return nil;

  void *data = malloc(bytes);  // check for NULL!
  fseeko(file, offset, SEEK_SET);
  if (fread(data, 1, bytes, file) != bytes) {  // check return value, in case read was short!
      NSLog(@"PANIC - didn't fread enough");
      return nil;
  }
  fclose(file);

  //for (int i=0;i<8;i++) //AHT
  //    NSLog(@"%d %d",i, ((int *)data)[i]);
  // NSData takes ownership and will call free(data) when it's released
  return [NSData dataWithBytesNoCopy:data length:bytes];
}

@end

NS_ASSUME_NONNULL_END
