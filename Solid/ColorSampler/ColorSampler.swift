import AppKit
import Defaults

class ColorSampler: ObservableObject {
    @Published var isSampling = false
    let colorSampler = NSColorSampler()

    func show(selectionHandler: @escaping (NSColor?) -> Void) {
        isSampling = true
        colorSampler.show { color in
            self.isSampling = false
            selectionHandler(color)

            if Defaults[.copyAfterPicking] {
                if let sRGBColor = color?.usingColorSpace(.sRGB) {
                    let hexString = ColorFormatter.shared
                        .hex(
                            color: sRGBColor,
                            includeHashPrefix: Defaults[.includeHashPrefix],
                            lowerCaseHex: Defaults[.lowerCaseHex]
                        )
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(hexString, forType: .string)
                }
            }
        }
    }
}
