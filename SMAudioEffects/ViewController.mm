//
//  ViewController.m
//  audioEG
//
//  Created by 孙慕 on 2021/12/27.
//

#import "ViewController.h"
#import "MMAudioUnitManager.h"
//#import <effectsEngine/mm_audio_effect.hpp>
#import "mm_audio_effect.hpp"
#import <AVFoundation/AVFoundation.h>

@interface ViewController (){
 
    mm_handle_t effectHandle;
    mm_audioReverbInfo_t mReverbInfo;
    
    mm_audioEqualizerInfo_t mEqualizerInfo;
}

@property (strong, nonatomic) IBOutlet UIView *reverbView;
@property (weak, nonatomic) IBOutlet UIView *equalizationView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eqViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *revViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pitchViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeViewBottom;
@property (weak, nonatomic) IBOutlet UISlider *picthSlider;

@property (weak, nonatomic) IBOutlet UISegmentedControl *audioToneChangeControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *audioBeautifyControl;

@property (weak, nonatomic) IBOutlet UISegmentedControl *audioGenreControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *audioSpaceControl;


@property (nonatomic, strong) CALayer *outputLevelLayer;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    //初始化
    [self initEffectAudio];
    
    self.outputLevelLayer = [CALayer layer];
    _outputLevelLayer.backgroundColor = [[UIColor colorWithWhite:0.0 alpha:0.3] CGColor];
    _outputLevelLayer.frame = CGRectMake(0, 90, 0, 10);
    [self.view.layer addSublayer:_outputLevelLayer];
    
    [[MMAudioUnitManager sharedInstance] setAudioUnitCallBack:^(AudioBufferList *ioData) {
        // 特效处理
        int length = ioData->mBuffers[0].mDataByteSize;
        int16_t *bytes = (int16_t *) ioData->mBuffers[0].mData;

        if (self->effectHandle) {
            mm_audioDatarInfo_t aa = {(short *)bytes,length};
            audioEngine_processBuffer(self->effectHandle, &aa);
        }
    }];
    [[MMAudioUnitManager sharedInstance] startRecordAndPlay];
}

-(void)initEffectAudio{
    audioEngine_effect_create_handle(&effectHandle, 1, 44100);
    
    mReverbInfo = {.reverbrance = 50,.hfDamping = 50,.roomScale = 50,.preDelay = 100,.wetGain = 0 };
}


-(void)viewWillAppear:(BOOL)animated{
    _picthSlider.value = 1.0 * 2;
    //default value
    for (UIView *subView in self.reverbView.subviews) {
        if ([subView isKindOfClass:[UISlider class]]) {
            UISlider *sender = (UISlider *)subView;
            switch (subView.tag) {
                case 101:
                    sender.value = 50;
                    break;
                case 102:
                    sender.value = 50;
                    break;
                case 103:
                    sender.value = 50;
                    break;
                case 104:
                    sender.value = 50;
                    break;
                case 105:
                    sender.value = 100;
                    break;
                case 106:
                    sender.value = 0;
                    break;
                default:
                    break;
            }
        }
    }
}



-(void)didOutputAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer{
//    [[MMAudioManager defaultInstance] processAudioBuffer2:sampleBuffer];
    
    if(sampleBuffer==NULL) {
    } else {
        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
        // Number of samples in the buffer
        CMItemCount countsamp= CMSampleBufferGetNumSamples(sampleBuffer);
                
        CMBlockBufferRef blockBuffer;
        AudioBufferList audioBufferList;
        //allocates new buffer memory
        CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(sampleBuffer, NULL, &audioBufferList, sizeof(audioBufferList),NULL, NULL, 0, &blockBuffer);
        
        int length = audioBufferList.mBuffers[0].mDataByteSize;
        int16_t *bytes = (int16_t *) audioBufferList.mBuffers[0].mData;
        
        if (effectHandle) {
            
//            mProcessor->process((short *)bytes, length, nil, 0, 0, length/2);
            
            CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

            mm_audioDatarInfo_t aa = {(short *)bytes,length};
            audioEngine_processBuffer(effectHandle, &aa);
            
            CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
            
//            NSLog(@"耗时---%lf",endTime * 1000);
            NSData *data = [NSData dataWithBytes:aa.vocalBuffer length:aa.vocalByteSize];
        }

        CFRelease(blockBuffer);
        
    }
    
}



- (IBAction)effectTypeChange:(UISegmentedControl *)sender {
    int value = sender.selectedSegmentIndex;
    if (value == 0) {
        audioEngine_set_effects_type(effectHandle, MMAudioTypeOff);
        NSLog(@"关闭效果=========");
        return;
    }
    
    
    if (sender ==  _audioSpaceControl) {
        _audioGenreControl.selectedSegmentIndex = 0;
        _audioBeautifyControl.selectedSegmentIndex = 0;
        _audioToneChangeControl.selectedSegmentIndex = 0;
    }
    
    if (sender ==  _audioBeautifyControl) {
        _audioSpaceControl.selectedSegmentIndex = 0;
        _audioGenreControl.selectedSegmentIndex = 0;
        _audioToneChangeControl.selectedSegmentIndex = 0;
    }
    
    if (sender ==  _audioToneChangeControl) {
        _audioSpaceControl.selectedSegmentIndex = 0;
        _audioBeautifyControl.selectedSegmentIndex = 0;
        _audioGenreControl.selectedSegmentIndex = 0;
    }
    
    if (sender ==  _audioGenreControl) {
        _audioSpaceControl.selectedSegmentIndex = 0;
        _audioBeautifyControl.selectedSegmentIndex = 0;
        _audioToneChangeControl.selectedSegmentIndex = 0;
    }
    
    
    if (sender.tag == 101) {
        mm_audio_effects_type type = mm_audio_effects_type(101+value);
        audioEngine_set_effects_type(effectHandle, type);
    }
    
    if (sender.tag == 201) {
        mm_audio_effects_type type = mm_audio_effects_type(104+value);
        audioEngine_set_effects_type(effectHandle, type);
    }
    if (sender.tag == 301) {
        mm_audio_effects_type type = mm_audio_effects_type(120+value);
        audioEngine_set_effects_type(effectHandle, type);
    }
    if (sender.tag == 401) {
        mm_audio_effects_type type = mm_audio_effects_type(139+value);
        audioEngine_set_effects_type(effectHandle, type);
    }
    
}




- (IBAction)reverbSliderValueChanged:(UISlider *)sender {
    NSInteger tag = sender.tag;
    NSLog(@"view tag (%d),value (%f)",sender.tag,sender.value);
    switch (tag) {
        case 101:
            mReverbInfo.reverbrance = (int)sender.value;
            break;
        case 102:
            mReverbInfo.hfDamping = (int)sender.value;
            break;
        case 103:
            mReverbInfo.roomScale = (int)sender.value;
            break;
        case 104:
//            mReverbInfo.stereoDepth = (int)sender.value;
            break;
        case 105:
            mReverbInfo.preDelay = (int)sender.value;
            break;
        case 106:
            mReverbInfo.wetGain = (int)sender.value;
            break;
        default:
            break;
    }
    audioEngine_set_custom_effects(effectHandle, MMAudioEffectsTypeReverb, &mReverbInfo);
     
}
- (IBAction)eqValueChanged:(UISlider *)sender {
    NSInteger tag = sender.tag;
    switch (tag) {
        case 101:
            mEqualizerInfo.AudioEqualizationGainBand31 = (int)sender.value;
            break;
        case 102:
            mEqualizerInfo.AudioEqualizationGainBand62 = (int)sender.value;
            break;
        case 103:
            mEqualizerInfo.AudioEqualizationGainBand125 = (int)sender.value;
            break;
        case 104:
            mEqualizerInfo.AudioEqualizationGainBand250 = (int)sender.value;
            break;
        case 105:
            mEqualizerInfo.AudioEqualizationGainBand500 = (int)sender.value;
            break;
        case 106:
            mEqualizerInfo.AudioEqualizationGainBand1K = (int)sender.value;
            break;
        case 107:
            mEqualizerInfo.AudioEqualizationGainBand2K = (int)sender.value;
            break;
        case 108:
            mEqualizerInfo.AudioEqualizationGainBand4K = (int)sender.value;
            break;
        case 109:
            mEqualizerInfo.AudioEqualizationGainBand8K = (int)sender.value;
            break;
        case 110:
            mEqualizerInfo.AudioEqualizationGainBand16K = (int)sender.value;
            break;
        default:
            break;
    }
    audioEngine_set_custom_effects(effectHandle, MMAudioEffectsTypeEqualizer, &mEqualizerInfo);
    
}
- (IBAction)pitchValueChanged:(UISlider *)sender {
    
    float value = sender.value/2;//0.5~2
    audioEngine_set_custom_effects(effectHandle, MMAudioEffectsTypePitch, &value);
    
}

- (IBAction)effectTypeViewChange:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        _eqViewBottom.constant = -465;
        _revViewBottom.constant = 44;
        _pitchViewBottom.constant = -50;
        _typeViewBottom.constant = -172;
    }
    if (sender.selectedSegmentIndex == 1) {
        _eqViewBottom.constant = 44;
        _revViewBottom.constant = -300;
        _pitchViewBottom.constant = -50;
        _typeViewBottom.constant = -172;
    }
    if (sender.selectedSegmentIndex == 2) {
        _eqViewBottom.constant = -465;
        _revViewBottom.constant = -300;
        _pitchViewBottom.constant = 44;
        _typeViewBottom.constant = -172;
    }
    
    if (sender.selectedSegmentIndex == 3) {
        _eqViewBottom.constant = -465;
        _revViewBottom.constant = -300;
        _pitchViewBottom.constant = -50;
        _typeViewBottom.constant = 44;
    }
    [self.view layoutIfNeeded];
    
}


-(void)writeData:(char *)inputDate size:(int)size pathName:(NSString *)name{
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *path = [documentsDir stringByAppendingPathComponent:name];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExit = [fileManager fileExistsAtPath:path];
    //文件夹是否存在
    if (!isExit) {
        NSLog(@"log文件不存在");
        [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    NSError *error;
    NSMutableData *content = [NSMutableData dataWithContentsOfFile:path];
    
    [content appendBytes:inputDate length:size];
    BOOL res = [content writeToFile:path atomically:YES];
    if (res) {
        NSLog(@"INFO写入成功--%d",size);
    }else {
        NSLog(@"INFO写入失败");
        
    }
}



@end
