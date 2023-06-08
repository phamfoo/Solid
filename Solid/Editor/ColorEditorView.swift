import Defaults
import SwiftUI

struct ColorEditorView: View {
    @Binding var colorSpace: ColorSpace
    @Binding var colorModel: ColorModel
    var colorPublisher: ColorPublisher

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
        }
    }
}

struct ColorEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ColorEditorView(
            colorSpace: .constant(.sRGB),
            colorModel: .constant(.hsb),
            colorPublisher: ColorPublisher()
        )
        .frame(width: 320)
    }
}
