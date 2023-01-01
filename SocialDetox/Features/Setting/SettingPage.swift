import SwiftUI

struct SettingPage: View {
  var body: some View {
    List {
      SettingTimeDeadlineSection()
    }
    .navigationBarTitleDisplayMode(.inline)
    .listStyle(.insetGrouped)
  }
}


struct SettingPage_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SettingPage()
        .environment(\.locale, .init(identifier: "ja"))
      SettingPage()
        .environment(\.locale, .init(identifier: "en"))
    }
  }
}
