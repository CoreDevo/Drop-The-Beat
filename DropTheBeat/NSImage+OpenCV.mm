#import "NSImage+OpenCV.h"

static void ProviderReleaseDataNOP(void *info, const void *data, size_t size)
{
	return;
}


@implementation NSImage (NSImage_OpenCV)

-(CGImageRef)CGImage
{
	CGContextRef bitmapCtx = CGBitmapContextCreate(NULL/*data - pass NULL to let CG allocate the memory*/,
												   [self size].width,
												   [self size].height,
												   8 /*bitsPerComponent*/,
												   0 /*bytesPerRow - CG will calculate it for you if it's allocating the data.  This might get padded out a bit for better alignment*/,
												   [[NSColorSpace genericRGBColorSpace] CGColorSpace],
												   kCGBitmapByteOrder32Host|kCGImageAlphaPremultipliedFirst);

	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:bitmapCtx flipped:NO]];
	[self drawInRect:NSMakeRect(0,0, [self size].width, [self size].height) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
	[NSGraphicsContext restoreGraphicsState];

	CGImageRef cgImage = CGBitmapContextCreateImage(bitmapCtx);
	CGContextRelease(bitmapCtx);

	return cgImage;
}


-(cv::Mat)CVMat
{
	CGImageRef imageRef = [self CGImage];
	CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
	CGFloat cols = self.size.width;
	CGFloat rows = self.size.height;
	cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels

	CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
													cols,                      // Width of bitmap
													rows,                     // Height of bitmap
													8,                          // Bits per component
													cvMat.step[0],              // Bytes per row
													colorSpace,                 // Colorspace
													kCGImageAlphaNoneSkipLast |
													kCGBitmapByteOrderDefault); // Bitmap info flags

	CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), imageRef);
	CGContextRelease(contextRef);
	CGImageRelease(imageRef);
	return cvMat;
}

-(cv::Mat)CVGrayscaleMat
{
	CGImageRef imageRef = [self CGImage];
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	CGFloat cols = self.size.width;
	CGFloat rows = self.size.height;
	cv::Mat cvMat = cv::Mat(rows, cols, CV_8UC1); // 8 bits per component, 1 channel
	CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
													cols,                      // Width of bitmap
													rows,                     // Height of bitmap
													8,                          // Bits per component
													cvMat.step[0],              // Bytes per row
													colorSpace,                 // Colorspace
													kCGImageAlphaNone |
													kCGBitmapByteOrderDefault); // Bitmap info flags

	CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), imageRef);
	CGContextRelease(contextRef);
	CGColorSpaceRelease(colorSpace);
	CGImageRelease(imageRef);
	return cvMat;
}

+ (NSImage *)imageWithCVMat:(const cv::Mat&)cvMat
{
	return [[NSImage alloc] initWithCVMat:cvMat];
}

- (id)initWithCVMat:(const cv::Mat&)cvMat
{
	cv::Mat rgbMat;
	cv::cvtColor(cvMat, rgbMat, CV_BGR2RGB);
	NSData *data = [NSData dataWithBytes:rgbMat.data length:rgbMat.elemSize() * rgbMat.total()];

	CGColorSpaceRef colorSpace;

	if (rgbMat.elemSize() == 1)
	{
		colorSpace = CGColorSpaceCreateDeviceGray();
	}
	else
	{
		colorSpace = CGColorSpaceCreateDeviceRGB();
	}

	CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);


	CGImageRef imageRef = CGImageCreate(rgbMat.cols,                                    // Width
										rgbMat.rows,                                    // Height
										8,                                              // Bits per component
										8 * rgbMat.elemSize(),                          // Bits per pixel
										rgbMat.step[0],                                 // Bytes per row
										colorSpace,                                     // Colorspace
										kCGImageAlphaNone | kCGBitmapByteOrderDefault,  // Bitmap info flags
										provider,                                       // CGDataProviderRef
										NULL,                                           // Decode
										false,                                          // Should interpolate
										kCGRenderingIntentDefault);                     // Intent


	NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:imageRef];
	NSImage *image = [[NSImage alloc] init];
	[image addRepresentation:bitmapRep];

	CGImageRelease(imageRef);
	CGDataProviderRelease(provider);
	CGColorSpaceRelease(colorSpace);

	return image;
}

@end