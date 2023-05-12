import SwiftUI

struct Editor: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(
            keyPath: \SolidColor.timestamp,
            ascending: true
        )]
    )
    private var colors: FetchedResults<SolidColor>

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
                ForEach(colors) { color in
                    Color(
                        hue: color.hue,
                        saturation: color.saturation,
                        brightness: color.brightness,
                        opacity: color.alpha
                    )
                    .frame(width: 32, height: 32)
                }

                Button {
                    let solidColor = SolidColor(context: moc)
                    solidColor.id = UUID()
                    solidColor.hue = nsColor.hueComponent
                    solidColor.saturation = nsColor.saturationComponent
                    solidColor.brightness = nsColor.brightnessComponent
                    solidColor.alpha = nsColor.alphaComponent
                    solidColor.timestamp = .now

                    try? moc.save()
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
        Editor()
            .previewLayout(.fixed(width: 320, height: 480))
            .environment(
                \.managedObjectContext,
                PersistenceController.preview.container.viewContext
            )
    }
}
