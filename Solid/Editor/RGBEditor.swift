import SwiftUI

struct RGBEditor: View {
    @Binding var colorSpace: ColorSpace
    @Binding var colorModel: ColorModel
    var colorPublisher: ColorPublisher

    @State private var hue: Double
    @State private var saturation: Double
    @State private var brightness: Double
    @State private var alpha: Double

    init(
        colorSpace: Binding<ColorSpace>,
        colorModel: Binding<ColorModel>,
        colorPublisher: ColorPublisher
    ) {
        _colorSpace = colorSpace
        _colorModel = colorModel
        self.colorPublisher = colorPublisher

        let color = colorPublisher.value.color
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
            .frame(minWidth: 320, minHeight: 320)

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
            colorPublisher.send(.init(color: nsColor, source: "RGBEditor"))
        }
        .onReceive(
            colorPublisher
                .filter { $0.source != "RGBEditor" }
        ) { publishedColor in
            syncComponents(from: publishedColor.color)
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
            nsColor.redComponent
        } set: { newValue in
            let newColor = NSColor(
                colorSpace: colorSpace.nsColorSpace,
                components: [
                    newValue,
                    nsColor.greenComponent,
                    nsColor.blueComponent,
                    nsColor.alphaComponent,
                ],
                count: 4
            )
            syncComponents(from: newColor)
        }
    }

    private var green: Binding<Double> {
        .init {
            nsColor.greenComponent
        } set: { newValue in

            let newColor = NSColor(
                colorSpace: colorSpace.nsColorSpace,
                components: [
                    nsColor.redComponent,
                    newValue,
                    nsColor.blueComponent,
                    nsColor.alphaComponent,
                ],
                count: 4
            )
            syncComponents(from: newColor)
        }
    }

    private var blue: Binding<Double> {
        .init {
            nsColor.blueComponent
        } set: { newValue in
            let newColor = NSColor(
                colorSpace: colorSpace.nsColorSpace,
                components: [
                    nsColor.redComponent,
                    nsColor.greenComponent,
                    newValue,
                    nsColor.alphaComponent,
                ],
                count: 4
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
            colorPublisher: .init(.init(color: .red, source: ""))
        )
        .frame(width: 320)
    }
}
