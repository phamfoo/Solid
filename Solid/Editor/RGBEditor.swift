import SwiftUI

struct RGBEditor: View {
    @Binding var colorSpace: ColorSpace
    @Binding var colorModel: ColorModel
    @Binding var color: NSColor

    @State private var hue: Double
    @State private var saturation: Double
    @State private var brightness: Double
    @State private var alpha: Double

    init(
        colorSpace: Binding<ColorSpace>,
        colorModel: Binding<ColorModel>,
        color: Binding<NSColor>
    ) {
        _colorSpace = colorSpace
        _colorModel = colorModel
        _color = color

        let color = _color.wrappedValue
        hue = color.hueComponent
        saturation = color.saturationComponent
        brightness = color.brightnessComponent
        alpha = color.alphaComponent
    }

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

                RGBAInputGroup(
                    red: red,
                    green: green,
                    blue: blue,
                    alpha: $alpha
                )
                .frame(maxHeight: .infinity)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 16)
        }
        .onChange(of: nsColor) { nsColor in
            color = nsColor
        }
    }

    private var nsColor: NSColor {
        NSColor(
            colorSpace: colorSpace.nsColorSpace,
            hue: hue,
            saturation: saturation,
            brightness: brightness,
            alpha: alpha
        )
    }

    private var fullyOpaqueColor: Color {
        Color(nsColor: nsColor.withAlphaComponent(1))
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

struct RGBEditor_Previews: PreviewProvider {
    static var previews: some View {
        RGBEditor(
            colorSpace: .constant(.sRGB),
            colorModel: .constant(.rgb),
            color: .constant(.red)
        )
        .frame(width: 320)
    }
}
