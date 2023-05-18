import AppKit

enum ColorSpace: String {
    case sRGB
    case displayP3

    var nsColorSpace: NSColorSpace {
        switch self {
        case .sRGB:
            return .sRGB
        case .displayP3:
            return .displayP3
        }
    }
}
