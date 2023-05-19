import SwiftUI

struct ColorProfileSupportDetail: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Image("ChromaticityDiagram")

            Text(
                """
                The app currently supports only the **sRGB** color profile, which is the standard used by most digital displays, web browsers, and image editing software.

                Support for more color profiles will be added in future updates.
                """
            )
            .padding(.top, 24)

            Button("Got it!") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 24)
        }
        .frame(width: 360)
        .padding(24)
        .fixedSize()
    }
}

struct ColorProfileSupportDetail_Previews: PreviewProvider {
    static var previews: some View {
        ColorProfileSupportDetail()
    }
}
