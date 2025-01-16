import SwiftUI

struct ShareLinkDS: View {

    var image: UIImage
    var title: String
    var buttonText: String

    var body: some View {
        ShareLink(
            item:Image(uiImage: image)
                .interpolation(.none)
                .resizable(),
            preview: SharePreview(
                title,
                image: Image(uiImage: image)
                    .interpolation(.none)
                    .resizable()
            )
        ) {
            HStack(alignment: .center, spacing: Spacing.padding_1) {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .scaledToFit()
                    .frame(height: Constants.iconHeight)
                Text(buttonText)
                    
            }
            .typography(.button, color: .textPrimary)
            .padding(.vertical, Spacing.padding_2)
            .padding(.horizontal, Spacing.padding_3)
            .frame(height: Constants.buttonHeight)
            .frame(maxWidth: .infinity)
            .background(.clear)
            .cornerRadius(Radius.radius_3)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.radius_3)
                    .stroke(
                        Color.borderRegularPrimary,
                        lineWidth: 1
                    )
            )
            .contentShape(Rectangle())
        }
    }
}

private extension ShareLinkDS {
    enum Constants {
        static let iconHeight: CGFloat = 18
        static let buttonHeight: CGFloat = 40
    }
}

#Preview {
    ShareLinkDS(
        image: UIImage(systemName: "square.and.arrow.up")!,
        title: "QR Code",
        buttonText: "Share"
    )
    .padding()
}
