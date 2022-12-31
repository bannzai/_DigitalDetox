import SwiftUI

struct ServicesPage: View {
  var body: some View {
    List {
      Section {
        ServiceView(service: .twitter)
        ServiceView(service: .facebook)
        ServiceView(service: .instagram)
        ServiceView(service: .snapchat)
      } header: {
        Text("SNS")
          .textCase(nil)
      }

      Section {
        ServiceView(service: .youtube)
        ServiceView(service: .netflix)
      } header: {
        Text("Video")
          .textCase(nil)
      }

      Section {
        ServiceView(service: .slack)
        ServiceView(service: .discord)
      } header: {
        Text("Message")
          .textCase(nil)
      }
    }
    .listStyle(.insetGrouped)
    .navigationTitle("Launcher")
  }
}

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
}

struct ServiceView: View {
  let service: Service

  var body: some View {
    Button {
      if let url = URL(string: service.urlScheme) {
        UIApplication.shared.open(url)
      }
    } label: {
      HStack(spacing: 16) {
        Image(service.iconName)
          .resizable()
          .scaledToFill()
          .frame(width: 32, height: 32)
          .background(service.iconBackgroundColor)
          .cornerRadius(4)

        VStack(alignment: .leading) {
          Text(service.name)
        }

        Spacer()
        Text("Start")
          .foregroundColor(.init(uiColor: .systemMint))
      }
    }
    .buttonStyle(.plain)
  }
}

struct ServicesPage_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ServicesPage()
        .environment(\.colorScheme, .dark)
      ServicesPage()
        .environment(\.colorScheme, .light)
    }
  }
}

