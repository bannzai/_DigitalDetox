import SwiftUI

extension View {
  func alert(error: Binding<Error?>) -> some View {
    let alertError = AlertError(error: error.wrappedValue)

    return alert(isPresented: .constant(alertError != nil), error: alertError) { _ in
      Button("OK") {
        error.wrappedValue = nil
      }
    } message: { error in
      Text(error.failureReason ?? "")
    }
  }
}


private struct AlertError: LocalizedError {
  let underlyingError: Error

  init?(error: Error?) {
    guard let error else {
      return nil
    }
    underlyingError = error
  }

  var errorDescription: String? {
    (underlyingError as? LocalizedError)?.errorDescription ?? underlyingError.localizedDescription
  }

  var failureReason: String? {
    (underlyingError as? LocalizedError)?.failureReason
  }
}
