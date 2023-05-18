import SwiftUI

struct Editor: View {
    @State private var colorModel = ColorModel.hsb

    @State private var hue = 1.0
    @State private var saturation = 1.0
    @State private var brightness = 1.0
    @State private var alpha = 1.0

    var body: some View {
        VStack(spacing: 0) {
            SaturationBrightnessSlider(
                hue: hue,
                saturation: $saturation,
                brightness: $brightness
            )
            .aspectRatio(1, contentMode: .fit)

            HStack(spacing: 0) {
                ColorSampler { pickedColor in
                    syncComponents(from: pickedColor)
                }
                .padding(8)

                VStack {
                    HueSlider(hue: $hue)
                        .frame(height: 24)

                    AlphaSlider(
                        alpha: $alpha,
                        fullyOpaqueColor: Color(
                            nsColor: color
                                .withAlphaComponent(1)
                        )
                    )
                    .frame(height: 24)
                }
                .padding(8)
            }
            .padding(8)

            HStack {
                ColorModelPicker(colorModel: $colorModel)

                switch colorModel {
                case .hsb:
                    HSBAInputGroup(
                        hue: $hue,
                        saturation: $saturation,
                        brightness: $brightness,
                        alpha: $alpha
                    )
                    .frame(maxHeight: .infinity)
                case .rgb:
                    RGBAInputGroup(
                        red: red,
                        green: green,
                        blue: blue,
                        alpha: $alpha
                    )
                    .frame(maxHeight: .infinity)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 16)

            Divider()
                .padding(.vertical)

            VStack(alignment: .leading) {
                Text("Output")
                    .font(.headline)
                    .foregroundColor(.secondary)

                ColorOutput(color: color)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)

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

    private var red: Binding<Double> {
        .init {
            color.redComponent
        } set: { newValue in
            let newColor = NSColor(
                red: newValue,
                green: color.greenComponent,
                blue: color.blueComponent,
                alpha: color.alphaComponent
            )
            syncComponents(from: newColor)
        }
    }

    private var green: Binding<Double> {
        .init {
            color.greenComponent
        } set: { newValue in
            let newColor = NSColor(
                red: color.redComponent,
                green: newValue,
                blue: color.blueComponent,
                alpha: color.alphaComponent
            )
            syncComponents(from: newColor)
        }
    }

    private var blue: Binding<Double> {
        .init {
            color.blueComponent
        } set: { newValue in
            let newColor = NSColor(
                red: color.redComponent,
                green: color.greenComponent,
                blue: newValue,
                alpha: color.alphaComponent
            )
            syncComponents(from: newColor)
        }
    }
}

struct Editor_Previews: PreviewProvider {
    static var previews: some View {
        Editor()
            .previewLayout(.fixed(width: 320, height: 640))
            .environment(
                \.managedObjectContext,
                PersistenceController.preview.container.viewContext
            )
    }
}