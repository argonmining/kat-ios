//import Charts
//import SwiftUI
//
//struct DashboardView: View {
//
//    @State private var viewModel: DashboardViewModel = .init()
//
//    var body: some View {
//        VStack {
//            Text("Title").typography(.headline1)
//
//            WidgetDS {
//                VStack {
//                    HStack {
//                        Text("Recent rewards").typography(.subtitle)
//                        Spacer()
//                    }
//                    Divider()
//                        .padding(.vertical, Spacing.padding_1)
//                    HStack(alignment: .lastTextBaseline) {
//                        Text(viewModel.balance).typography(.headline2)
//                        Text("KAS").typography(.body1)
//                        Spacer()
//                    }
//                    .padding(.bottom, Spacing.padding_2)
//                    HStack {
//                        Text("Recent payouts".uppercased()).typography(.body2, color: .textSecondary)
//                        Spacer()
//                        Text("Reward".uppercased()).typography(.body2, color: .textSecondary)
//                    }
//                    .padding(.bottom, Spacing.padding_1)
//                    VStack {
//                        ForEach(viewModel.payouts, id: \.transactionHash) { payout in
//                            HStack {
//                                Text(hoursAgo(from: payout.timestamp))
//                                    .typography(.body1, color: .textSecondary)
//                                Text(payout.transactionHash.truncatedMiddle(to: 12))
//                                    .typography(.body1, color: .textSecondary)
//                                    .padding(.vertical, Spacing.padding_0_2_5)
//                                    .padding(.horizontal, Spacing.padding_1)
//                                    .background(Color.surfaceBackground)
//                                    .cornerRadius(16)
//                                Spacer()
//                                HStack(alignment: .lastTextBaseline, spacing: Spacing.padding_0_5) {
//                                    Text("\(String(format: "%.2f", payout.amount))")
//                                        .typography(.body1)
//                                    Text("KAS")
//                                        .typography(.caption2)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            .padding(Spacing.padding_2)
//
//            WidgetDS {
//                Chart {
//                    ForEach(viewModel.dailySharesData, id: \.date) { entry in
//                        BarMark(
//                            x: .value("Day", entry.date, unit: .day),
//                            y: .value("Shares", entry.totalShares)
//                        )
//                        .foregroundStyle(Color.textAccent)
//                    }
//                }
//                .chartYAxis {
//                    AxisMarks(position: .leading)
//                }
//                .frame(height: 200)
//            }
//            .padding(Spacing.padding_2)
//
//            Spacer()
//        }
//        .background(Color.surfaceBackground.ignoresSafeArea())
//        .task {
//            do {
//                viewModel.metricsData = try await viewModel.fetchMinerBalance(wallet: viewModel.walletAddress)
//                    .data
//                viewModel.payouts = try await viewModel.fetchPoolPayouts()
//                    .data.filter {
//                        $0.walletAddress == viewModel.walletAddress
//                    }
//                viewModel.dailySharesData = try await viewModel.fetchSharesHistory(wallet: viewModel.walletAddress)
//            } catch {
//                print(error)
//            }
//        }
//    }
//
//    private func formattedDate(from timestamp: Int) -> String {
//        let date = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000)
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        formatter.timeStyle = .short
//        return formatter.string(from: date)
//    }
//
//    private func hoursAgo(from timestamp: Int) -> String {
//        let payoutDate = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000)
//        let currentDate = Date()
//        let interval = currentDate.timeIntervalSince(payoutDate)
//        let hours = Int(interval / 3600)
//        return "\(hours) h ago"
//    }
//}
//
//#Preview {
//    DashboardView()
//}
