import SwiftUI

struct Editor: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(
            keyPath: \SolidColor.timestamp,
            ascending: false
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

                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(color)
                    .frame(width: 32, height: 32)
            }
            .padding(.horizontal)

            HStack {
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
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(.quaternary)
                        .overlay {
                            RoundedRectangle(
                                cornerRadius: 4,
                                style: .continuous
                            )
                            .strokeBorder()
                        }
                        .overlay {
                            Image(systemName: "plus")
                        }
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.plain)

                ForEach(colors) { color in
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(
                            Color(
                                hue: color.hue,
                                saturation: color.saturation,
                                brightness: color.brightness,
                                opacity: color.alpha
                            )
                        )
                        .frame(width: 32, height: 32)
                }

                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 32)

            Spacer()
        }
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
            .previewLayout(.fixed(width: 320, height: 480))
            .environment(
                \.managedObjectContext,
                PersistenceController.preview.container.viewContext
            )
    }
}
