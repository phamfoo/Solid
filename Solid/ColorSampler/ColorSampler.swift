import AppKit
import Defaults

class ColorSampler: ObservableObject {
    @Published var isSampling = false
    let colorSampler = NSColorSampler()

    func show(selectionHandler: @escaping (NSColor?) -> Void) {
        isSampling = true
        colorSampler.show { color in
            self.isSampling = false
            let colorInCurrentColorSpace = color?
                .usingColorSpace(Defaults[.colorSpace].nsColorSpace)

            selectionHandler(colorInCurrentColorSpace)

            if let colorInCurrentColorSpace, Defaults[.copyAfterPicking] {
                let hexString = self.hexString(from: colorInCurrentColorSpace)
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(hexString, forType: .string)
            }
        }
    }

    // TODO:
    private func hexString(from color: NSColor) -> String {
        let prefix = Defaults[.includeHashPrefix] ? "#" : ""

        let hex = (prefix + color.hexString)

        if Defaults[.lowerCaseHex] {
            return hex
        } else {
            return hex.uppercased()
        }
    }
}
