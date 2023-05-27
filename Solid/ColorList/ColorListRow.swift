import Defaults
import SwiftUI

struct ColorListRow: View {
    var color: SolidColor
    @Default(.includeHashPrefix) private var includeHashPrefix
    @Default(.lowerCaseHex) private var lowerCaseHex

    var body: some View {
        _ColorListRow(
            color: nsColor,
            name: color.name ?? "",
            hexString: hexString
        )
        .contextMenu {
            Button {
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(hexString, forType: .string)
            } label: {
                Label("Copy hex code", systemImage: "square.on.square")
            }
        }
    }

    private var nsColor: NSColor {
        NSColor(
            colorSpace: ColorSpace(rawValue: color.colorSpace!)!
                .nsColorSpace,
            hue: color.hue,
            saturation: color.saturation,
            brightness: color.brightness,
            alpha: color.alpha
        )
    }

    private var hexString: String {
        ColorFormatter.shared.hex(
            color: nsColor,
            includeHashPrefix: includeHashPrefix,
            lowerCaseHex: lowerCaseHex
        )
    }
}

struct _ColorListRow: View {
    var color: NSColor
    var name: String
    var hexString: String

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
        }
    }
}

struct ColorListRow_Previews: PreviewProvider {
    static var previews: some View {
        _ColorListRow(
            color: .red,
            name: "red",
            hexString: "#000000"
        )
        .frame(width: 320)
    }
}
