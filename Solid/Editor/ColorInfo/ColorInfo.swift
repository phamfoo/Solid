import Combine
import Defaults
import SwiftUI

struct ColorInfo: View {
    var colorPublisher: ColorPublisher
    var colorSpace: ColorSpace
    @State private var color: NSColor
    @Default(.includeHashPrefix) private var includeHashPrefix
    @Default(.lowerCaseHex) private var lowerCaseHex

    init(colorPublisher: ColorPublisher, colorSpace: ColorSpace) {
        self.colorPublisher = colorPublisher
        self.colorSpace = colorSpace
        _color = State(wrappedValue: colorPublisher.currentColor)
    }

    var body: some View {
        VStack(alignment: .leading) {
            CurrentColorProfile()

            HStack {
                ColorSwatch(color: color)

                HexInput(hexString: hexString) { newValue in
                    if let color = parseColorString(newValue) {
                        colorPublisher.publish(
                            color,
                            source: "HexInput"
                        )
                    }
                }

                HStack(spacing: 0) {
                    CopyHexButton(hexString: hexString)

                    SaveColorButton(color: color, colorSpace: colorSpace)
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .onReceive(colorPublisher.updates()) { publishedColor in
            self.color = publishedColor.color
        }
    }

    private var hexString: String {
        return ColorFormatter.shared.hex(
            color: color,
            includeHashPrefix: includeHashPrefix,
            lowerCaseHex: lowerCaseHex
        )
    }

    private func parseColorString(_ string: String) -> NSColor? {
        NSColor(
            colorSpace: colorSpace
                .nsColorSpace,
            hexString: string
        )
            ?? NSColor(cssNamedColor: string)
    }
}

struct ColorInfo_Previews: PreviewProvider {
    static var previews: some View {
        ColorInfo(
            colorPublisher: ColorPublisher(),
            colorSpace: .sRGB
        )
        .frame(width: 320)
    }
}
