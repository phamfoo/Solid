import AppKit

extension NSColor {
    var hexString: String {
        let red = Int((redComponent * 255).rounded())
        let green = Int((greenComponent * 255).rounded())
        let blue = Int((blueComponent * 255).rounded())

        return String(format: "#%02x%02x%02x", red, green, blue)
    }
}
