#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "UIImage+SGImageSize.h"
#import "SGQRCode.h"
#import "SGQRCodeAlbumManager.h"
#import "SGQRCodeGenerateManager.h"
#import "SGQRCodeHelperTool.h"
#import "SGQRCodeScanManager.h"
#import "SGQRCodeScanningView.h"

FOUNDATION_EXPORT double SGQRCodeVersionNumber;
FOUNDATION_EXPORT const unsigned char SGQRCodeVersionString[];

