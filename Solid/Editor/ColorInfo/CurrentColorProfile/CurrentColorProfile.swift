import SwiftUI

struct CurrentColorProfile: View {
    @State private var isShowingDetail = false

    var body: some View {
        Button {
            isShowingDetail = true
        } label: {
            HStack(spacing: 2) {
                Text("sRGB")
                    .font(.headline)

                Image(systemName: "questionmark.circle.fill")
                    .imageScale(.small)
            }
        }
        .buttonStyle(.link)
        .sheet(isPresented: $isShowingDetail) {
            ColorProfileSupportDetail()
        }
    }
}

struct CurrentColorProfile_Previews: PreviewProvider {
    static var previews: some View {
        CurrentColorProfile()
    }
}
