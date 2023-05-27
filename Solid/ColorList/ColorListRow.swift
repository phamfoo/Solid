import Defaults
import SwiftUI

struct ColorListRow: View {
    var color: SolidColor

    var body: some View {
        _ColorListRow(
            color: NSColor(
                colorSpace: ColorSpace(rawValue: color.colorSpace!)!
                    .nsColorSpace,
                hue: color.hue,
                saturation: color.saturation,
                brightness: color.brightness,
                alpha: color.alpha
            ),
            name: color.name ?? ""
        )
    }
}

struct _ColorListRow: View {
    @Default(.includeHashPrefix) private var includeHashPrefix
    @Default(.lowerCaseHex) private var lowerCaseHex

    var color: NSColor
    var name: String

    @State private var isHovered = false

    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(Color(nsColor: color))
                .frame(width: 44, height: 44)

            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)

                Text(hexString)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if isHovered {
                Button {
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(hexString, forType: .string)
                } label: {
                    Image(systemName: "square.on.square")
                }
                .buttonStyle(.solid)
            }
        }
        .onHover { isHovered in
            self.isHovered = isHovered
        }
    }

    private var hexString: String {
        ColorFormatter.shared.hex(
            color: color,
            includeHashPrefix: includeHashPrefix,
            lowerCaseHex: lowerCaseHex
        )
    }
}

struct ColorListRow_Previews: PreviewProvider {
    static var previews: some View {
        _ColorListRow(
            color: .red,
            name: "red"
        )
        .frame(width: 320)
    }
}
