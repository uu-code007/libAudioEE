//
//  mm_audio_effect.hpp
//  effectsEngine
//
//  Created by 孙慕 on 2022/1/26.
//

#ifndef mm_audio_effect_hpp
#define mm_audio_effect_hpp


#include <stdio.h>
#include "mm_effect_common.hpp"


enum mm_audio_effects_type {
    MMAudioTypeOff       = 0x65,
    
    // 变调
    MMAudioEffectsTypeUncle     = 0x66 ,//大叔
    MMAudioEffectsTypeLaurie    = 0x67 ,// 萝莉(女)
    MMAudioEffectsTypeHulk      = 0x68 , // 绿巨人

    // 美化
    MMAudioBeautifierTypeMagnetic = 0x69, //磁性（男）
    MMAudioBeautifierTypeFresh = 0x6A, //清新（女）
    MMAudioBeautifierTypeVigorous = 0x6B, //浑厚
//    MMAudioBeautifierTypeClear = 108, //清澈
//    MMAudioBeautifierTypeFalsetto = 109, //假音
    
    // 歌曲曲风
    MMAudioTransformationPopular = 0x78,//流行
    MMAudioTransformationRnB = 0x79, //R&B
    MMAudioTransformationRock = 0x7A, //摇滚
    MMAudioTransformationRap = 0x7B,//说唱
    
    // 空间塑造
    MMAudioRoomAcousticsKTV = 0x8C, //KTV
    MMAudioRoomAcousticsStudio = 0x8D,//留声机
    MMAudioRoomAcousticsPhonograph = 0x8E,//录音棚
    MMAudioRoomAcousticsClassroom = 0x8F,//教室
    
    // 200+ 为自定义设置，会使设置类型失效
    MMAudioEffectsTypeReverb    = 0xC9,
    MMAudioEffectsTypeEqualizer    = 0xCA,
    MMAudioEffectsTypeCompressor    = 0xCB,
    MMAudioEffectsTypePitch    = 0xCC
};

typedef struct mm_audioDatarInfo_t {
    short *vocalBuffer;
    int vocalByteSize; // byteSize: vocalBuffer.lenth * sizeof(short)
} mm_audioDatarInfo_t;

// 混响
// 混响音效重要的时配置参数 需要懂乐理进行参数调节，可调节出KTV，温暖，磁性，空灵，悠远，3D迷幻，等音
typedef struct mm_audioReverbInfo_t {
    int        reverbrance;//混响大小，
    int        hfDamping; //高频阻
    int        roomScale; //房间大小
    int         stereoDepth; //立体声深度，早反射声，及湿声增益
    int         preDelay;//早反射声
    int         wetGain;//湿声增益
} mm_audioReverbInfo_t;

// 十段均衡器增益设置
// 通过对各种不同频率的调节来修改音色
typedef struct mm_audioEqualizerInfo_t {
    /** 31 Hz. */
    int AudioEqualizationGainBand31;
    /** 62 Hz. */
    int AudioEqualizationGainBand62;
    /** 125 Hz. */
    int AudioEqualizationGainBand125;
    /** 250 Hz. */
    int AudioEqualizationGainBand250;
    /** 500 Hz */
    int AudioEqualizationGainBand500;
    /** 1 kHz. */
    int AudioEqualizationGainBand1K;
    /** 2 kHz. */
    int AudioEqualizationGainBand2K;
    /** 4 kHz. */
    int AudioEqualizationGainBand4K;
    /** 8 kHz. */
    int AudioEqualizationGainBand8K;
    /** 16 kHz. */
    int AudioEqualizationGainBand16K;

} mm_audioEqualizerInfo_t;

// 压缩器
typedef struct mm_audioCompressorInfo_t {
    float        attackTime;//上升时间
    float        decayTime; //衰退时间
    int        threshold; //阈值
    float         ratio; //比率
    int         expansion_threshold;
    float         expansion_ratio;
    int         gain;
} mm_audioCompressorInfo_t;


/**
Client API:
Initialize effects library.
@returns QN_OK if successful.
*/

QN_SDK_API mm_result_t
audioEngine_effect_create_handle(mm_handle_t* p_handle,int channels, int audioSampleRate);

/**
Client API:
Close effects library
@returns QN_OK if successful.
*/
QN_SDK_API mm_result_t
audioEngine_delete(mm_handle_t p_handle);

/**
设置美化预制类型
*/
QN_SDK_API mm_result_t
audioEngine_set_effects_type(mm_handle_t p_handle,enum mm_audio_effects_type type);

/**
自定义效果器参数设置，支持的设置包含 压缩器，均衡器，变调不变速，混响器
 
*/
QN_SDK_API mm_result_t
audioEngine_set_custom_effects(mm_handle_t p_handle,enum mm_audio_effects_type type,void* value);

/**
Client API:
数据处理函数，回写到输入内存
 vocalBuffer：数据缓存地址
 vocalBufferSize：待处理数据长度
@returns QN_OK if successful.
*/
QN_SDK_API mm_result_t
audioEngine_processBuffer(mm_handle_t p_handle,mm_audioDatarInfo_t *audioData);


#endif /* mm_audio_effect_hpp */
