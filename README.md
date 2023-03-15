**libAudioEE** 是不错的流媒体变音解决方案 SDK，基于开源 SOX,SoundTouch 算法。特点：轻量级，极速，简用。目前支持 iOS && andriod 平台

主要包含功能

1. 调优了多款变声效果，如大叔，萝莉，磁性，清晰.....
2. 实现十段均衡效果器
3. 实现音调调节，变调不变速
4. 实现房间混响效果器

#### 一. 接入使用过

##### 1. 初始化

```
mm_handle_t effectHandle;
audioEngine_effect_create_handle(&effectHandle, 1, 44100);
```

##### 2. 设置音频效果

```
// 大叔
audioEngine_set_effects_type(effectHandle, MMAudioEffectsTypeUncle);
```

#####  3.  音频处理

```
mm_audioDatarInfo_t aa = {(short *)bytes,length};
audioEngine_processBuffer(effectHandle, &aa);
```

##### 4. 销毁

```
audioEngine_delete(effectHandle);
effectHandle = NULL;
```

##### 5. 自定义效果

```
audioEngine_set_custom_effects(effectHandle, MMAudioEffectsTypeReverb, &mReverbInfo);
```

#### 二. DEMO (演示录制边播放，戴耳机，可防啸叫)

Xcode 打开 SMAudioEffects.xcodeproj

#### 三.  历史更新

##### 2023.3.13

发布 iOS demo 和 SDK







