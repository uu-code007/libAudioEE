//
//  MMAudioUnitManager.h
//  RecordAndPlay
//
//  Created by TopMM on 2022/11/24.
//  Copyright © 2022年 TopMM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>


typedef void(^audioCallBack)(AudioBufferList *ioData);

@interface MMAudioUnitManager : NSObject

+ (instancetype)sharedInstance;

-(void)setAudioUnitCallBack:(audioCallBack)callBack;

- (void)startRecord; //开始录音
- (void)stopRecord;  //结束录音
- (void)startPlay;   //开始放音
- (void)stopPlay;    //结束放音

- (void)startRecordAndPlay;  //开始通话
- (void)stopRecordAndPlay;   //结束通话

@end
