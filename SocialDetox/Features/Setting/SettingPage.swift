import SwiftUI

struct SettingPage: View {
  var body: some View {
    List {
      SettingTimeLimitSection()
    }
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
