//
//  SCSiriWaveformView.m
//  ExMicDecibel
//
//  Created by Kant on 2021/12/21.
//

#import "SCSiriWaveformView.h"
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#define     kGraphSize          3
#define     kDensity            5

#define     kHighGraphCount     9
#define     kMaxGraphCount      6

@interface SCSiriWaveformView ()

@property (nonatomic)           CGFloat             screenWidth;
@property (nonatomic)           CGFloat             maxLayersCount;

@property (nonatomic)           CGFloat             level;
@property (nonatomic)           CGFloat             preLevel;

@property (nonatomic)           BOOL                stopWave;
@end

@implementation SCSiriWaveformView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    _screenWidth = [UIApplication sharedApplication].keyWindow.frame.size.width;
    _stopWave = YES;
}

- (void)dealloc
{
}

- (void)stopWaveGraph
{
    _stopWave = YES;
    [self setNeedsDisplay];
}

- (void)updateWithLevel:(CGFloat)level
{
    _level = level;
    
    if(self.maxLayersCount == 0 || _screenWidth != [UIApplication sharedApplication].keyWindow.frame.size.width)
    {
        _screenWidth = [UIApplication sharedApplication].keyWindow.frame.size.width;
        
        self.maxLayersCount = CGRectGetWidth(self.bounds) / kDensity;
        int remain = (int)CGRectGetWidth(self.bounds) % kDensity;
        if(remain >= kGraphSize)
            self.maxLayersCount++;
    }
    
    [self setNeedsDisplay];
}

/**
 * @Desc
 * level은 정해진 값이 있는 것은 아니며, 테스트 과정에서 들어온 값을 로그로 찍어 분석후에 나름의 기준으로 설정한 것임
 */

- (NSUInteger)displayRangeFromLevel:(CGFloat)level
{
    NSUInteger range = 0;
    if(level > 0.0f && level < 1.0f)
    {
        range = round( level * (_maxLayersCount - (kHighGraphCount + kMaxGraphCount)));
    }
    else if(level >= 1.0f && level < 1.5f)
    {
        range = round((_maxLayersCount - kMaxGraphCount) - (floor(level * 10) - 10));
    }
    else if(level >= 1.5f && level < 2.0f)
    {
        range = _maxLayersCount - (floor(level * 10) - 10);
    }
    else if(level > 2.0f)
    {
        range = _maxLayersCount;
    }
    
    return range;
}

/**
 * @Desc
 * range를 기준으로 파형을 그리는 함수(화면이 보여질 때만 그린다.)
 *
 */

- (void)drawRect:(CGRect)rect
{
//    if([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive)
//        return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    
    [self.backgroundColor set];
    CGContextFillRect(context, self.bounds);
    
    NSUInteger index = 0;
    NSUInteger range = [self displayRangeFromLevel:_level];
    if(range > 0 && _stopWave == YES)
        _stopWave = NO;
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    UIImage * backgroundGraphImage = [UIImage imageNamed:@"record_default_wave_graph"];
    
    // 라이브 마이크볼륨 이미지
    UIImage *liveNormalGraphImage = [UIImage imageNamed:@"liveNormalGraphImage"];
    UIImage *liveHighGraphImage = [UIImage imageNamed:@"liveHighGraphImage"];
    
    for (CGFloat x = 0; x < width; x += kDensity)
    {
        if(x == 0 && _screenWidth == 414) x = 1;
        
        if(x + kGraphSize <= CGRectGetWidth(self.bounds))
        {
            CGSize imageSize = backgroundGraphImage.size;
            
            if(_stopWave == YES)
            {
                [liveNormalGraphImage drawInRect:CGRectMake(x, height - imageSize.height, imageSize.width, imageSize.height)];
            }
            else
            {
                // 팟티 라이브 > 마이크 볼륨
                if(index >= range)
                    [liveNormalGraphImage drawInRect:CGRectMake(x, height - imageSize.height, imageSize.width, imageSize.height)];
                else
                    [liveHighGraphImage drawInRect:CGRectMake(x, height - imageSize.height, imageSize.width, imageSize.height)];
                index++;
            }
        }
    }
    
    CGContextStrokePath(context);
}

@end
