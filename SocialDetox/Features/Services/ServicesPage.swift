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
      }

      Section {
        ServiceView(service: .youtube)
        ServiceView(service: .netflix)
      } header: {
        Text("Video")
      }

      Section {
        ServiceView(service: .slack)
        ServiceView(service: .discord)
      } header: {
        Text("Message")
      }
    }
    .listStyle(.insetGrouped)
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

        VStack(alignment: .leading) {
          Text(service.name)

          Text("Open")
        }
      }
    }
    .buttonStyle(.plain)
    .padding()
  }
}

struct ServicesPage_Previews: PreviewProvider {
  static var previews: some View {
    ServicesPage()
  }
}

