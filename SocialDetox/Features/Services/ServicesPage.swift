import SwiftUI

struct ServicesView: View {
  var body: some View {
    List {
      Section {
        Text("1")
        Text("2")
        Text("3")
      } header: {
        Text("SNS")
      }

      Section {
        Text("1")
        Text("2")
        Text("3")
      } header: {
        Text("Video")
      }

      Section {
        Text("1")
        Text("2")
        Text("3")
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
    "\(self)".uppercased()
  }

  var iconName: String {
    "\(self)"
  }

  enum Category: Int, Identifiable, CaseIterable {
    case sns
    case video
    case message

    var id: RawValue { rawValue }

    var titleKey: LocalizedStringKey {
      switch self {
      case .sns:
        return "SNS"
      case .video:
        return "Video"
      case .message:
        return "Message"
      }
    }

    var services: [Service] {
      Service.allCases.filter { $0.category == self }
    }
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
struct ServiceView: View {
  let service: Service

  var body: some View {
    HStack {

      VStack {

      }
    }
    .padding()
  }
}

struct ServicesView_Previews: PreviewProvider {
  static var previews: some View {
    ServicesView()
  }
}

