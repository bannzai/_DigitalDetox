import SwiftUI

@MainActor func render<V: View>(content: V, displayScale: CGFloat, size: CGSize) -> CGImage? {
  let renderer = ImageRenderer(content: content)
  renderer.scale = displayScale
  renderer.proposedSize = .init(size)
  return renderer.cgImage
}

// NOTE: https://note.com/reality_eng/n/n662347337553
@MainActor func makeImage(body: some View, size: CGSize) -> UIImage? {
  let imageRenderer = ImageRenderer(content: body)
  imageRenderer.scale = UIScreen.main.scale
  imageRenderer.proposedSize = ProposedViewSize(size)
  let uiGraphicsImageRenderer = UIGraphicsImageRenderer(size: size)
  let image = uiGraphicsImageRenderer.image { context in
    imageRenderer.render { _, uiGraphicsImageRenderer in
      // CGContextの座標は上下が逆なので、反転させる
      let flipVerticalMatrix = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height)
      context.cgContext.concatenate(flipVerticalMatrix)
      uiGraphicsImageRenderer(context.cgContext)
    }
  }
  return image
}
