import SwiftUI

struct RecentColors: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(
            keyPath: \SolidColor.timestamp,
            ascending: false
        )]
    )
    private var colors: FetchedResults<SolidColor>

    @State private var showingSavePopover = false

    var color: NSColor

    var body: some View {
        HStack {
            Button {
                showingSavePopover = true
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
            .popover(isPresented: $showingSavePopover) {
                SaveColorForm(color: color)
                    .frame(width: 200)
                    .padding()
            }

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
