import SwiftUI

struct ColorOutput: View {
    var color: NSColor

    var body: some View {
        HStack {
            ColorSwatch(color: color)
            Text(color.hexString)

            Spacer()

            Button {
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(color.hexString, forType: .string)
            } label: {
                Image(systemName: "square.on.square")
                    .imageScale(.large)
            }
            .buttonStyle(.plain)
        }
    }
}

struct ColorOutput_Previews: PreviewProvider {
    static var previews: some View {
        ColorOutput(color: .red)
            .frame(width: 320)
    }
}
