import SwiftUI

struct IconButtonDS: View {

    let iconName: String
    let text: String
    var action: () -> Void

    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            action()
        }) {
            VStack(spacing: Spacing.padding_0_5) {
                Image(systemName: iconName)
                    .resizable()
                    .frame(width: Size.iconSmall, height: Size.iconSmall)
                    .foregroundStyle(Color.textPrimary)
                Text(text)
                    .typography(.body2, color: .textPrimary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(IconButtonStyle())
    }
}

struct IconButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .toneStyle(configuration.isPressed ? .disabled : .idle)
            .padding(.vertical, Spacing.padding_1_5)
            .padding(.horizontal, Spacing.padding_1)
            .background(
                RoundedRectangle(cornerRadius: Radius.radius_2)
                    .foregroundColor(.surfaceBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Radius.radius_2)
                    .stroke(.borderRegularPrimary, lineWidth: 2)
            )
            .contentShape(Rectangle())
    }
}

#Preview {
    IconButtonDS(
        iconName: "chart.bar.xaxis.ascending.badge.clock",
        text: "Mint Map"
    ) { }
}
