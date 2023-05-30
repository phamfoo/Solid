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
                HStack(spacing: 0) {
                    Color(nsColor: color.withAlphaComponent(1))
                    Color(nsColor: color)
                }
                .background {
                    CheckerBoardBackground(numberOfRows: 8)
                }
                .frame(width: 44, height: 44)
                .drawingGroup()
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 6,
                        style: .continuous
                    )
                )

                HexInput(hexString: hexString) { hexString in
                    if let color = NSColor(
                        colorSpace: colorSpace
                            .nsColorSpace,
                        hexString: hexString
                    ) {
                        colorPublisher.publish(
                            color,
                            source: "HexInput"
                        )
                    }
                }

                HStack(spacing: 0) {
                    Button {
                        let pasteboard = NSPasteboard.general
                        pasteboard.clearContents()
                        pasteboard.setString(hexString, forType: .string)
                    } label: {
                        Image(systemName: "square.on.square")
                            .imageScale(.large)
                    }
                    .buttonStyle(.solid)

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
        let color = colorPublisher.currentColor

        return ColorFormatter.shared.hex(
            color: color,
            includeHashPrefix: includeHashPrefix,
            lowerCaseHex: lowerCaseHex
        )
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
