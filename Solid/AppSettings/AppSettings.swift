import SwiftUI

struct AppSettings: View {
    var body: some View {
        TabView {
            GeneralSettings()
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }
                .tag(Tab.general)

            ColorSettings()
                .tabItem {
                    Label("Color", systemImage: "grid")
                }
                .tag(Tab.advanced)
        }
        .padding(20)
        .frame(width: 375, height: 150)
    }
}

extension AppSettings {
    private enum Tab: Hashable {
        case general, advanced
    }
}

struct AppSettings_Previews: PreviewProvider {
    static var previews: some View {
        AppSettings()
    }
}
