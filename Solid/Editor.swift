import SwiftUI

struct Editor: View {
    @State private var hue = 1.0
    @State private var saturation = 1.0
    @State private var brightness = 1.0
    @State private var alpha = 1.0

    var body: some View {
        VStack {
            SaturationBrightnessSlider(
                hue: hue,
                saturation: $saturation,
                brightness: $brightness
            )
            .aspectRatio(1, contentMode: .fit)

            HStack {
                ColorSampler { pickedColor in
                    syncComponents(from: pickedColor)
                }

                VStack {
                    Slider(value: $hue) {
                        Text("Hue")
                    }

                    Slider(value: $alpha) {
                        Text("Alpha")
                    }
                }
                .labelsHidden()
            }
            .padding(.horizontal)

            VStack(alignment: .leading) {
                Text("Output")
                    .font(.headline)
                    .foregroundColor(.secondary)

                ColorOutput(color: color)
            }
            .padding(.horizontal)

            RecentColors(color: color)
                .padding(.horizontal)
                .padding(.top, 32)

            Spacer()
        }
    }

    private var color: NSColor {
        NSColor(
            hue: hue,
            saturation: saturation,
            brightness: brightness,
            alpha: alpha
        )
    }

    private func syncComponents(from color: NSColor) {
        hue = color.hueComponent
        saturation = color.saturationComponent
        brightness = color.brightnessComponent
        alpha = color.alphaComponent
    }
}

struct Editor_Previews: PreviewProvider {
    static var previews: some View {
        Editor()
            .previewLayout(.fixed(width: 320, height: 540))
            .environment(
                \.managedObjectContext,
                PersistenceController.preview.container.viewContext
            )
    }
}
