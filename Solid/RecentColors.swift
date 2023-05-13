import SwiftUI

struct RecentColors: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(
            keyPath: \SolidColor.timestamp,
            ascending: false
        )]
    )
    private var colors: FetchedResults<SolidColor>
    
    var color: NSColor

    var body: some View {
        HStack {
            Button {
                let solidColor = SolidColor(context: moc)
                solidColor.id = UUID()
                solidColor.hue = color.hueComponent
                solidColor.saturation = color.saturationComponent
                solidColor.brightness = color.brightnessComponent
                solidColor.alpha = color.alphaComponent
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
    }
}

struct RecentColors_Previews: PreviewProvider {
    static var previews: some View {
        RecentColors(color: .red)
            .frame(width: 320)
    }
}
