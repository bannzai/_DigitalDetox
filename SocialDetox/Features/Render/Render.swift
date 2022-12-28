import SwiftUI

struct RenderSelf<T: Equatable>: ViewModifier {
  @Environment(\.displayScale) var displayScale
  let id: T
  let rendered: (UIImage?) -> Void

  func body(content: Content) -> some View {
    content
      .task(id: id) {
        rendered(render(content: content, displayScale: displayScale))
      }
  }
}

extension View {
  func rendered<T: Equatable>(id: T, callback: @escaping (UIImage?) -> Void) -> some View {
    modifier(RenderSelf(id: id, rendered: callback))
  }
}

@MainActor func render<V: View>(content: V, displayScale: CGFloat) -> UIImage? {
  let renderer = ImageRenderer(content: content)
  renderer.scale = displayScale
  return renderer.uiImage
}
