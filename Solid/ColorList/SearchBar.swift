import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    isFocused ? Color.primary : Color
                        .secondary
                )

            TextField("Search", text: $text)
                .focused($isFocused)
                .textFieldStyle(.plain)
                .onSubmit {
                    isFocused = false
                }

            if !text.isEmpty {
                Button {
                    text = ""
                    isFocused = false
                } label: {
                    Image(systemName: "x.circle.fill")
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .onTapGesture {
            isFocused = true
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant("red"))
            .frame(width: 320)
    }
}
