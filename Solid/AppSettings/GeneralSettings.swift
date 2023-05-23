import Defaults
import LaunchAtLogin
import SwiftUI

struct GeneralSettings: View {
    @Default(.stayOnTop) private var stayOnTop

    var body: some View {
        Form {
            Toggle("Stay on top", isOn: $stayOnTop)

            LaunchAtLogin.Toggle {
                Text("Launch at login")
            }
        }
        .padding()
    }
}

extension Defaults.Keys {
    static let stayOnTop = Key<Bool>("stayOnTop", default: true)
}

struct GeneralSettings_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettings()
    }
}
