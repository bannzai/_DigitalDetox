import AVKit
import SwiftUI

struct PiPContainer: UIViewRepresentable {
  @EnvironmentObject var pip: PiP

  func makeUIView(context: Context)  -> UIView {
    let container = UIView(frame: .init(origin: .zero, size: pip.size))
    sampleBufferDisplayLayer.frame.size = container.bounds.size
    sampleBufferDisplayLayer.videoGravity = .resizeAspect
    container.layer.addSublayer(sampleBufferDisplayLayer)
    return container
  }

  func updateUIView(_ uiView: UIView, context: Context) {
    print(#file, #function)
  }
}

