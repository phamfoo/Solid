import Defaults
import SwiftUI

struct GeneralSettings: View {
    @Default(.stayOnTop) private var stayOnTop
    @Default(.copyAfterPicking) private var copyAfterPicking
    @Default(.rightClickMenuBarToPick) private var rightClickMenuBarToPick

    var body: some View {
        Form {
            Toggle("Stay on top", isOn: $stayOnTop)

            Toggle(
                "Copy hex code (sRGB) after picking",
                isOn: $copyAfterPicking
            )

            Toggle(
                "Right click on the menu bar icon to pick a color",
                isOn: $rightClickMenuBarToPick
            )
        }
        .padding()
    }
}

extension Defaults.Keys {
    static let stayOnTop = Key<Bool>("stayOnTop", default: false)
    static let copyAfterPicking = Key<Bool>("copyAfterPicking", default: false)
    static let rightClickMenuBarToPick = Key<Bool>(
        "rightClickMenuBarToPick",
        default: true
    )
}

struct GeneralSettings_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettings()
    }
}
