import SwiftUI

struct ColorOutput: View {
    var color: NSColor

    var body: some View {
        HStack {
            ColorSwatch(color: color)
            Text(color.hexString)

            Spacer()
        }
    }
}

struct ColorOutput_Previews: PreviewProvider {
    static var previews: some View {
        ColorOutput(color: .red)
            .frame(width: 320)
    }
}
