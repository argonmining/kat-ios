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
    static let mintProgressText = "mint_progress_text".localized
    static let searchTokensPlaceholder = "search_tokens_placeholder".localized

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
    static let homeWidgetDeployed = "home_widget_deployed".localized
    static let homeWidgetSupply = "home_widget_supply".localized
    static let homeWidgetTotalMints = "home_widget_total_mints".localized

    // Widgets
    static let widgetPriceTitle = "widget_price_title".localized
    static let widgetMCTitle = "widget_mc_title".localized
    static let widgetVolumeTitle = "widget_volume_title".localized
    static let widgetChartTitle = "widget_chart_title".localized
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
