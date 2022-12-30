import UIKit
import CoreMedia
import CoreGraphics
import AVKit
import AVFoundation

extension CGImage {
  func sampleBuffer(displayScale: CGFloat) throws -> CMSampleBuffer? {
    func scaled(_ value: Int) -> Int {
      Int(CGFloat(value) * displayScale)
    }
    let size = (width: scaled(width), height: scaled(height))

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
      CVPixelBufferLockBaseAddress(pixelBuffer, [])
      defer {
        CVPixelBufferUnlockBaseAddress(pixelBuffer, [])
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
      context?.draw(self, in: .init(origin: .zero, size: .init(width: .init(size.width), height: .init(size.height))))
    }
    drawToPixelBuffer()

    let videoFormatDescription = try CMVideoFormatDescription(imageBuffer: pixelBuffer)
    let timingInfo = CMSampleTimingInfo(
      duration: .init(seconds: 1, preferredTimescale: 60),
      presentationTimeStamp: .init(seconds: CACurrentMediaTime(), preferredTimescale: 60),
      decodeTimeStamp: .invalid
    )
    return try CMSampleBuffer(
      imageBuffer: pixelBuffer,
      formatDescription: videoFormatDescription,
      sampleTiming: timingInfo
    )
  }
}

