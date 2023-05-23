import Defaults
import AppKit

extension Defaults.Keys {
    static let colorModel = Key<ColorModel>("colorModel", default: .hsb)
    static let color = Key<NSColor>("color", default: .red)
}

extension ColorModel: Defaults.Serializable {}
