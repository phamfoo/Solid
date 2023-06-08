import SwiftUI

struct SaveColorForm: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var moc
    @State private var colorName = ""

    var color: NSColor
    var colorSpace: ColorSpace

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(Color(nsColor: color))
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: .infinity)

            TextField("Name", text: $colorName)

            Button("Save") {
                let solidColor = SolidColor(context: moc)
                solidColor.id = UUID()
                solidColor.name = colorName
                solidColor.colorSpace = colorSpace.rawValue
                solidColor.hue = color.hueComponent
                solidColor.saturation = color.saturationComponent
                solidColor.brightness = color.brightnessComponent
                solidColor.alpha = color.alphaComponent
                solidColor.timestamp = .now

                try? moc.save()

                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .onAppear {
            colorName = generateColorName()
        }
    }

    private func generateColorName() -> String {
        var closestDistance = Double.infinity
        var closestColorName = ""

        for (colorName, _) in CSSColors.namedColors {
            let cssColor = NSColor(cssNamedColor: colorName)!
            // We don't need the real distance so I'm skipping sqrt
            let distance = pow(color.redComponent - cssColor.redComponent, 2)
                + pow(color.greenComponent - cssColor.greenComponent, 2)
                + pow(color.blueComponent - cssColor.blueComponent, 2)

            if distance < closestDistance {
                closestColorName = colorName
                closestDistance = distance
            }
        }

        return closestColorName
    }
}

struct SaveColorForm_Previews: PreviewProvider {
    static var previews: some View {
        SaveColorForm(color: .red, colorSpace: .sRGB)
            .frame(width: 200)
    }
}
