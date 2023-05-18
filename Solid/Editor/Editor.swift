import SwiftUI

struct Editor: View {
    @State private var colorSpace = ColorSpace.sRGB
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
                brightness: $brightness,
                colorSpace: colorSpace
            )
            .aspectRatio(1, contentMode: .fit)

            HStack(spacing: 0) {
                ColorSampler { pickedColor in
                    if let pickedColorInCurrentColorSpace =
                        pickedColor.usingColorSpace(colorSpace.nsColorSpace)
                    {
                        syncComponents(from: pickedColorInCurrentColorSpace)
                    }
                }
                .padding(8)

                VStack {
                    HueSlider(hue: $hue, colorSpace: colorSpace)
                        .frame(height: 24)

                    AlphaSlider(
                        alpha: $alpha,
                        color: fullyOpaqueColor
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
                Button {} label: {
                    HStack(spacing: 2) {
                        Text("sRGB")
                            .font(.headline)

                        Image(systemName: "questionmark.circle.fill")
                            .imageScale(.small)
                    }
                }
                .buttonStyle(.link)

                ColorOutput(color: color)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)

            Spacer()
        }
    }

    private var color: NSColor {
        NSColor(
            colorSpace: colorSpace.nsColorSpace,
            hue: hue,
            saturation: saturation,
            brightness: brightness,
            alpha: alpha
        )
    }

    private var fullyOpaqueColor: Color {
        Color(nsColor: color.withAlphaComponent(1))
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

enum ColorSpace {
    case sRGB
    case displayP3

    var nsColorSpace: NSColorSpace {
        switch self {
        case .sRGB:
            return .sRGB
        case .displayP3:
            return .displayP3
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
