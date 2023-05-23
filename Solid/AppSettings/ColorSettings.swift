import Defaults
import SwiftUI

struct ColorSettings: View {
    @Default(.includeHashPrefix) private var includeHashPrefix
    @Default(.lowerCaseHex) private var lowerCaseHex

    var body: some View {
        Form {
            Toggle("Include # prefix", isOn: $includeHashPrefix)
            Toggle("Lowercase hex", isOn: $lowerCaseHex)
        }
        .padding()
    }
}

extension Defaults.Keys {
    static let includeHashPrefix = Key<Bool>(
        "includeHashPrefix",
        default: false
    )

    static let lowerCaseHex = Key<Bool>(
        "lowerCaseHex",
        default: false
    )
}

struct ColorSettings_Previews: PreviewProvider {
    static var previews: some View {
        ColorSettings()
    }
}
