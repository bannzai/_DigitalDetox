import AVKit
import AVFoundation
import Combine

class A: NSObject, ObservableObject {
  enum Progress {
    case willStart
    case didStart
    case willStop
    case didStop
  }

  @Published var progress: Progress?
  @Published var error: Error?

  let start = PassthroughSubject<Void, Never>()
  let started = PassthroughSubject<Void, Never>()

  var pictureInPictureController: AVPictureInPictureController!
  var sampleBufferDisplayLayer: AVSampleBufferDisplayLayer {
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
}

extension A: AVPictureInPictureControllerDelegate {
  // NOTE: Picture in Pictureの開始されることを通知
  func pictureInPictureControllerWillStartPictureInPicture(
    _ pictureInPictureController: AVPictureInPictureController
  ) {}
  // NOTE: Picture in Pictureが開始されたこと通知
  func pictureInPictureControllerDidStartPictureInPicture(
    _ pictureInPictureController: AVPictureInPictureController
  ) {}
  // NOTE: Picture in Pictureの起動に失敗したことを通知
  func pictureInPictureController(
    _ pictureInPictureController: AVPictureInPictureController,
    failedToStartPictureInPictureWithError error: Error
  ) {}
  // NOTE: Picture in Pictureが停止することを通知
  func pictureInPictureControllerWillStopPictureInPicture(
    _ pictureInPictureController: AVPictureInPictureController
  ) {}
  // NOTE: Picture in Pictureが停止したことを通知
  func pictureInPictureControllerDidStopPictureInPicture(
    _ pictureInPictureController: AVPictureInPictureController
  ) {}
}


extension A: AVPictureInPictureSampleBufferPlaybackDelegate {
  func pictureInPictureController(
    _ pictureInPictureController: AVPictureInPictureController,
    setPlaying playing: Bool
  ) {
//    pause.toggle()
//    dateLabel.text = "pause: \(pause)"
//    if let sampleBuffer = dateLabel.toCMSampleBuffer() {
//      bufferDisplayLayer.enqueue(sampleBuffer)
//    }
  }

  func pictureInPictureControllerTimeRangeForPlayback(
    _ pictureInPictureController: AVPictureInPictureController
  ) -> CMTimeRange {
    return CMTimeRange(start: .negativeInfinity, end: .positiveInfinity)
  }

  func pictureInPictureControllerIsPlaybackPaused(
    _ pictureInPictureController: AVPictureInPictureController
  ) -> Bool {
    return false
  }

  func pictureInPictureController(
    _ pictureInPictureController: AVPictureInPictureController,
    didTransitionToRenderSize newRenderSize: CMVideoDimensions
  ) {
//    dateLabel.text = "w: \(newRenderSize.width) h: \(newRenderSize.height)"
//    if let sampleBuffer = dateLabel.toCMSampleBuffer() {
//      bufferDisplayLayer.enqueue(sampleBuffer)
//    }
  }

  func pictureInPictureController(
    _ pictureInPictureController: AVPictureInPictureController,
    skipByInterval skipInterval: CMTime,
    completion completionHandler: @escaping () -> Void
  ) {
    completionHandler()
  }
}
