import Defaults
import SwiftUI

struct GeneralSettings: View {
    @Default(.stayOnTop) private var stayOnTop
    @Default(.launchAtLogin) private var launchAtLogin

    var body: some View {
        Form {
            Toggle("Stay on top", isOn: $stayOnTop)
            Toggle("Launch at login", isOn: $launchAtLogin)
        }
        .padding()
    }
}

extension Defaults.Keys {
    static let stayOnTop = Key<Bool>("stayOnTop", default: true)
    static let launchAtLogin = Key<Bool>("launchAtLogin", default: true)
}

struct GeneralSettings_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettings()
    }
}
