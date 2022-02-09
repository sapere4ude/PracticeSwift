//
//  AudioRecordGraph.h
//  ExMicDecibel
//
//  Created by Kant on 2021/12/21.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>

@protocol AudioRecorderDelegate <NSObject>
- (void)setEffectOffset:(CGFloat)offset;
- (void)endPlayEffect;

- (void)handleAudioInterruptionBegan;
- (void)handleAudioInterruptionEnded;
@end

@interface AudioRecordGraph : NSObject

@property(readonly, getter = isRunning)         bool        running;
@property (nonatomic)                           BOOL        startRecording;
@property (nonatomic)                           CGFloat     effectOffset;

@property   Float32                                         volumeOfMic;
@property   Float32                                         volumeOfEffect;

NS_ASSUME_NONNULL_BEGIN
+ (AudioStreamBasicDescription *)CanonicalInterleaved;
+ (AudioStreamBasicDescription *)AudioFormatAAC;

// control object
- (BOOL)createGraph;

- (bool)startAudioGraph;
- (void)activatePlayback;
- (void)stop;

- (void)pauseRecording:(BOOL)pause;
- (void)cancelRecord;

- (void)applicationDidBecomeActive;
- (void)applicationDidEnterBackground;

- (NSString *)savedRecordFilePath;
- (BOOL)playEffectSound:(NSString *)soundPath;
- (void)stopEffectSound;

NS_ASSUME_NONNULL_END

- (void)setVocieWaveFormView:(__nullable id)view;
- (void)setEffectWaveFormView:(__nullable id)view;

@property (nonatomic, weak) __nullable id<AudioRecorderDelegate>   delegate;
@end
