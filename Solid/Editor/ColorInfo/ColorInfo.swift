import Combine
import Defaults
import SwiftUI

struct ColorInfo: View {
    var colorPublisher: ColorPublisher
    var colorSpace: ColorSpace
    @State private var color: NSColor?
    @Default(.includeHashPrefix) private var includeHashPrefix
    @Default(.lowerCaseHex) private var lowerCaseHex

    var body: some View {
        let color = self.color ?? colorPublisher.currentColor

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

                Text(hexString)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)

                Spacer()

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

                    Menu {
                        Button("Import from clipboard") {
                            if let copiedString = NSPasteboard.general
                                .string(forType: .string),
                                let color = NSColor(
                                    colorSpace: colorSpace.nsColorSpace,
                                    hexString: copiedString
                                )
                            {
                                colorPublisher.publish(
                                    color,
                                    source: "Clipboard"
                                )
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .imageScale(.large)
                    }
                    .fixedSize()
                    .menuStyle(.borderlessButton)
                    .menuIndicator(.hidden)
                }
            }
        }
        .onReceive(colorPublisher.updates()) { publishedColor in
            self.color = publishedColor.color
        }
    }

    private var hexString: String {
        let color = self.color ?? colorPublisher.currentColor
        let prefix = includeHashPrefix ? "#" : ""

        let hex = (prefix + color.hexString)

        if lowerCaseHex {
            return hex
        } else {
            return hex.uppercased()
        }
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
