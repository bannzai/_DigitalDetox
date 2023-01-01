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

struct ServiceView: View {
  let service: Service

  var body: some View {
    ZStack {
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
          HStack {
            Text("Start")
              .foregroundColor(.init(uiColor: .systemMint))

            Image(systemName: "chevron.right")
          }
        }
      }
      .buttonStyle(.plain)
    }
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

