import SwiftUI

struct PillDS: View {

    private let text: String
    private let style: Style
    private let color: Color
    private let iconName: String?

    init(
        text: String,
        style: Style = .small,
        color: Color = .solidSuccess,
        iconName: String? = nil
    ) {
        self.text = text
        self.style = style
        self.color = color
        self.iconName = iconName
    }

    var body: some View {
        HStack(spacing: Spacing.padding_0_2_5) {
            if let iconName {
                Image(systemName: iconName)
                    .typography(textStyle, color: .textOnSolid)
            }
            Text(text)
                .typography(textStyle, color: .textOnSolid)
        }
        .padding(.vertical, Spacing.padding_0_2_5)
        .padding(.horizontal, horizontalSpacing)
        .background(
            RoundedRectangle(cornerRadius: Radius.radius_1)
                .fill(color)
        )
    }

    private var textStyle: Typography.Style {
        switch style {
        case .small: return .caption2
        case .medium: return .caption
        case .large: return .body1
        }
    }

    private var horizontalSpacing: CGFloat {
        switch style {
        case .small: return Spacing.padding_0_5
        case .medium: return Spacing.padding_0_7_5
        case .large: return Spacing.padding_1
        }
    }
}

extension PillDS {

    enum Style {
        case small
        case medium
        case large
    }
}

#Preview {
    VStack {
        Spacer()
        HStack {
            Spacer()
            PillDS(text: "FAIR MINT", style: .large, iconName: "lock.fill")
            PillDS(text: "FAIR MINT", style: .medium, iconName: "lock.fill")
            PillDS(text: "FAIR MINT", style: .small, iconName: "lock.fill")
            Spacer()
        }
        HStack {
            Spacer()
            PillDS(text: "FAIR MINT", style: .large, color: .solidDanger)
            PillDS(text: "FAIR MINT", style: .medium, color: .solidDanger)
            PillDS(text: "FAIR MINT", style: .small, color: .solidDanger)
            Spacer()
        }
        HStack {
            Spacer()
            PillDS(text: "FAIR MINT", style: .large, color: .solidWarning)
            PillDS(text: "FAIR MINT", style: .medium, color: .solidWarning)
            PillDS(text: "FAIR MINT", style: .small, color: .solidWarning)
            Spacer()
        }
        HStack {
            Spacer()
            PillDS(text: "FAIR MINT", style: .large, color: .solidInfo)
            PillDS(text: "FAIR MINT", style: .medium, color: .solidInfo)
            PillDS(text: "FAIR MINT", style: .small, color: .solidInfo)
            Spacer()
        }
        Spacer()
    }
    .background(Color.surfaceBackground)
}
