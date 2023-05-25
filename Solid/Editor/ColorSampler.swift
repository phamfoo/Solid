import Defaults
import SwiftUI

struct ColorSampler: View {
    @Default(.copyAfterPicking) private var copyAfterPicking
    @Default(.includeHashPrefix) private var includeHashPrefix
    @Default(.lowerCaseHex) private var lowerCaseHex

    @State private var isSampling = false

    var onPick: (NSColor) -> Void

    var body: some View {
        Button {
            isSampling = true
            NSColorSampler()
                .show { pickedColor in
                    isSampling = false

                    if let pickedColor {
                        self.onPick(pickedColor)

                        if copyAfterPicking {
                            // TODO:
                            let hexString = hexString(from: pickedColor)
                            let pasteboard = NSPasteboard.general
                            pasteboard.clearContents()
                            pasteboard.setString(hexString, forType: .string)
                        }
                    }
                }
        } label: {
            Image(systemName: "eyedropper")
                .imageScale(.large)
        }
        .buttonStyle(.solid)
        .background {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.accentColor)
                .opacity(isSampling ? 1 : 0)
        }
    }

    // TODO:
    func hexString(from color: NSColor) -> String {
        let prefix = includeHashPrefix ? "#" : ""

        let hex = (prefix + color.hexString)

        if lowerCaseHex {
            return hex
        } else {
            return hex.uppercased()
        }
    }
}

struct ColorSampler_Previews: PreviewProvider {
    static var previews: some View {
        ColorSampler { _ in }
    }
}
