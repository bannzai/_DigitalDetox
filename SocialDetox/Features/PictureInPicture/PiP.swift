import AVKit
import AVFoundation
import Combine
import SwiftUI

class PiP: NSObject, ObservableObject {
  enum Progress {
    case willStart
    case didStart
    case willStop
    case didStop
  }

  @Published var canStart = false
  @Published var progress: Progress?
  @Published var launchError: Error?
  @Published var size: CGSize = .init(width: UIScreen.main.bounds.width, height: 120)
  @Published var isPlaying = false
  var isActivated: Bool { pictureInPictureController.isPictureInPictureActive }

  private var pictureInPictureController: AVPictureInPictureController!
  private var statusObservabtion: NSKeyValueObservation?
  private var possibilityObservation: NSKeyValueObservation?

  override init() {
    super.init()

    // NOTE: AVAudioSession should prepare to use pictureInPictureController all functions
    do {
      try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      debugPrint("AudioSession throw error: \(error)")
    }

    let contentSource = AVPictureInPictureController.ContentSource(sampleBufferDisplayLayer: sampleBufferDisplayLayer, playbackDelegate: self)
    pictureInPictureController = AVPictureInPictureController(contentSource: contentSource)
    pictureInPictureController.canStartPictureInPictureAutomaticallyFromInline = true
    pictureInPictureController.delegate = self

    statusObservabtion = sampleBufferDisplayLayer.observe(\AVSampleBufferDisplayLayer.status, options: [.new]) { [weak self] layer, change in
      if change.newValue == .failed {
        self?.pictureInPictureController.invalidatePlaybackState()
        sampleBufferDisplayLayer.flush()
      }
    }

    possibilityObservation = pictureInPictureController.observe(
      \AVPictureInPictureController.isPictureInPicturePossible,
       options: [.initial, .new],
       changeHandler: { [weak self] controller, change in
         if let value = change.newValue {
           self?.canStart = value
         }
       })



  }

  func start() {
    pictureInPictureController.startPictureInPicture()
  }

  func stop() {
      pictureInPictureController.stopPictureInPicture()
      progress = nil
      isPlaying = false
  }

  @MainActor func enqueue<V: View>(content: V, displayScale: CGFloat) {
    resetBuffer()

    let image = viewToCGImage(
      content: content.frame(
        width: size.width,
        height: size.height
      ),
      displayScale: displayScale,
      size: size
    )

    do {
      if let sampleBuffer = try image?.sampleBuffer(displayScale: displayScale) {
        sampleBufferDisplayLayer.enqueue(sampleBuffer)
      }
    } catch {
      // Ignore error
      debugPrint(error)
    }
  }

  private func resetBuffer() {
    if sampleBufferDisplayLayer.status == .failed {
      pictureInPictureController.invalidatePlaybackState()
      sampleBufferDisplayLayer.flush()
    }
  }
}

extension PiP: AVPictureInPictureControllerDelegate {
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


extension PiP: AVPictureInPictureSampleBufferPlaybackDelegate {
  // NOTE: playing false means paused
  func pictureInPictureController(_ : AVPictureInPictureController, setPlaying playing: Bool) {
    isPlaying = playing
  }

  func pictureInPictureControllerTimeRangeForPlayback(_ pictureInPictureController: AVPictureInPictureController) -> CMTimeRange {
    if pictureInPictureController.isPictureInPictureActive {
      return CMTimeRange(start: .negativeInfinity, end: .positiveInfinity)
    } else {
      return CMTimeRange.invalid
    }
  }

  func pictureInPictureControllerIsPlaybackPaused(_ pictureInPictureController: AVPictureInPictureController) -> Bool {
//    isPlaying = false
    return true
  }

  func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, didTransitionToRenderSize newRenderSize: CMVideoDimensions) {
    size = .init(width: CGFloat(newRenderSize.width), height: CGFloat(newRenderSize.height))
  }

  func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, skipByInterval skipInterval: CMTime, completion completionHandler: @escaping () -> Void) {
    completionHandler()
  }
}
