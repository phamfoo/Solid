import SwiftUI

struct SaveColorButton: View {
    @State private var isShowingSaveColorForm = false
    var color: NSColor
    var colorSpace: ColorSpace

    var body: some View {
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

struct SaveColorButton_Previews: PreviewProvider {
    static var previews: some View {
        SaveColorButton(color: .red, colorSpace: .sRGB)
    }
}
