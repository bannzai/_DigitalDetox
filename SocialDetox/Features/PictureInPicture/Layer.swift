import AVKit
import AVFoundation

class A: NSObject {
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
