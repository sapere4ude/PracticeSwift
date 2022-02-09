//
//  AudioRecordGraph.m
//  ExMicDecibel
//
//  Created by Kant on 2021/12/21.
//

#import "AudioRecordGraph.h"
#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import <AVFoundation/AVFoundation.h>
#import "SCSiriWaveformView.h"

// return min value for given values
#define min(a, b) (((a) < (b)) ? (a) : (b))

#define BLOCK_SIZE  16384

#define DBOFFSET -74.0
#define LOWPASSFILTERTIMESLICE .001


@interface AudioRecordGraph ()
{
    BOOL                    _pauseRecording;
    
    ExtAudioFileRef         _recordingFileRef;
    ExtAudioFileRef         _soundFileRef;
    CGFloat                 _effectOffset;
    
    BOOL                    _isPlayingEffect;
    NSString            *   _currentRecordFile;
    
    NSTimer             *   _updateWaveformTimer;
    
    SCSiriWaveformView      __weak     *    _voiceWaveformView;
    SCSiriWaveformView      __weak     *    _effectWaveformView;
    
    id                                      _audioSessionObserver[2];
}

@property   AUGraph                 audioGraph;
@property   AudioUnit               audioOut;
@property   AudioBuffer             audioBuffer;
@property   AudioUnit               audioAdapter;

- (void)processBuffer:(AudioBufferList*)audioBufferList inNumberFrames:(UInt32)inNumberFrames;
@end

@implementation AudioRecordGraph

    - (bool)isRunning
    {
        Boolean isRunning = NO;
        AUGraphIsRunning(_audioGraph, &isRunning);
        return isRunning;
    }

    + (AudioStreamBasicDescription *)CanonicalInterleaved
    {
        static    AudioStreamBasicDescription    format =
        {
            44100,
            kAudioFormatLinearPCM,
            kAudioFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked,
            2 * sizeof(SInt16),
            1,
            2 * sizeof(SInt16),
            2,
            8 * sizeof(SInt16),
        };
        return &format;
    }

    + (AudioStreamBasicDescription *)AudioFormat
    {
        static    AudioStreamBasicDescription    format =
        {
            44100,
            kAudioFormatLinearPCM,
            kAudioFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked,
            1 * sizeof(SInt16),
            1,
            1 * sizeof(SInt16),
            1,
            8 * sizeof(SInt16),
        };
        return &format;
    }

    + (AudioStreamBasicDescription *)AudioFormatAAC
    {
        static    AudioStreamBasicDescription    format =
        {
            44100,
            kAudioFormatMPEG4AAC,
            kMPEG4Object_AAC_Main,
            0,
            1024,
            0,
            2,
            0,
        };
        return &format;
    }

    static OSStatus recordingCallback(void *inRefCon,
                                      AudioUnitRenderActionFlags *ioActionFlags,
                                      const AudioTimeStamp *inTimeStamp,
                                      UInt32 inBusNumber,
                                      UInt32 inNumberFrames,
                                      AudioBufferList *ioData)
    {
        AudioRecordGraph * audioGraph = (__bridge AudioRecordGraph*) inRefCon;
        
        AudioBuffer buffer;
        buffer.mDataByteSize = inNumberFrames * 2; // sample size
        buffer.mNumberChannels = 1;
        buffer.mData = malloc( inNumberFrames * 2 ); // buffer size
        
        AudioBufferList bufferList;
        bufferList.mNumberBuffers = 1;
        bufferList.mBuffers[0] = buffer;
        
        OSStatus status = AudioUnitRender([audioGraph audioOut], ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, &bufferList);
        if(status == noErr)
        {
            [audioGraph setUpdateDecibels:[audioGraph findPeakValue:(SInt16 *)bufferList.mBuffers[0].mData frame:inNumberFrames] view:audioGraph->_voiceWaveformView];
            [audioGraph processBuffer:&bufferList inNumberFrames:inNumberFrames];
            free(bufferList.mBuffers[0].mData);
            return noErr;
        }
        return status;
    }

    #pragma mark playback callback
    static OSStatus playbackCallback (void                          *   inRefCon,
                                      AudioUnitRenderActionFlags    *   ioActionFlags,
                                      const AudioTimeStamp          *   inTimeStamp,
                                      UInt32                            inBusNumber,
                                      UInt32                            inNumberFrames,
                                      AudioBufferList               *    ioData)
    {
        AudioRecordGraph * audioGraph = (__bridge AudioRecordGraph*) inRefCon;
        
        for (int i=0; i < ioData->mNumberBuffers; i++)
        {
            AudioBuffer buffer = ioData->mBuffers[i];
            memset(buffer.mData, 0, buffer.mDataByteSize);
            
            UInt32 mDataByteSize = [audioGraph audioBuffer].mDataByteSize;
            if(mDataByteSize > buffer.mDataByteSize)
                mDataByteSize = buffer.mDataByteSize;
            memcpy(buffer.mData, [audioGraph audioBuffer].mData, mDataByteSize);
        }
        
        return noErr;
    }

    #pragma mark - Implement audio key capture

    - (bool)startAudioGraph
    {
        if([self createSaveFile] == noErr)
        {
            [self start];
            [self startRunLoop];
        }
        
        return self.isRunning;
    }
    - (OSStatus)start
    {
        [AVAudioSession.sharedInstance setPreferredSampleRate:[AudioRecordGraph CanonicalInterleaved]->mSampleRate error:NULL];
        
        if (AUGraphInitialize(_audioGraph) == noErr)
            return AUGraphStart(_audioGraph) == noErr;
        
        return NO;
    }

    - (void)stop
    {
        if(_recordingFileRef)
            ExtAudioFileDispose(_recordingFileRef);
        _recordingFileRef = nil;
        
        if(_soundFileRef)
            ExtAudioFileDispose(_soundFileRef);
        _soundFileRef = nil;
        
        [self stopRunLoop];
        [self pauseRecording:NO];

        AUGraphStop(_audioGraph);
        AUGraphUninitialize(_audioGraph);
    }

    - (OSStatus)resume
    {
        NSError                                * error;
        const AudioStreamBasicDescription    format = *[AudioRecordGraph CanonicalInterleaved];
        
        [AVAudioSession.sharedInstance setPreferredSampleRate:format.mSampleRate error:&error];
        [AVAudioSession.sharedInstance setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:NULL];
        [AVAudioSession.sharedInstance setActive:YES error:&error];
        
        OSStatus status = AUGraphInitialize(_audioGraph);
        if (status == noErr)
        {
            return AUGraphStart(_audioGraph);
        }
        
        return    status;
    }


    - (void)activatePlayback
    {
        [AVAudioSession.sharedInstance setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:NULL];
        [AVAudioSession.sharedInstance setActive:YES error:NULL];
    }

    - (void)dealloc
    {
        [NSNotificationCenter.defaultCenter removeObserver:_audioSessionObserver[0]];
        [NSNotificationCenter.defaultCenter removeObserver:_audioSessionObserver[1]];
        
        [self stop];
        free(_audioBuffer.mData);
        DisposeAUGraph(_audioGraph);

        _delegate = nil;
        _voiceWaveformView = nil;
        _effectWaveformView = nil;
    }

    - (void)pauseRecording:(BOOL)pause
    {
        _pauseRecording = pause;
        
        if(_pauseRecording == YES)
        {
            [self setUpdateDecibels:0.0f view:_voiceWaveformView];
            [self setUpdateDecibels:0.0f view:_effectWaveformView];
            [self stopUpdateDecibels:_voiceWaveformView];
            [self stopUpdateDecibels:_effectWaveformView];
        }
    }

    - (void)cancelRecord
    {
        [[NSFileManager defaultManager] removeItemAtPath:_currentRecordFile error:NULL];
    }

/**
 * @Desc
 * AUGraph를 생성한다.
 * Mic 와 Effect의 최대 볼륨은 0.5이다(Mic + Effect = 1.0), 둘의 합이 1.0이 넘을 경우 깨지는 소리가 들린다.
 * kAudioOutputUnitProperty_EnableIO의 kAudioUnitScope_Input과 kAudioUnitScope_Input은 동일하게 설정되어야 하며
 * kAudioUnitScope_Input은 [AudioRecordGraph AudioFormat]으로 구성된다.
 */
    #pragma mark - Object lifecycle
    - (BOOL)createGraph
    {
        if (NewAUGraph(&_audioGraph) == noErr)
        {
            AUNode    output, adapter;
            OSStatus (^addNode)(OSType, OSType, AUNode *) = ^(OSType type, OSType subType, AUNode * node)
            {
                AudioComponentDescription    desc = { type, subType, kAudioUnitManufacturer_Apple, 0, 0 };
                return AUGraphAddNode(_audioGraph, &desc, node);
            };
            
            if (addNode(kAudioUnitType_Output, kAudioUnitSubType_VoiceProcessingIO, &output) == noErr &&
                addNode(kAudioUnitType_FormatConverter, kAudioUnitSubType_AUConverter, &adapter) == noErr)
            {
                if (AUGraphConnectNodeInput(_audioGraph, adapter, 0, output, 0) == noErr)
                {
                    if (AUGraphOpen(_audioGraph) == noErr)
                    {
                        if(AUGraphNodeInfo(_audioGraph, adapter, NULL, &_audioAdapter) == noErr &&
                           AUGraphNodeInfo(_audioGraph, output, NULL, &_audioOut) == noErr)
                        {
                            UInt32 flag = 1;
                            UInt32 maxFPS = 4096;
                            
                            if(AudioUnitSetProperty(_audioAdapter, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, [AudioRecordGraph AudioFormat], sizeof(AudioStreamBasicDescription)) == noErr &&
                               AudioUnitSetProperty(_audioAdapter, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 0, [AudioRecordGraph AudioFormat], sizeof(AudioStreamBasicDescription)) == noErr &&
                               AudioUnitSetProperty(_audioAdapter, kAudioUnitProperty_MaximumFramesPerSlice, kAudioUnitScope_Global, 0, &maxFPS, sizeof(maxFPS)) == noErr &&
                               
                               AudioUnitSetProperty(_audioOut, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, 1, &flag, sizeof(flag)) == noErr &&
                               AudioUnitSetProperty(_audioOut, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 1, [AudioRecordGraph AudioFormat], sizeof(AudioStreamBasicDescription)) == noErr &&
                               AudioUnitSetProperty(_audioOut, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, [AudioRecordGraph AudioFormat], sizeof(AudioStreamBasicDescription)) == noErr &&
                               AudioUnitSetProperty(_audioOut, kAudioUnitProperty_MaximumFramesPerSlice, kAudioUnitScope_Global, 0, &maxFPS, sizeof(maxFPS)) == noErr)
                            {
                                AURenderCallbackStruct rcb = { (AURenderCallback)recordingCallback, (__bridge void * _Nullable)(self) };
                                OSStatus status = AudioUnitSetProperty(_audioOut, kAudioOutputUnitProperty_SetInputCallback, kAudioUnitScope_Global, 1, &rcb, sizeof(rcb));
                                
                                AURenderCallbackStruct pbc = { (AURenderCallback)playbackCallback, (__bridge void * _Nullable)(self) };
                                status = AudioUnitSetProperty(_audioAdapter, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Global, 0, &pbc, sizeof(pbc));
                                

                                flag = 0;
                                status = AudioUnitSetProperty(_audioOut, kAudioUnitProperty_ShouldAllocateBuffer, kAudioUnitScope_Output, 1, &flag, sizeof(flag));
                                
                                
                                _audioBuffer.mNumberChannels = 1;
                                _audioBuffer.mDataByteSize = 512 * 2;
                                _audioBuffer.mData = malloc( 512 * 2 );
                                
                                self.volumeOfMic = 0.5;
                                self.volumeOfEffect = 0.5;
                                
                                AudioRecordGraph *__weak graph = self;
                                _audioSessionObserver[0] = [NSNotificationCenter.defaultCenter addObserverForName:AVAudioSessionInterruptionNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
                                    [graph handleAudioInterruption:note];
                                }];
                                _audioSessionObserver[1] = [NSNotificationCenter.defaultCenter addObserverForName:AVAudioSessionRouteChangeNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
                                    [graph handleAudioRouteChange:note];
                                }];
                                
                                return YES;
                            }
                        }
                    }
                }
            }
        }
        
        return NO;
    }

/**
 * @Desc
 * 효과음을 output으로 내보내면 하울링이 발생하기 때문에
 * mic는 output으로 내보내되 효과음은 내보내지 않는다.
 * 이 함수에서 mic로 들어온 데이터와 효과음의 데이터를 mix하여 파일에 저장한다.
 */
    - (void)processBuffer: (AudioBufferList*) audioBufferList inNumberFrames:(UInt32)inNumberFrames
    {
        AudioBuffer sourceBuffer = audioBufferList->mBuffers[0];
        if (_audioBuffer.mDataByteSize != sourceBuffer.mDataByteSize)
        {
            free(_audioBuffer.mData);
            _audioBuffer.mDataByteSize = sourceBuffer.mDataByteSize;
            _audioBuffer.mData = malloc(sourceBuffer.mDataByteSize);
        }
        
        AudioBufferList * saveBufferList = (AudioBufferList *)malloc(sizeof(AudioBufferList));
        
        if(self.isRunning && _isPlayingEffect && _pauseRecording == NO)
        {
            AudioStreamBasicDescription * desc = [AudioRecordGraph CanonicalInterleaved];
            AudioBufferList * effectBufferList = [self allocateABL:desc->mChannelsPerFrame bytesPerFrame:desc->mBytesPerFrame interleaved:YES capacityFrames:8192];
            
            UInt32 readInNumberFrames = inNumberFrames;
            OSStatus result = ExtAudioFileRead(_soundFileRef, &readInNumberFrames, effectBufferList);
            if(result != noErr || readInNumberFrames == 0)
            {
                if(result != noErr)
                    NSLog(@"soundfile read error : %d",(int)result);
                
                _isPlayingEffect = NO;
                [self setUpdateDecibels:0.0f view:self->_effectWaveformView];
                ExtAudioFileDispose(_soundFileRef);
                
                saveBufferList->mNumberBuffers = audioBufferList->mNumberBuffers;
                saveBufferList->mBuffers[0].mDataByteSize = (sourceBuffer.mDataByteSize * 2);
                saveBufferList->mBuffers[0].mNumberChannels = (sourceBuffer.mNumberChannels * 2);
                saveBufferList->mBuffers[0].mData = malloc(saveBufferList->mBuffers[0].mDataByteSize);
                
                short * records = (short *)sourceBuffer.mData;
                short * save = (short *)saveBufferList->mBuffers[0].mData;
                
                NSUInteger stereoIndex = 0;
                for (NSUInteger index = 0; index < (sourceBuffer.mDataByteSize / sizeof(short)); index++)
                {
                    stereoIndex = index * 2;
                    save[stereoIndex] = records[index] * (self.volumeOfMic * 2);
                    
                    stereoIndex++;
                    save[stereoIndex] = records[index] * (self.volumeOfMic * 2);
                }
                
                if (_startRecording == YES && _pauseRecording == NO)
                    ExtAudioFileWriteAsync(_recordingFileRef, inNumberFrames, saveBufferList);
                
                for(UInt32 bufferIndex = 0; bufferIndex < audioBufferList->mNumberBuffers; bufferIndex++)
                {
                    if(sourceBuffer.mData != NULL)
                        memset(sourceBuffer.mData, 0, sourceBuffer.mDataByteSize);
                }
            }
            else
            {
                [self setUpdateDecibels:[self findPeakValue:(SInt16*)(effectBufferList->mBuffers[0].mData) frame:inNumberFrames] view:self->_effectWaveformView];
                [self setEffectOffset:_effectOffset + inNumberFrames];
                
                saveBufferList->mNumberBuffers = effectBufferList->mNumberBuffers;
                
                for(UInt32 bufferIndex = 0; bufferIndex < effectBufferList->mNumberBuffers; bufferIndex++)
                {
                    saveBufferList->mBuffers[bufferIndex].mDataByteSize = (sourceBuffer.mDataByteSize * 2);
                    saveBufferList->mBuffers[bufferIndex].mNumberChannels = effectBufferList->mBuffers[bufferIndex].mNumberChannels;
                    saveBufferList->mBuffers[bufferIndex].mData = malloc(saveBufferList->mBuffers[bufferIndex].mDataByteSize);
                }
                
                short * records = (short *)sourceBuffer.mData;
                short * sounds = (short *)effectBufferList->mBuffers[0].mData;
                short * save = (short *)saveBufferList->mBuffers[0].mData;

                NSUInteger stereoIndex = 0;
                for (NSUInteger index = 0; index < (sourceBuffer.mDataByteSize / sizeof(short)); index++)
                {
                    stereoIndex = index * 2;
                    
                    if(stereoIndex > (effectBufferList->mBuffers[0].mDataByteSize / sizeof(short)))
                    {
                        save[stereoIndex] = (records[index] * (self.volumeOfMic * 2));
                        
                        stereoIndex++;
                        save[stereoIndex] = (records[index] * (self.volumeOfMic * 2));
                    }
                    else
                    {
                        save[stereoIndex] = ((records[index] * (self.volumeOfMic * 2)) + (sounds[stereoIndex] * self.volumeOfEffect)) / 2;
                        
                        stereoIndex++;
                        save[stereoIndex] = ((records[index] * (self.volumeOfMic * 2)) + (sounds[stereoIndex] * self.volumeOfEffect)) / 2;
                    }
                }
                
                if (_startRecording == YES && _pauseRecording == NO)
                    ExtAudioFileWriteAsync(_recordingFileRef, inNumberFrames, saveBufferList);
                
                memset(sourceBuffer.mData, 0, sourceBuffer.mDataByteSize);
                for (NSUInteger index = 0; index < (sourceBuffer.mDataByteSize / sizeof(short)); index++)
                {
                    stereoIndex = index * 2;
                    if(stereoIndex > (effectBufferList->mBuffers[0].mDataByteSize / sizeof(short)))
                    {
                        records[index] = 0;
                    }
                    else
                    {
                        records[index] = sounds[stereoIndex] * self.volumeOfEffect;
                    }
                }
            }
        }
        else
        {
            if(_pauseRecording == NO)
            {
                saveBufferList->mNumberBuffers = audioBufferList->mNumberBuffers;
                saveBufferList->mBuffers[0].mDataByteSize = (sourceBuffer.mDataByteSize * 2);
                saveBufferList->mBuffers[0].mNumberChannels = (sourceBuffer.mNumberChannels * 2);
                saveBufferList->mBuffers[0].mData = malloc(saveBufferList->mBuffers[0].mDataByteSize);
                
                short * records = (short *)sourceBuffer.mData;
                short * save = (short *)saveBufferList->mBuffers[0].mData;
                
                NSUInteger stereoIndex = 0;
                for (NSUInteger index = 0; index < (sourceBuffer.mDataByteSize / sizeof(short)); index++)
                {
                    stereoIndex = index * 2;
                    save[stereoIndex] = records[index] * (self.volumeOfMic * 2);
                    
                    stereoIndex++;
                    save[stereoIndex] = records[index] * (self.volumeOfMic * 2);
                }
                
                if (_startRecording == YES && _pauseRecording == NO)
                    ExtAudioFileWriteAsync(_recordingFileRef, inNumberFrames, saveBufferList);
                
                for(UInt32 bufferIndex = 0; bufferIndex < audioBufferList->mNumberBuffers; bufferIndex++)
                {
                    if(sourceBuffer.mData != NULL)
                        memset(sourceBuffer.mData, 0, sourceBuffer.mDataByteSize);
                }
            }
            else
            {
                for(UInt32 bufferIndex = 0; bufferIndex < audioBufferList->mNumberBuffers; bufferIndex++)
                {
                    if(sourceBuffer.mData != NULL)
                        memset(sourceBuffer.mData, 0, sourceBuffer.mDataByteSize);
                }
            }
        }
        
        memcpy(_audioBuffer.mData, sourceBuffer.mData, sourceBuffer.mDataByteSize);
    }


    - (AudioBufferList *)allocateABL:(UInt32)channelsPerFrame bytesPerFrame:(UInt32)bytesPerFrame interleaved:(BOOL)interleaved capacityFrames:(UInt32)capacityFrames
    {
        AudioBufferList *bufferList = NULL;
        
        UInt32 numBuffers = interleaved ? 1 : channelsPerFrame;
        UInt32 channelsPerBuffer = interleaved ? channelsPerFrame : 1;
        
//        bufferList = static_cast<AudioBufferList *>(calloc(1, offsetof(AudioBufferList, mBuffers) + (sizeof(AudioBuffer) * numBuffers)));
//        bufferList->mNumberBuffers = numBuffers;
//        
//        for(UInt32 bufferIndex = 0; bufferIndex < bufferList->mNumberBuffers; ++bufferIndex) {
//            bufferList->mBuffers[bufferIndex].mData = static_cast<void *>(calloc(capacityFrames, bytesPerFrame));
//            bufferList->mBuffers[bufferIndex].mDataByteSize = capacityFrames * bytesPerFrame;
//            bufferList->mBuffers[bufferIndex].mNumberChannels = channelsPerBuffer;
//        }
        
        return bufferList;
    }

    /*!
     Audio route change notification handler
     */
    - (void)handleAudioRouteChange:(NSNotification *)notification
    {
        AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
        if([route outputs].count == 1)
        {
            for (AVAudioSessionPortDescription* desc in [route outputs])
            {
                if ([[desc portType] isEqualToString:AVAudioSessionPortBuiltInSpeaker])
                {
                    if(AVAudioSession.sharedInstance.categoryOptions != AVAudioSessionCategoryOptionDefaultToSpeaker)
                    {
                        [AVAudioSession.sharedInstance setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:NULL];
                        [AVAudioSession.sharedInstance setActive:YES error:NULL];
                    }
                }
            }
        }
    }

    /*!
     Audio interrupt notification handler
     */
    - (void)handleAudioInterruption:(NSNotification *)notification
    {
        switch ([notification.userInfo[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue])
        {
            case AVAudioSessionInterruptionTypeBegan:
            {
                if(self.delegate != nil)
                    [self.delegate handleAudioInterruptionBegan];
                
                [AVAudioSession.sharedInstance setActive:NO error:NULL];
                AUGraphStop(_audioGraph);
                AUGraphUninitialize(_audioGraph);
                [self stopRunLoop];
                break;
            }
                
            case AVAudioSessionInterruptionTypeEnded:
            {
                BOOL shouldResume = [notification.userInfo[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue] == AVAudioSessionInterruptionOptionShouldResume;
                if (shouldResume)
                {
                    if(self.isRunning == NO)
                    {
                        if([self resume] == noErr)
                        {
                            if(self.delegate != nil)
                                [self.delegate handleAudioInterruptionEnded];
                        }
                    }
                    
                    if(self.isRunning  && _updateWaveformTimer == nil)
                        [self startRunLoop];
                }
                break;
            }
        }
    }

    - (void)applicationDidBecomeActive
    {
        if(self.isRunning == NO)
            [self resume];
        
        if(self.isRunning && _updateWaveformTimer == nil)
            [self startRunLoop];
        
        if(_isPlayingEffect == YES)
            [self setUpdateDecibels:0.0f view:_voiceWaveformView];
        else
            [self setUpdateDecibels:0.0f view:_effectWaveformView];
    }

    - (void)applicationDidEnterBackground
    {
        [self stopRunLoop];
    }

    - (void)setVocieWaveFormView:(__nullable id)view
    {
        _voiceWaveformView = (SCSiriWaveformView *)view;
    }

    - (void)setEffectWaveFormView:(__nullable id)view
    {
        _effectWaveformView = (SCSiriWaveformView *)view;
    }

    - (Float32)findPeakValue:(const SInt16 *)samples frame:(UInt32)inNumberFrames
    {
        Float32 decibels = DBOFFSET;
        Float32 peakValue = DBOFFSET;
        
        Float32 curFilteredValueOfSampleAmplitude, preFilteredValueOfSampleAmplitude = 0.0;
        
        for (int i=0; i < inNumberFrames; i++)
        {
            Float32 absoluteValueOfSampleAmplitude = abs(samples[i]);
            curFilteredValueOfSampleAmplitude = LOWPASSFILTERTIMESLICE * absoluteValueOfSampleAmplitude + (1.0 - LOWPASSFILTERTIMESLICE) * preFilteredValueOfSampleAmplitude;
            preFilteredValueOfSampleAmplitude = curFilteredValueOfSampleAmplitude;
            
            Float32 amplitudeToConvertToDB = curFilteredValueOfSampleAmplitude;
            Float32 sampleDB = 20.0*log10(amplitudeToConvertToDB) + DBOFFSET;
            if((sampleDB == sampleDB) && (sampleDB != -DBL_MAX))
            {
                if(sampleDB > peakValue) peakValue = sampleDB;
                decibels = peakValue;
            }
        }
        
        return decibels;
    }

    - (void)setUpdateDecibels:(CGFloat)decibels view:(SCSiriWaveformView *)waveView
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat decibel = decibels;
            if (decibels < -60.0f || decibels == 0.0f) {
                decibel = 0;
            }
            else {
                decibel = powf((powf(10.0f, 0.05f * decibels) - powf(10.0f, 0.05f * -60.0f)) * (1.0f / (1.0f - powf(10.0f, 0.05f * -60.0f))), 1.0f / 2.0f);
            }
            
            [waveView updateWithLevel:decibel];
        });
    }

    - (void)stopUpdateDecibels:(SCSiriWaveformView *)waveView
    {
        [waveView stopWaveGraph];
    }

    - (void)startRunLoop
    {
        _updateWaveformTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                                target:self
                                                              selector:@selector(updateRecordWaveform)
                                                              userInfo:nil
                                                               repeats:YES];
    }

    - (void)stopRunLoop
    {
        if(_updateWaveformTimer != nil)
            [_updateWaveformTimer invalidate];
        _updateWaveformTimer = nil;
    }

    - (void)updateRecordWaveform
    {
        if(_isPlayingEffect == YES)
        {
            [self.delegate setEffectOffset:_effectOffset];
        }
        else if(_isPlayingEffect == NO && _effectOffset > 0)
        {
            _effectOffset = 0;
            [self.delegate endPlayEffect];
        }
    }

    - (OSStatus)createSaveFile
    {
        CFURLRef destinationURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (__bridge CFStringRef)[self recordFileName], kCFURLPOSIXPathStyle, false);
        OSStatus result = ExtAudioFileCreateWithURL(destinationURL, kAudioFileM4AType, [AudioRecordGraph AudioFormatAAC], NULL, kAudioFileFlags_EraseFile, &_recordingFileRef);
        if(result == noErr)
        {
            UInt32 codec = kAppleSoftwareAudioCodecManufacturer;
            UInt32 size = sizeof(codec);
            result = ExtAudioFileSetProperty(_recordingFileRef, kExtAudioFileProperty_CodecManufacturer, size, &codec);
            result = ExtAudioFileSetProperty(_recordingFileRef, kExtAudioFileProperty_ClientDataFormat, sizeof(AudioStreamBasicDescription), [AudioRecordGraph CanonicalInterleaved]);
            if(result == noErr)
                result = ExtAudioFileWriteAsync(_recordingFileRef, 0, NULL);
        }
        
        if(result != noErr)
        {
            ExtAudioFileDispose(_recordingFileRef);
            _recordingFileRef = nil;
        }
        
        CFRelease(destinationURL);
        return result;
    }

    - (NSString *)recordFileName
    {
        NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path] == NO)
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
        
//        NSString * fileName = [NSString stringWithFormat:@"%@.m4a", [SimPotUtil dateString:[NSDate date] withDateFormat:@"yyyy년 MM월 dd일 - HH:mm:ss"]];
        
        NSString * fileName = @"";
        
        _currentRecordFile = [NSString stringWithFormat:@"%@/%@", path, fileName];
        return _currentRecordFile;
    }

    - (NSString *)savedRecordFilePath
    {
        return _currentRecordFile;
    }

    - (BOOL)playEffectSound:(NSString *)soundPath
    {
        CFURLRef soundURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (__bridge CFStringRef)soundPath, kCFURLPOSIXPathStyle, false);
        OSStatus result = ExtAudioFileOpenURL (soundURL, &_soundFileRef);
        if (noErr != result || NULL == _soundFileRef)
        {
            NSLog(@"error ext soundfile open url %d",(int)result);
            CFRelease(soundURL);
            return NO;
        }
        
        result = ExtAudioFileSetProperty (_soundFileRef,
                                          kExtAudioFileProperty_ClientDataFormat,
                                          sizeof(AudioStreamBasicDescription),
                                          [AudioRecordGraph CanonicalInterleaved]);
        
        if (noErr != result)
        {
            NSLog( @"ExtAudioFileSetProperty (client data format %d", (int)result);
            CFRelease(soundURL);
            ExtAudioFileDispose(_soundFileRef);
            return NO;
        }
        
        _isPlayingEffect = YES;
        self.effectOffset = 0;
        [self setUpdateDecibels:0.0f view:_voiceWaveformView];
        [self stopUpdateDecibels:_voiceWaveformView];
        
        CFRelease(soundURL);
        return YES;
    }

    - (void)stopEffectSound
    {
        _isPlayingEffect = NO;
        self.effectOffset = 0;
        [self setUpdateDecibels:0.0f view:_effectWaveformView];
        [self stopUpdateDecibels:_effectWaveformView];
        ExtAudioFileDispose(_soundFileRef);
    }
@end
