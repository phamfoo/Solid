import SwiftUI

struct CopyHexButton: View {
    @State private var isShowingHexCopiedIndicator = false

    var hexString: String

    var body: some View {
        Button {
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(hexString, forType: .string)
            isShowingHexCopiedIndicator = true

            DispatchQueue.main
                .asyncAfter(deadline: .now().advanced(by: .seconds(1))) {
                    isShowingHexCopiedIndicator = false
                }
        } label: {
            Image(systemName: "square.on.square")
                .imageScale(.large)
                .opacity(isShowingHexCopiedIndicator ? 0 : 1)
                .overlay {
                    Image(systemName: "checkmark")
                        .imageScale(.large)
                        .foregroundColor(.green)
                        .opacity(isShowingHexCopiedIndicator ? 1 : 0)
                }
        }
        .buttonStyle(.solid)
    }
}

struct CopyHexButton_Previews: PreviewProvider {
    static var previews: some View {
        CopyHexButton(hexString: "#00ff00")
    }
}
