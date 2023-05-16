import SwiftUI

struct Editor: View {
    @State private var colorModel = ColorModel.hsb

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
                    HueSlider(hue: $hue)
                        .frame(height: 18)

                    AlphaSlider(
                        alpha: $alpha,
                        fullyOpaqueColor: Color(
                            nsColor: color
                                .withAlphaComponent(1)
                        )
                    )
                    .frame(height: 18)
                }
                .labelsHidden()
            }
            .padding()

            HStack {
                Picker("Color Model", selection: $colorModel) {
                    ForEach(ColorModel.allCases) { colorModel in
                        Text(colorModel.displayName)
                            .tag(colorModel)
                    }
                }
                .labelsHidden()
                .fixedSize()

                switch colorModel {
                case .hsb:
                    HSBAInputGroup(
                        hue: $hue,
                        saturation: $saturation,
                        brightness: $brightness,
                        alpha: $alpha
                    )
                case .rgb:
                    HStack {
                        NumberInput("R", normalizedValue: red, in: 0 ... 255)
                        NumberInput("G", normalizedValue: green, in: 0 ... 255)
                        NumberInput("B", normalizedValue: blue, in: 0 ... 255)

                        PercentageInput("A", normalizedValue: $alpha)
                    }
                    .textFieldStyle(.plain)
                }
            }
            .padding(.horizontal)

            VStack(alignment: .leading) {
                Text("Output")
                    .font(.headline)
                    .foregroundColor(.secondary)

                ColorOutput(color: color)
            }
            .padding(.horizontal)
            .padding(.top, 16)

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

private enum ColorModel: CaseIterable, Identifiable {
    case hsb
    case rgb

    var id: String {
        displayName
    }

    var displayName: String {
        switch self {
        case .hsb:
            return "HSB"
        case .rgb:
            return "RGB"
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
