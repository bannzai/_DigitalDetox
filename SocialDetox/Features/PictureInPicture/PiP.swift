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
  var isActivated: Bool { pictureInPictureController.isPictureInPictureActive }

  private var pictureInPictureController: AVPictureInPictureController!
  private var canceller: Set<AnyCancellable> = []

  override init() {
    super.init()

    // NOTE: AVAudioSession should prepare to use pictureInPictureController all functions
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
    print(pictureInPictureController.contentSource?.sampleBufferDisplayLayer === sampleBufferDisplayLayer)
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
  }

  func pictureInPictureControllerTimeRangeForPlayback(_ pictureInPictureController: AVPictureInPictureController) -> CMTimeRange {
    .init(start: .negativeInfinity, end: .positiveInfinity)
  }

  func pictureInPictureControllerIsPlaybackPaused(_ pictureInPictureController: AVPictureInPictureController) -> Bool {
    false
  }

  func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, didTransitionToRenderSize newRenderSize: CMVideoDimensions) {
    size = .init(width: CGFloat(newRenderSize.width), height: CGFloat(newRenderSize.height))
  }

  func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, skipByInterval skipInterval: CMTime, completion completionHandler: @escaping () -> Void) {
    completionHandler()
  }
}
