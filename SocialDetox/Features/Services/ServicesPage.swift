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

