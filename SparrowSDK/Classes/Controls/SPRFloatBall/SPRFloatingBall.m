//
//  SPRFloatBall.m
//  SparrowSDK
//
//  Created by 周凌宇 on 2018/3/8.
//

#import "SPRFloatingBall.h"
#import "SPRCommonData.h"
#import <Masonry/Masonry.h>
#import "SPRCacheManager.h"

typedef void (^BallClickedCallback)(void);
@interface SPRFloatingBall ()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIImageView *ballImageView;
@end

@implementation SPRFloatingBall

- (instancetype)initWithCallBack:(BallClickedCallback)callback {
    if (self = [super init]) {
        _ballClickedCallback = [callback copy];;
        self.frame = CGRectMake(0, 0, 50, 50);
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.8;
        [self ballImageView];

        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
        singleTapGesture.numberOfTapsRequired = 1;
        singleTapGesture.numberOfTouchesRequired  = 1;
        [self addGestureRecognizer:singleTapGesture];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGPoint coordinate = [SPRCacheManager getFloatingBallCoordinate];
    self.frame = CGRectMake(coordinate.x, coordinate.y, self.frame.size.width, self.frame.size.height);
}

- (void)handleSingleTap:(UIGestureRecognizer *)sender {
    if (self.ballClickedCallback) {
        self.ballClickedCallback();
        return;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    CGPoint prePoint = [touch previousLocationInView:self];
    CGFloat offsetX = currentPoint.x - prePoint.x;
    CGFloat offsetY = currentPoint.y - prePoint.y;

    self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [SPRCacheManager cacheFloatingBallCoordinate:self.frame.origin];
}

- (void)click {
    [self handleSingleTap:nil];
}

- (UIImageView *)ballImageView {
    if (_ballImageView == nil) {
        _ballImageView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"sparrow_floatingball"
                                        inBundle:[SPRCommonData bundle]
                   compatibleWithTraitCollection:nil];
        _ballImageView.contentMode = UIViewContentModeScaleAspectFill;
        _ballImageView.image = image;
        [self addSubview:_ballImageView];
        [_ballImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _ballImageView;
}

@end
