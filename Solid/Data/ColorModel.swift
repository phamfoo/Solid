enum ColorModel: CaseIterable, Identifiable {
    case hsb
    case rgb
    case hsl

    var id: String {
        displayName
    }

    var displayName: String {
        switch self {
        case .hsb:
            return "HSB"
        case .rgb:
            return "RGB"
        case .hsl:
            return "HSL"
        }
    }
}
