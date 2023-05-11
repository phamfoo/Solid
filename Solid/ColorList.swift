import SwiftUI

struct ColorList: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(
            keyPath: \SolidColor.timestamp,
            ascending: true
        )]
    )
    private var colors: FetchedResults<SolidColor>

    var body: some View {
        List(colors) { color in
            let nsColor = NSColor(
                hue: color.hue,
                saturation: color.saturation,
                brightness: color.brightness,
                alpha: color.alpha
            )

            HStack {
                Color(nsColor: nsColor)
                    .frame(width: 32, height: 32)

                listItem(for: nsColor)
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
        ColorList()
            .previewLayout(.fixed(width: 320, height: 480))
            .environment(
                \.managedObjectContext,
                PersistenceController.preview.container.viewContext
            )
    }
}
