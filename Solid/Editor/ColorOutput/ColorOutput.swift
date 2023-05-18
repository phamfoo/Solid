import SwiftUI

struct ColorOutput: View {
    @State private var showingSavePopover = false
    var color: NSColor
    var colorSpace: ColorSpace

    var body: some View {
        HStack {
            HStack(spacing: 0) {
                Color(nsColor: color.withAlphaComponent(1))
                Color(nsColor: color)
            }
            .background {
                CheckerBoardBackground(numberOfRows: 8)
            }
            .frame(width: 44, height: 44)
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))

            Text(color.hexString)

            Spacer()

            HStack(spacing: 0) {
                Button {
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(color.hexString, forType: .string)
                } label: {
                    Image(systemName: "square.on.square")
                        .imageScale(.large)
                }
                .buttonStyle(.solid)

                Button {
                    showingSavePopover = true
                } label: {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
                .buttonStyle(.solid)
                .popover(isPresented: $showingSavePopover) {
                    SaveColorForm(
                        color: color,
                        colorSpace: colorSpace
                    )
                    .frame(width: 200)
                    .padding()
                }
            }
        }
    }
}

struct ColorOutput_Previews: PreviewProvider {
    static var previews: some View {
        ColorOutput(color: .red.withAlphaComponent(0.5), colorSpace: .sRGB)
            .frame(width: 320)
    }
}
