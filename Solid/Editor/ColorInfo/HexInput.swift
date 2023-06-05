import Defaults
import SwiftUI

struct HexInput: View {
    @State private var isHovered = false
    @FocusState private var isFocused: Bool
    @State private var isEditing = false
    @State private var inputValue = ""

    var hexString: String
    var onSubmit: (String) -> Void

    var body: some View {
        HStack {
            Group {
                if isEditing {
                    TextField("Hex code", text: $inputValue)
                        .focused($isFocused)
                        .textFieldStyle(.plain)
                        .onAppear {
                            isFocused = true
                            inputValue = hexString
                        }
                } else {
                    Text(hexString)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            if isEditing {
                Button {
                    stopEditing()
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
        .padding(.horizontal, 6)
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
            startEditing()
        }
        .onExitCommand {
            stopEditing()
        }
        .onSubmit {
            stopEditing()
            onSubmit(inputValue)
        }
        .onChange(of: isFocused) { newValue in
            isEditing = newValue
        }
        .animation(.easeInOut(duration: 0.1), value: isHovered)
        .animation(.easeInOut(duration: 0.1), value: isFocused)
    }

    private func startEditing() {
        isEditing = true
        isFocused = true
    }

    private func stopEditing() {
        isFocused = false
        isEditing = false
    }
}

struct HexInput_Previews: PreviewProvider {
    static var previews: some View {
        HexInput(hexString: "#000000", onSubmit: { _ in })
            .previewLayout(.fixed(width: 320, height: 40))
    }
}
