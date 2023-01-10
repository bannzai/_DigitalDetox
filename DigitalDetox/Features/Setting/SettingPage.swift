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
      VStack {
        ZStack {
          Text("DrawingGroup")
            .foregroundColor(.black)
            .padding(20)
            .background(Color.red)
          Text("DrawingGroup")
            .blur(radius: 2)
        }
        .font(.largeTitle)
        .compositingGroup()
        .opacity(1.0)
      }
      .background(Color.white)
      .drawingGroup()
    }
  }
}
