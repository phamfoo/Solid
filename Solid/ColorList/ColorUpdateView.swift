import Defaults
import SwiftUI

struct ColorUpdateView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var moc
    @StateObject private var colorPublisher = ColorPublisher()
    @StateObject private var colorSampler = ColorSampler()
    @Default(.colorSpace) private var colorSpace
    @Default(.colorModel) private var colorModel

    @State private var colorName = ""
    var color: SolidColor

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("Color Name", text: $colorName)
                    .font(.title2)
                    .textFieldStyle(.plain)

                Button {
                    updateColor()
                } label: {
                    Image(systemName: "checkmark")
                        .imageScale(.large)
                }
                .buttonStyle(.solid)
                .disabled(!isValid)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            ColorEditorView(
                colorSpace: $colorSpace,
                colorModel: $colorModel,
                colorPublisher: colorPublisher
            )
            .environmentObject(colorPublisher)
            .environmentObject(colorSampler)
        }
        .padding(.bottom, 16)
        .onAppear {
            colorName = color.name ?? ""

            let nsColor = NSColor(
                colorSpace: ColorSpace(rawValue: color.colorSpace!)!
                    .nsColorSpace,
                hue: color.hue,
                saturation: color.saturation,
                brightness: color.brightness,
                alpha: color.alpha
            )

            colorPublisher.publish(nsColor, source: "Root")
        }
    }

    private var isValid: Bool {
        !colorName.isEmpty
    }

    private func updateColor() {
        color.name = colorName
        let newColor = colorPublisher.currentColor

        color.hue = newColor.hueComponent
        color.saturation = newColor.saturationComponent
        color.brightness = newColor.brightnessComponent
        color.alpha = newColor.alphaComponent

        try? moc.save()
        dismiss()
    }
}

struct ColorUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        let red = NSColor.red
        let color = SolidColor(
            context: PersistenceController.preview
                .container.viewContext
        )
        color.id = UUID()
        color.timestamp = Date()
        color.hue = red.hueComponent
        color.saturation = red.saturationComponent
        color.brightness = red.brightnessComponent
        color.alpha = red.alphaComponent
        color.colorSpace = ColorSpace.sRGB.rawValue

        return ColorUpdateView(color: color)
            .environmentObject(ColorPublisher())
            .environmentObject(ColorSampler())
            .frame(width: 320)
    }
}
