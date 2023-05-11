import SwiftUI

struct Editor: View {
    @Binding var colors: [NSColor]

    @State private var hue = 1.0
    @State private var saturation = 1.0
    @State private var brightness = 1.0
    @State private var alpha = 1.0

    var body: some View {
        VStack {
            SaturationBrightnessSlider(
                saturation: $saturation,
                brightness: $brightness
            )
            .aspectRatio(1, contentMode: .fit)

            HStack {
                Button {
                    NSColorSampler()
                        .show { pickedColor in
                            if let pickedColor {
                                hue = pickedColor.hueComponent
                                saturation = pickedColor.saturationComponent
                                brightness = pickedColor.brightnessComponent
                                alpha = pickedColor.alphaComponent
                            }
                        }
                } label: {
                    Image(systemName: "eyedropper")
                        .imageScale(.large)
                }

                VStack {
                    Slider(value: $hue) {
                        Text("H")
                    }

                    Slider(value: $alpha) {
                        Text("A")
                    }
                }

                color
                    .frame(width: 32, height: 32)
            }

            HStack {
                ForEach(colors, id: \.self) { color in
                    Color(nsColor: color)
                        .frame(width: 32, height: 32)
                }

                Button {
                    colors.append(nsColor)
                } label: {
                    Rectangle()
                        .fill(.quaternary)
                        .overlay {
                            Rectangle()
                                .strokeBorder()
                        }
                        .overlay {
                            Image(systemName: "plus")
                        }
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding(.top, 32)

            Spacer()
        }
        .padding()
    }

    private var color: Color {
        Color(nsColor: nsColor)
    }

    private var nsColor: NSColor {
        NSColor(
            hue: hue,
            saturation: saturation,
            brightness: brightness,
            alpha: alpha
        )
    }
}

struct Editor_Previews: PreviewProvider {
    static var previews: some View {
        Editor(colors: .constant([.red, .green, .blue]))
            .previewLayout(.fixed(width: 320, height: 480))
    }
}
