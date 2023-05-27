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
                let hexString = ColorFormatter.shared
                    .hex(
                        color: colorInCurrentColorSpace,
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
