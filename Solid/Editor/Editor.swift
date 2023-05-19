import SwiftUI

struct Editor: View {
    @State private var colorSpace = ColorSpace.sRGB
    @State private var colorModel = ColorModel.hsb
    @State private var color = NSColor.red

    var body: some View {
        VStack(spacing: 0) {
            switch colorModel {
            case .hsb:
                HSBEditor(
                    colorSpace: $colorSpace,
                    colorModel: $colorModel,
                    color: $color
                )
            case .rgb:
                RGBEditor(
                    colorSpace: $colorSpace,
                    colorModel: $colorModel,
                    color: $color
                )
            case .hsl:
                HSLEditor(
                    colorSpace: $colorSpace,
                    colorModel: $colorModel,
                    color: $color
                )
            }

            Divider()
                .padding(.vertical)

            ColorInfo(color: color, colorSpace: colorSpace)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)

            Spacer()
        }
    }
}

struct Editor_Previews: PreviewProvider {
    static var previews: some View {
        Editor()
            .previewLayout(.fixed(width: 320, height: 640))
            .environment(
                \.managedObjectContext,
                PersistenceController.preview.container.viewContext
            )
    }
}
