enum TokensFilterState: CaseIterable {
    case none
    case fairMint
    case preMint
    case mintInProgress

    var displayName: String {
        switch self {
        case .none: return "All"
        case .fairMint: return "Fairly Minted"
        case .preMint: return "Pre-Minted"
        case .mintInProgress: return "Mint in Progress"
        }
    }
}
