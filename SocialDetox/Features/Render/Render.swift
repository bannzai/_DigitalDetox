import SwiftUI

// NOTE: https://note.com/reality_eng/n/n662347337553
@MainActor func viewToCGImage<V: View>(content: V, displayScale: CGFloat, size: CGSize) -> CGImage? {
  let imageRenderer = ImageRenderer(content: content)
  imageRenderer.scale = displayScale
  imageRenderer.proposedSize = ProposedViewSize(size)

  let uiGraphicsImageRenderer = UIGraphicsImageRenderer(size: size)
  let image = uiGraphicsImageRenderer.image { context in
    imageRenderer.render { _, uiGraphicsImageRenderer in
      let flipVerticalMatrix = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height)
      context.cgContext.concatenate(flipVerticalMatrix)
      uiGraphicsImageRenderer(context.cgContext)
    }
  }

  return image.cgImage
}
