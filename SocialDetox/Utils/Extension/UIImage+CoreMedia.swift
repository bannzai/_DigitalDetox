import UIKit
import CoreMedia
import AVKit
import AVFoundation

extension UIImage {
  func sampleBuffer(displayScale: CGFloat) throws -> CMSampleBuffer? {
    guard let cgImage else {
      return nil
    }
    func scaled(_ value: Int) -> Int {
      Int(CGFloat(value) * displayScale)
    }
    let size = (width: scaled(cgImage.width), height: scaled(cgImage.height))

    var pixelBuffer: CVPixelBuffer?
    let pixelBufferCreateStatus = CVPixelBufferCreate(
      kCFAllocatorDefault,
      size.width,
      size.height,
      kCVPixelFormatType_32ARGB,
      [
        kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
        kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!,
        kCVPixelBufferIOSurfacePropertiesKey: [:] as CFDictionary,
      ] as CFDictionary,
      &pixelBuffer
    )
    guard pixelBufferCreateStatus == kCVReturnSuccess, let pixelBuffer else {
      return nil
    }
    func drawToPixelBuffer() {
      CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
      defer {
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
      }
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
    }
    drawToPixelBuffer()

    let videoFormatDescription = try CMVideoFormatDescription(imageBuffer: pixelBuffer)
    let timingInfo = CMSampleTimingInfo(
      duration: .init(seconds: 1, preferredTimescale: 60),
      presentationTimeStamp: .init(seconds: CACurrentMediaTime(), preferredTimescale: 60),
      decodeTimeStamp: .init(seconds: CACurrentMediaTime(), preferredTimescale: 60)
    )
    return try CMSampleBuffer(
      imageBuffer: pixelBuffer,
      formatDescription: videoFormatDescription,
      sampleTiming: timingInfo
    )
  }
}

