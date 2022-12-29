import AVKit
import AVFoundation
import Combine
import SwiftUI

class PiPProxy: NSObject, ObservableObject {
  enum Progress {
    case willStart
    case didStart
    case willStop
    case didStop
  }

  @Published var progress: Progress?
  @Published var launchError: Error?
  @Published var size: CGSize = .init(width: UIScreen.main.bounds.width, height: 80)
  @Published var isPlaying = false

  private var pictureInPictureController: AVPictureInPictureController!
  private var sampleBufferDisplayLayer: AVSampleBufferDisplayLayer {
    pictureInPictureController.contentSource!.sampleBufferDisplayLayer!
  }
  private var observation: NSKeyValueObservation?

  override init() {
    super.init()

    let contentSource = AVPictureInPictureController.ContentSource(sampleBufferDisplayLayer: .init(), playbackDelegate: self)
    pictureInPictureController = AVPictureInPictureController(contentSource: contentSource)
    pictureInPictureController.delegate = self

    observation = sampleBufferDisplayLayer.observe(\AVSampleBufferDisplayLayer.status, options: [.initial, .new]) { [weak self] layer, change in
      if change.newValue == .failed {
        self?.pictureInPictureController.invalidatePlaybackState()
        self?.sampleBufferDisplayLayer.flush()
      }
    }
  }

  func toggle() {
    if pictureInPictureController.isPictureInPictureActive {
      pictureInPictureController.stopPictureInPicture()
    } else {
      pictureInPictureController.startPictureInPicture()
    }
  }

  @MainActor func enqueue<V: View>(content: V, displayScale: CGFloat) {
    resetBuffer()

    let image = viewToCGImage(
      content: content.frame(
        width: size.width,
        height: size.height),
      displayScale: displayScale,
      size: size
    )

    do {
      if let sampleBuffer = try image?.sampleBuffer(displayScale: displayScale) {
        sampleBufferDisplayLayer.enqueue(sampleBuffer)
        dump(sampleBuffer)
      }
    } catch {
      print(error)
    }
  }

  private func resetBuffer() {
    if sampleBufferDisplayLayer.status == .failed {
      pictureInPictureController.invalidatePlaybackState()
      sampleBufferDisplayLayer.flush()
    }
  }
}

extension PiPProxy: AVPictureInPictureControllerDelegate {
  func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
    progress = .willStart
  }

  func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
    progress = .didStart
  }

  func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
    launchError = error
  }

  func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
    progress = .willStop
  }

  func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
    progress = .didStop
  }
}


extension PiPProxy: AVPictureInPictureSampleBufferPlaybackDelegate {
  // NOTE: playing false means poused
  func pictureInPictureController(_ : AVPictureInPictureController, setPlaying playing: Bool) {
    isPlaying = playing
  }

  func pictureInPictureControllerTimeRangeForPlayback(_ pictureInPictureController: AVPictureInPictureController) -> CMTimeRange {
    return CMTimeRange(start: .negativeInfinity, end: .positiveInfinity)
  }

  func pictureInPictureControllerIsPlaybackPaused(_ pictureInPictureController: AVPictureInPictureController) -> Bool {
    isPlaying = false
    return true
  }

  func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, didTransitionToRenderSize newRenderSize: CMVideoDimensions) {
    size = .init(width: CGFloat(newRenderSize.width), height: CGFloat(newRenderSize.height))
  }

  func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, skipByInterval skipInterval: CMTime, completion completionHandler: @escaping () -> Void) {
    completionHandler()
  }
}
