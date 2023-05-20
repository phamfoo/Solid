import Combine
import SwiftUI

struct ColorInfo: View {
    var colorPublisher: ColorPublisher
    var colorSpace: ColorSpace
    @State private var color: NSColor?

    var body: some View {
        let color = self.color ?? colorPublisher.value.color

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

                Text(color.hexString)

                Spacer()

                HStack(spacing: 0) {
                    Button {
                        let pasteboard = NSPasteboard.general
                        pasteboard.clearContents()
                        pasteboard.setString(color.hexString, forType: .string)
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
                                colorPublisher
                                    .send(
                                        .init(
                                            color: color,
                                            source: "Clipboard"
                                        )
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
        .onReceive(colorPublisher) { publishedColor in
            self.color = publishedColor.color
        }
    }
}

struct ColorInfo_Previews: PreviewProvider {
    static var previews: some View {
        ColorInfo(
            colorPublisher: .init(.init(color: .red, source: "")),
            colorSpace: .sRGB
        )
        .frame(width: 320)
    }
}
