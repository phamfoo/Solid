import SwiftUI

struct ContentView: View {
    @State private var color = Color.red

    var body: some View {
        VStack {
            Button {
                NSColorSampler()
                    .show { pickedColor in
                        if let pickedColor {
                            color = Color(nsColor: pickedColor)
                        }
                    }
            } label: {
                Image(systemName: "eyedropper")
                    .imageScale(.large)
            }

            color
                .frame(width: 32, height: 32)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
