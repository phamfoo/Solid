import Defaults
import SwiftUI

struct HexInput: View {
    @State private var isHovered = false
    @FocusState private var isFocused: Bool
    @State private var inputValue = ""

    var hexString: String
    var onSubmit: (String) -> Void

    var body: some View {
        HStack {
            TextField("Hex code", text: $inputValue)
                .focused($isFocused)
                .allowsHitTesting(isFocused)
                .foregroundColor(isFocused ? .primary : .secondary)
                .font(isFocused ? .body : .body.weight(.medium))
                .textFieldStyle(.plain)
                .onAppear {
                    inputValue = hexString
                }
                .onChange(of: hexString) { newValue in
                    inputValue = newValue
                }
                .onChange(of: isFocused) { _ in
                    inputValue = hexString
                }
                .onExitCommand {
                    isFocused = false
                }
                .onSubmit {
                    isFocused = false
                    onSubmit(inputValue)
                }
            Spacer()

            if isFocused {
                Button {
                    isFocused = false
                    onSubmit(inputValue)
                } label: {
                    Image(systemName: "checkmark")
                }
                .buttonStyle(.solid)
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .leading
        )
        .padding(.horizontal, 8)
        .background {
            RoundedRectangle(
                cornerRadius: 6,
                style: .continuous
            )
            .strokeBorder(.quaternary)
            .opacity(isHovered && !isFocused ? 1 : 0)
        }
        .background {
            RoundedRectangle(
                cornerRadius: 6,
                style: .continuous
            )
            .strokeBorder(Color.accentColor)
            .scaleEffect(isFocused ? 1 : 1.05)
            .opacity(isFocused ? 1 : 0)
        }
        .onHover { isHovered in
            self.isHovered = isHovered
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = true
        }
        .animation(.easeOut(duration: 0.1), value: isHovered)
        .animation(.easeOut(duration: 0.1), value: isFocused)
    }
}

struct HexInput_Previews: PreviewProvider {
    static var previews: some View {
        HexInput(hexString: "#000000", onSubmit: { _ in })
            .previewLayout(.fixed(width: 320, height: 40))
    }
}
