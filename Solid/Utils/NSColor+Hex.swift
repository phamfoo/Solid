import AppKit

extension NSColor {
    var hexString: String {
        let red = Int((redComponent * 255).rounded())
        let green = Int((greenComponent * 255).rounded())
        let blue = Int((blueComponent * 255).rounded())
        let alpha = Int((alphaComponent * 255).rounded())

        if alpha == 255 {
            return String(format: "%02x%02x%02x", red, green, blue)
        } else {
            return String(format: "%02x%02x%02x%02x", red, green, blue, alpha)
        }
    }
}

private let hexComponent = #"[a-f\d]{2}"#
private let hexRegex = try! NSRegularExpression(
    pattern: #"""
    ^#?
    (?<red>\#(hexComponent))
    (?<green>\#(hexComponent))
    (?<blue>\#(hexComponent))
    (?<alpha>\#(hexComponent))?
    """#
    .replacingOccurrences(of: "\n", with: ""),
    options: .caseInsensitive
)

extension NSColor {
    convenience init?(colorSpace: NSColorSpace, hexString: String) {
        let range = NSRange(location: 0, length: hexString.utf16.count)
        guard let match = hexRegex.firstMatch(in: hexString, range: range)
        else { return nil }

        var normalizedValues = [String: Double]()

        for componentName in ["red", "green", "blue", "alpha"] {
            guard let range = Range(
                match.range(withName: componentName),
                in: hexString
            )
            else { continue }

            let componentHexString = hexString[range]
            guard let componentValue = Int(componentHexString, radix: 16)
            else { continue }

            let normalizedValue = Double(componentValue) / 255
            normalizedValues[componentName] = normalizedValue
        }

        guard let red = normalizedValues["red"],
              let green = normalizedValues["green"],
              let blue = normalizedValues["blue"]
        else {
            return nil
        }

        let alpha = normalizedValues["alpha"] ?? 1.0

        self.init(
            colorSpace: colorSpace,
            components: [red, green, blue, alpha],
            count: 4
        )
    }
}
