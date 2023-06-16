import Defaults
import SwiftUI

struct GeneralSettings: View {
    @Default(.stayOnTop) private var stayOnTop
    @Default(.copyAfterPicking) private var copyAfterPicking

    var body: some View {
        Form {
            Toggle("Stay on top", isOn: $stayOnTop)

            Toggle(
                "Copy hex code (sRGB) after picking",
                isOn: $copyAfterPicking
            )
        }
        .padding()
    }
}

extension Defaults.Keys {
    static let stayOnTop = Key<Bool>("stayOnTop", default: false)
    static let copyAfterPicking = Key<Bool>("copyAfterPicking", default: false)
}

struct GeneralSettings_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettings()
    }
}
