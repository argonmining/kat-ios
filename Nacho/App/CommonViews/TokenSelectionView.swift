import SwiftUI

struct TokenSelectionView: View {

    let tokens: [String]
    let selectedToken: String?
    let onSelectedAction: (String) -> Void
    @State private var searchText: String = ""
    @State private var filteredTokens: [String]

    init(
        tokens: [String],
        selectedToken: String?,
        onSelectedAction: @escaping (String) -> Void
    ) {
        self.tokens = tokens
        self.selectedToken = selectedToken
        self.onSelectedAction = onSelectedAction
        self.filteredTokens = tokens
    }

    var body: some View {
        Group {
            if filteredTokens.isEmpty {
                VStack {
                    Spacer()
                    EmptyStateDS(text: Localization.emptyTokensSelectionText)
                        .padding(.horizontal, Spacing.padding_10)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: Spacing.padding_2) {
                        if filteredTokens.isEmpty {
                            
                        } else {
                            ForEach(filteredTokens, id: \.self) { token in
                                item(text: token, isSelected: (selectedToken ?? "") == token)
                                    .onTapGesture {
                                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                        onSelectedAction(token)
                                    }
                            }
                        }
                        Spacer()
                    }
                    .padding(Spacing.padding_2)
                }
            }
        }
        .navigationTitle(Localization.tokenSelectionTitle)
        .background(Color.surfaceBackground.ignoresSafeArea())
        .searchable(
            text: $searchText,
            prompt: Localization.searchTokensPlaceholder
        )
        .onChange(of: searchText) { _, newValue in
            if newValue.isEmpty {
                filteredTokens = tokens
            } else {
                filteredTokens = tokens.filter {
                    $0.lowercased().contains(newValue.lowercased())
                }
            }
        }
    }

    private func item(text: String, isSelected: Bool) -> some View {
        Group {
            HStack {
                TokenImage(text)
                Text(text).typography(.body1)
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
                .stroke(isSelected ? .surfaceAccent : .surfaceForeground, lineWidth: 1)
        )
    }
}

#Preview {
    NavigationView {
        TokenSelectionView(
            tokens: ["NACHO", "KASPER", "KANGO"],
            selectedToken: "KASPER"
        ) { _ in }
    }
}
