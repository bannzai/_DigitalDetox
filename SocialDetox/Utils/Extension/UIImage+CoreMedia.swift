import UIKit
import CoreMedia
import AVKit
import AVFoundation

extension UIImage {
  func sampleBuffer() throws -> CMSampleBuffer? {
    guard let cgImage else {
      return nil
    }
    let size = (width: Int(cgImage.width), height: Int(cgImage.height))

    var pixelBuffer: CVPixelBuffer?
    guard CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, kCVPixelFormatType_32ARGB , nil, &pixelBuffer) == kCVReturnSuccess, let pixelBuffer else {
      return nil
    }
    CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
    let baseAddr = CVPixelBufferGetBaseAddress(pixelBuffer)
    let context = CGContext(
      data: baseAddr,
      width: size.width,
      height: size.height,
      bitsPerComponent: 8,
      bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
      space: CGColorSpaceCreateDeviceRGB(),
      bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
    )
    context?.draw(cgImage, in: .init(origin: .zero, size: .init(width: cgImage.width, height: cgImage.height)))
    CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)

    let videoFormatDescription = try CMVideoFormatDescription(videoCodecType: .jpeg, width: size.width, height: size.height)
    let timingInfo = CMSampleTimingInfo(
      duration: CMTime(value: 1, timescale: 60),
      presentationTimeStamp: CMTime(seconds: CACurrentMediaTime(), preferredTimescale: 60),
      decodeTimeStamp: .invalid)
    return try CMSampleBuffer(imageBuffer: pixelBuffer, formatDescription: videoFormatDescription, sampleTiming: timingInfo)
  }
}

