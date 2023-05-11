import SwiftUI

struct ContentView: View {
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

            Spacer()
        }
        .padding()
        .frame(minWidth: 320)
    }

    private var color: Color {
        Color(
            hue: hue,
            saturation: saturation,
            brightness: brightness,
            opacity: alpha
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 320, height: 480))
    }
}
