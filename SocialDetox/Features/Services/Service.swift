import SwiftUI

enum Service: Int, Identifiable, CaseIterable {
  // SNS
  case twitter, facebook, instagram, snapchat
  // Movie
  case youtube, netflix
  // Message
  case slack, discord

  var id: RawValue { rawValue }

  var name: String {
    "\(self)".capitalized
  }

  var iconName: String {
    "\(self)"
  }

  var iconBackgroundColor: Color {
    switch self {
    case .twitter:
      return .clear
    case .facebook:
      return .init(uiColor: .init(red: 26 / 255, green: 119 / 255, blue: 242 / 255, alpha: 1))
    case .instagram:
      return .white
    case .snapchat:
      return .init(uiColor: .init(red: 255 / 255, green: 252 / 255, blue: 0, alpha: 1))
    case .youtube:
        return .white
    case .netflix:
      return .black
    case .slack:
      return .white
    case .discord:
      return .init(uiColor: .init(red: 87 / 255, green: 101 / 255, blue: 242 / 255, alpha: 1))
    }
  }

  // Ref: https://medium.com/@contact.jmeyers/complete-list-of-ios-url-schemes-for-third-party-apps-always-updated-5663ef15bdff
  var urlScheme: String {
    switch self {
    case .twitter:
      return "twitter://"
    case .facebook:
      return "fb://"
    case .instagram:
      return "instagram://"
    case .snapchat:
      return "snapchat://"
    case .youtube:
      return "youtube://"
    case .netflix:
      return "nflx://"
    case .slack:
      return "slack://"
    case .discord:
      return "discord://"
    }
  }

  enum Category: CaseIterable {
    case sns
    case video
    case message
  }
  var category: Category {
    switch self {
    case .twitter, .facebook, .instagram, .snapchat:
      return .sns
    case .youtube, .netflix:
      return .video
    case .slack, .discord:
      return .message
    }
  }
}


