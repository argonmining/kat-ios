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

    // Welcome
    static let welcomeTitle = "welcome_title".localized
    static let welcomeSubtitle = "welcome_subtitle".localized
    static let welcomeDescription = "welcome_description".localized

    // Tabs
    static let tabHome = "tab_home".localized
    static let tabScan = "tab_scan".localized
    static let tabPool = "tab_pool".localized
    static let tabBot = "tab_bot".localized

    // Home
    static let homeNavigationTitle = "home_navigation_title".localized

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

    // Edge Cases
    static let emptyTokensText = "empty_tokens_text".localized
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
