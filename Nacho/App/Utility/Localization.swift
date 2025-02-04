import Foundation

enum Localization {

    // Common
    static let buttonStart = "button_start".localized
    static let fairMint = "fair_mint".localized
    static let preMint = "pre_mint".localized
    static let premintedText = "preminted_text".localized
    static let mintedText = "minted_text".localized
    static let tradeText = "trade_text".localized
    static let holdersText = "holders_text".localized
    static let topHoldersText = "top_holders_text".localized
    static let mintProgressText = "mint_progress_text".localized
    static let searchTokensPlaceholder = "search_tokens_placeholder".localized
    static let buttonAddressText = "button_address_text".localized
    static let tokenSelectionTitle = "token_selection_title".localized
    static let buttonCompare = "button_compare".localized
    static let addressCopyMessage = "address_copy_message".localized
    static let buttonConfirm = "button_confirm".localized
    static let buttonAddAddress = "button_add_address".localized
    static let buttonDelete = "button_delete".localized
    static let buttonEdit = "button_edit".localized

    // Welcome
    static let welcomeTitle = "welcome_title".localized
    static let welcomeSubtitle = "welcome_subtitle".localized
    static let welcomeDescription = "welcome_description".localized

    // Tabs
    static let tabHome = "tab_home".localized
    static let tabScan = "tab_scan".localized
    static let tabPool = "tab_pool".localized
    static let tabBot = "tab_bot".localized
    static let tabNFTs = "tab_nfts".localized

    // Home
    static let homeNavigationTitle = "home_navigation_title".localized

    // Wallets
    static let walletsTitle = "wallets_title".localized
    static let walletsTagsTokens = "wallets_tags_tokens".localized
    static let walletsTagsNfts = "wallets_tags_nfts".localized
    static let walletsTagsMiners = "wallets_tags_miners".localized
    static let walletsTagsNone = "wallets_tags_none".localized
    static let walletTagsCaption = "wallets_tags_caption".localized
    static let walletsEmptyTitle = "wallets_empty_title".localized
    static let walletsEmptyDescription = "wallets_empty_description".localized

    // Widgets
    static let widgetPriceTitle = "widget_price_title".localized
    static let widgetMCTitle = "widget_mc_title".localized
    static let widgetVolumeTitle = "widget_volume_title".localized
    static let widgetChartTitle = "widget_chart_title".localized
    static let widgetDeployed = "widget_deployed".localized
    static let widgetSupply = "widget_supply".localized
    static let widgetTotalMints = "widget_total_mints".localized
    
    // Mintint
    static let mintHeatmapTitle = "mint_heatmap_title".localized
    static let mintHeatmapButtonText = "mint_heatmap_button_text".localized

    // Address
    static let addressInfoTitle = "address_info_title".localized
    static let addressInfoTextInputPlaceholder = "address_info_text_input_placeholder".localized
    static let addressInfoTokensTitle = "address_info_tokes_title".localized

    // Compare tokens
    static let compareTokensTitle = "compare_tokens_title".localized
    static let compareTokensButtonSelect1 = "compare_tokens_button_select_1".localized
    static let compareTokensButtonSelect2 = "compare_tokens_button_select_2".localized

    // Kasplex
    static let kasplexInfoButton = "kasplex_info_button".localized
    static let kasplexInfoTitle = "kasplex_info_title".localized
    static let kasplexInfoTotalTransactions = "kasplex_info_total_transactions".localized
    static let kasplexInfoTokensDeployed = "kasplex_info_tokens_deployed".localized
    static let kasplexInfoFeesPaid = "kasplex_info_fees_paid".localized

    // Kat Pool
    static let katPoolTitle = "kat_pool_title".localized
    static let katPoolBlocks = "kat_pool_blocks".localized
    static let katPoolBlocks24h = "kat_pool_blocks_24h".localized
    static let katPoolMinersTitle = "kat_pool_miners_title".localized
    static let katPoolHashrateTitle = "kat_pool_hashrate_title".localized
    static let katPoolPayoutsTitle = "kat_pool_payouts_title".localized
    static let katPoolRecentPayoutsTitle = "kat_pool_recent_payouts_title".localized

    // NFTs
    static let nftsTitle = "nfts_title".localized
    static let nftsGameTitle = "nfts_game_title".localized
    static let nftsButtonPlayAgain = "nfts_button_play_again".localized

    // Edge Cases
    static let emptyTokensText = "empty_tokens_text".localized
    static let emptyTokensSelectionText = "empty_tokens_selection_text".localized
    static let emptyViewText = "empty_view_text".localized
}

extension String {

    var localized: String {
        return NSLocalizedString(self, comment: "\(self)_comment")
    }

    func localized(_ args: [CVarArg]) -> String {
        return String(format: localized, args)
    }

    func localized(_ args: CVarArg...) -> String {
        return String(format: localized, args)
    }
}
