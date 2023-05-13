import SwiftUI

struct ColorListItem: View {
    var color: SolidColor

    var body: some View {
        _ColorListItem(
            color: NSColor(
                hue: color.hue,
                saturation: color.saturation,
                brightness: color.brightness,
                alpha: color.alpha
            ),
            name: color.name ?? ""
        )
    }
}

struct _ColorListItem: View {
    var color: NSColor
    var name: String

    var body: some View {
        HStack {
            ColorSwatch(color: color)

            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)

                Text(hexString)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }

            Spacer()
        }
    }

    private var hexString: String {
        let red = Int((color.redComponent * 255).rounded())
        let green = Int((color.greenComponent * 255).rounded())
        let blue = Int((color.blueComponent * 255).rounded())

        return String(format: "#%02x%02x%02x", red, green, blue)
    }
}

struct ColorListItem_Previews: PreviewProvider {
    static var previews: some View {
        _ColorListItem(
            color: .red,
            name: "red"
        )
        .frame(width: 320)
    }
}
