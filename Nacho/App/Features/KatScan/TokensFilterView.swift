import SwiftUI

struct TokensFilterView: View {

    @Binding var filterState: TokensFilterState

    var body: some View {
        VStack(spacing: Spacing.padding_2) {
            ForEach(TokensFilterState.allCases, id: \.self) { state in
                item(text: state.displayName, isSelected: filterState == state)
                    .onTapGesture {
                        filterState = state
                    }
            }
            Spacer()
        }
        .padding(Spacing.padding_2)
        .padding(.top, Spacing.padding_3)
        .background(Color.surfaceBackground.ignoresSafeArea())
    }

    private func item(text: String, isSelected: Bool) -> some View {
        VStack {
            HStack {
                Image(systemName: isSelected ? "circle.circle.fill" : "circle")
                    .resizable()
                    .frame(width: Size.iconSmall, height: Size.iconSmall)
                Text(text).typography(.subtitle)
                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Radius.radius_3)
                .foregroundColor(isSelected ? .surfaceForeground : .surfaceBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Radius.radius_3)
                .stroke(.surfaceForeground, lineWidth: 2)
        )
    }
}

#Preview {
    TokensFilterView(filterState: .constant(.none))
}
