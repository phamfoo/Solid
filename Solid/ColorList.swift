import SwiftUI

struct ColorList: View {
    @Binding var colors: [NSColor]

    var body: some View {
        List(colors, id: \.self) { color in
            HStack {
                Color(nsColor: color)
                    .frame(width: 32, height: 32)

                listItem(for: color)
            }
        }
    }

    private func listItem(for color: NSColor) -> some View {
        let red = Int((color.redComponent * 255).rounded())
        let green = Int((color.greenComponent * 255).rounded())
        let blue = Int((color.blueComponent * 255).rounded())

        let hexString = String(format: "#%02x%02x%02x", red, green, blue)

        return Text(hexString)
            .foregroundColor(.secondary)
    }
}

struct ColorList_Previews: PreviewProvider {
    static var previews: some View {
        ColorList(colors: .constant([.red, .green, .blue]))
            .previewLayout(.fixed(width: 320, height: 480))
    }
}
