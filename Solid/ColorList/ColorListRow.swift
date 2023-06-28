import Defaults
import SwiftUI

struct ColorListRow: View {
    @Environment(\.managedObjectContext) private var moc
    @State private var isEditing = false
    @State private var isShowingDeleteConfirmation = false

    var color: SolidColor
    @Default(.includeHashPrefix) private var includeHashPrefix
    @Default(.lowerCaseHex) private var lowerCaseHex

    var body: some View {
        _ColorListRow(
            color: nsColor,
            name: color.name ?? "",
            hexString: hexString
        )
        .contextMenu {
            Button {
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(hexString, forType: .string)
            } label: {
                // Label doesn't show the icon for some reason
                Image(systemName: "square.on.square")
                Text("Copy hex code")
            }

            Button {
                isEditing = true
            } label: {
                Image(systemName: "square.and.pencil")
                Text("Edit Color")
            }

            Divider()

            Button {
                isShowingDeleteConfirmation = true
            } label: {
                Image(systemName: "trash")
                Text("Delete color")
            }
        }
        .popover(isPresented: $isEditing) {
            ColorUpdateView(color: color)
                .frame(width: 320)
        }
        .confirmationDialog(
            "Are you sure you want to delete this color?",
            isPresented: $isShowingDeleteConfirmation
        ) {
            Button("Delete", role: .destructive) {
                moc.delete(color)
            }
        }
        .onDisappear {
            if color.isDeleted {
                try? moc.save()
            }
        }
    }

    private var nsColor: NSColor {
        NSColor(
            colorSpace: ColorSpace(rawValue: color.colorSpace!)!
                .nsColorSpace,
            hue: color.hue,
            saturation: color.saturation,
            brightness: color.brightness,
            alpha: color.alpha
        )
    }

    private var hexString: String {
        ColorFormatter.shared.hex(
            color: nsColor,
            includeHashPrefix: includeHashPrefix,
            lowerCaseHex: lowerCaseHex
        )
    }
}

struct _ColorListRow: View {
    var color: NSColor
    var name: String
    var hexString: String

    var body: some View {
        HStack {
            ColorSwatch(color: color)

            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)

                Text(hexString)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
    }
}

struct ColorListRow_Previews: PreviewProvider {
    static var previews: some View {
        _ColorListRow(
            color: .red,
            name: "red",
            hexString: "#000000"
        )
        .frame(width: 320)
    }
}
