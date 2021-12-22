//
//  SCSiriWaveformView.h
//  ExMicDecibel
//
//  Created by Kant on 2021/12/21.
//

#import <UIKit/UIKit.h>

@interface SCSiriWaveformView : UIView

- (void)updateWithLevel:(CGFloat)level;
- (void)stopWaveGraph;
@end
