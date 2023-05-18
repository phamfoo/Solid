import SwiftUI

struct SaveColorForm: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var moc
    @State private var colorName = "New color"

    var color: NSColor

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
    }
}

struct SaveColorForm_Previews: PreviewProvider {
    static var previews: some View {
        SaveColorForm(color: .red)
            .frame(width: 200)
    }
}
