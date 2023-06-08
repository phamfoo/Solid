import Combine
import Defaults
import SwiftUI

struct Editor: View {
    @FocusState private var isFocused: Bool

    @Default(.colorSpace) private var colorSpace
    @Default(.colorModel) private var colorModel
    @EnvironmentObject private var colorPublisher: ColorPublisher

    var body: some View {
        VStack(spacing: 0) {
            ColorEditorView(
                colorSpace: $colorSpace,
                colorModel: $colorModel,
                colorPublisher: colorPublisher
            )

            Divider()
                .padding(.vertical)

            ColorInfo(colorPublisher: colorPublisher, colorSpace: colorSpace)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)

            Spacer()
        }
        .focused($isFocused)
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = false
        }
        .onReceive(
            NotificationCenter.default
                .publisher(for: NSApplication.willResignActiveNotification)
        ) { _ in
            Defaults[.color] = colorPublisher.currentColor
        }
    }
}

struct Editor_Previews: PreviewProvider {
    static var previews: some View {
        Editor()
            .environmentObject(ColorPublisher())
            .environmentObject(ColorSampler())
            .frame(width: 320)
    }
}
