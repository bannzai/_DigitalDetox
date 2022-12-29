import SwiftUI

struct Renderer<T: Equatable>: ViewModifier {
  @Environment(\.displayScale) var displayScale
  let id: T
  let size: CGSize
  let rendered: (UIImage?) -> Void

  func body(content: Content) -> some View {
    content
      .task(id: id) {
        rendered(render(content: content, displayScale: displayScale, size: size))
      }
  }
}

extension View {
  func rendered<T: Equatable>(id: T, size: CGSize, callback: @escaping (UIImage?) -> Void) -> some View {
    modifier(Renderer(id: id, size: size, rendered: callback))
  }
}

@MainActor func render<V: View>(content: V, displayScale: CGFloat, size: CGSize) -> UIImage? {
  let renderer = ImageRenderer(content: content)
  renderer.scale = displayScale
  renderer.proposedSize = .init(size)
  return renderer.uiImage
}
