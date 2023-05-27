import AppKit
import Defaults

struct ColorFormatter {
    static let shared = ColorFormatter()

    func hex(
        color: NSColor,
        includeHashPrefix: Bool,
        lowerCaseHex: Bool
    ) -> String {
        let prefix = includeHashPrefix ? "#" : ""

        let hex = (prefix + color.hexString)

        if lowerCaseHex {
            return hex
        } else {
            return hex.uppercased()
        }
    }
}
