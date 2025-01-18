import SwiftUI

struct EmptyStateDS: View {

    let text: String

    var body: some View {
        VStack(spacing: Spacing.padding_2) {
            Image(systemName: "tray")
                .resizable()
                .frame(width: Size.iconLarge, height: Size.iconMedium)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.secondary)
            Text(text)
                .typography(.body1, color: .textSecondary)
                .lineSpacing(Spacing.padding_0_5)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    EmptyStateDS(text: "OOOOPS, There is nothing here!")
        .frame(width: 150)
        .padding(Spacing.padding_10)
        .background(Color.surfaceBackground)
}
