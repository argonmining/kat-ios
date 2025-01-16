extension String {
    /// Truncates the middle of a string to fit within a given length.
    /// - Parameters:
    ///   - maxLength: The maximum length of the truncated string, including the ellipsis.
    ///   - ellipsis: The string to use for truncation (default is "...").
    /// - Returns: A truncated string with the middle replaced by the ellipsis if needed.
    func truncatedMiddle(to maxLength: Int, with ellipsis: String = "...") -> String {
        guard self.count > maxLength else { return self }

        let keepLength = (maxLength - ellipsis.count) / 2
        let start = self.prefix(keepLength)
        let end = self.suffix(keepLength)
        
        return "\(start)\(ellipsis)\(end)"
    }
}
