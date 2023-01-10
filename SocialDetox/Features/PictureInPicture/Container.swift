import AVKit
import SwiftUI

let sampleBufferDisplayLayer = AVSampleBufferDisplayLayer()
struct PiPContainer: UIViewRepresentable {
  @ObservedObject var pip: PiP

  func makeUIView(context: Context)  -> UIView {
    let container = UIView(frame: .init(origin: .zero, size: pip.size))
    sampleBufferDisplayLayer.frame.size = container.bounds.size
    container.layer.addSublayer(sampleBufferDisplayLayer)
    return container
  }

  func updateUIView(_ uiView: UIView, context: Context) {
    print(#file, #function)
  }
}

