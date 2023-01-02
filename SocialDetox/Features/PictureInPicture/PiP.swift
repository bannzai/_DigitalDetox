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
  private var canceller: Set<AnyCancellable> = []

  static let shared = PiP()

  private override init() {
    super.init()

    // NOTE: AVAudioSession should prepare before to use pictureInPictureController all functions
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback)
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      debugPrint("AudioSession throw error: \(error)")
    }

    let contentSource = AVPictureInPictureController.ContentSource(sampleBufferDisplayLayer: sampleBufferDisplayLayer, playbackDelegate: self)
    pictureInPictureController = AVPictureInPictureController(contentSource: contentSource)
    pictureInPictureController.delegate = self

    pictureInPictureController
      .publisher(for: \.isPictureInPicturePossible, options: [.initial, .new])
      .sink { [weak self] possible in
        self?.canStart = possible
      }
      .store(in: &canceller)
  }

  deinit {
    canceller.forEach { $0.cancel() }
  }

  func start() {
    pictureInPictureController.startPictureInPicture()
  }

  func stop() {
    pictureInPictureController.stopPictureInPicture()
    progress = nil
  }

  @MainActor func enqueue<V: View>(content: V, displayScale: CGFloat) {
    resetBuffer()

    let image = viewToCGImage(
      content: content.frame(
        width: size.width,
        height: size.height
      )
      .background(Color.white),
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
    isPlaying = true
  }

  func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
    launchError = error
  }

  func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
    progress = .willStop
  }

  func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
    progress = .didStop
    isPlaying = false
  }
}


extension PiP: AVPictureInPictureSampleBufferPlaybackDelegate {
  // NOTE: playing false means paused
  func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, setPlaying playing: Bool) {
    isPlaying = playing
    // Force update play/paused button UI on picture in picture layer
    pictureInPictureController.invalidatePlaybackState()
  }

  func pictureInPictureControllerTimeRangeForPlayback(_ pictureInPictureController: AVPictureInPictureController) -> CMTimeRange {
    .init(start: .negativeInfinity, end: .positiveInfinity)
  }

  func pictureInPictureControllerIsPlaybackPaused(_ pictureInPictureController: AVPictureInPictureController) -> Bool {
    switch progress {
    case .willStart, .didStart:
      return !isPlaying
    case .willStop, .didStop:
      return true
    case nil:
      // On iOS, as soon as I instantiate AVPictureInPictureController(contentSource: contentSource) I am receiving delegate callbacks to the AVPictureInPictureSampleBufferPlaybackDelegate methods:
      // https://github.com/jazzychad/PiPBugDemo
      return false
    }
  }

  func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, didTransitionToRenderSize newRenderSize: CMVideoDimensions) {
    size = .init(width: CGFloat(newRenderSize.width), height: CGFloat(newRenderSize.height))
  }

  func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, skipByInterval skipInterval: CMTime, completion completionHandler: @escaping () -> Void) {
    completionHandler()
  }
}
