import Combine
import SwiftUI

typealias ColorPublisher = CurrentValueSubject<
    ColorUpdate,
    Never
>

struct Editor: View {
    @State private var colorSpace = ColorSpace.sRGB
    @State private var colorModel = ColorModel.hsb
    @State private var colorPublisher =
        ColorPublisher(.init(color: .red, source: "Root"))

    var body: some View {
        VStack(spacing: 0) {
            switch colorModel {
            case .hsb:
                HSBEditor(
                    colorSpace: $colorSpace,
                    colorModel: $colorModel,
                    colorPublisher: colorPublisher
                )
            case .rgb:
                RGBEditor(
                    colorSpace: $colorSpace,
                    colorModel: $colorModel,
                    colorPublisher: colorPublisher
                )
            case .hsl:
                HSLEditor(
                    colorSpace: $colorSpace,
                    colorModel: $colorModel,
                    colorPublisher: colorPublisher
                )
            }

            Divider()
                .padding(.vertical)

            ColorInfo(colorPublisher: colorPublisher, colorSpace: colorSpace)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)

            Spacer()
        }
    }
}

struct ColorUpdate {
    var color: NSColor
    var source: String
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
