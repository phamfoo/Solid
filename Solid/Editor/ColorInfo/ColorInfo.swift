import SwiftUI

struct ColorInfo: View {
    @State private var isShowingSaveColorForm = false

    var color: NSColor
    var colorSpace: ColorSpace

    var body: some View {
        VStack(alignment: .leading) {
            CurrentColorProfile()

            HStack {
                HStack(spacing: 0) {
                    Color(nsColor: color.withAlphaComponent(1))
                    Color(nsColor: color)
                }
                .background {
                    CheckerBoardBackground(numberOfRows: 8)
                }
                .frame(width: 44, height: 44)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 6,
                        style: .continuous
                    )
                )

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
                        isShowingSaveColorForm = true
                    } label: {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                    .buttonStyle(.solid)
                    .popover(isPresented: $isShowingSaveColorForm) {
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
}

struct ColorInfo_Previews: PreviewProvider {
    static var previews: some View {
        ColorInfo(color: .red.withAlphaComponent(0.5), colorSpace: .sRGB)
            .frame(width: 320)
    }
}
