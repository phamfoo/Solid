import Combine
import Defaults
import SwiftUI

typealias ColorPublisher = CurrentValueSubject<
    ColorUpdate,
    Never
>

struct Editor: View {
    @FocusState private var focused: Bool

    @State private var colorSpace = ColorSpace.sRGB
    @Default(.colorModel) private var colorModel
    @State private var colorPublisher =
        ColorPublisher(.init(color: Defaults[.color], source: "Root"))

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
        .focused($focused)
        .contentShape(Rectangle())
        .onTapGesture {
            focused = false
        }
        .onReceive(
            NotificationCenter.default
                .publisher(for: NSApplication.willResignActiveNotification)
        ) { _ in
            Defaults[.color] = colorPublisher.value.color
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
