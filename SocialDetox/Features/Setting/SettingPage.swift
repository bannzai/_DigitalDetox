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
    SettingPage()
      .environment(\.locale, .init(identifier: "ja"))
  }
}
