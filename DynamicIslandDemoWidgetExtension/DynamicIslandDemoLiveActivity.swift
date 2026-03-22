import ActivityKit
import WidgetKit
import SwiftUI

struct DynamicIslandDemoLiveActivity: Widget {

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DeliveryAttributes.self) { context in
            // MARK: - Lock Screen / Banner UI
            lockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // MARK: - Expanded Regions
                DynamicIslandExpandedRegion(.leading) {
                    expandedLeading(context: context)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    expandedTrailing(context: context)
                }
                DynamicIslandExpandedRegion(.center) {
                    expandedCenter(context: context)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    expandedBottom(context: context)
                }
            } compactLeading: {
                // MARK: - Compact Leading
                Image(systemName: context.state.status.systemImage)
                    .foregroundStyle(.orange)
            } compactTrailing: {
                // MARK: - Compact Trailing
                Text(context.state.estimatedDeliveryTime, style: .timer)
                    .frame(width: 56)
                    .monospacedDigit()
                    .font(.caption2)
            } minimal: {
                // MARK: - Minimal (when multiple Live Activities)
                Image(systemName: context.state.status.systemImage)
                    .foregroundStyle(.orange)
            }
        }
    }

    // MARK: - Lock Screen View

    @ViewBuilder
    private func lockScreenView(context: ActivityViewContext<DeliveryAttributes>) -> some View {
        HStack(spacing: 16) {
            Image(systemName: context.state.status.systemImage)
                .font(.title)
                .foregroundStyle(.orange)
                .frame(width: 44)

            VStack(alignment: .leading, spacing: 4) {
                Text(context.attributes.restaurantName)
                    .font(.headline)
                Text(context.state.status.displayName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("ETA")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(context.state.estimatedDeliveryTime, style: .timer)
                    .font(.subheadline)
                    .monospacedDigit()
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
    }

    // MARK: - Expanded Dynamic Island

    @ViewBuilder
    private func expandedLeading(context: ActivityViewContext<DeliveryAttributes>) -> some View {
        VStack(alignment: .leading) {
            Image(systemName: context.state.status.systemImage)
                .font(.title2)
                .foregroundStyle(.orange)
        }
    }

    @ViewBuilder
    private func expandedTrailing(context: ActivityViewContext<DeliveryAttributes>) -> some View {
        VStack(alignment: .trailing) {
            Text(context.state.estimatedDeliveryTime, style: .timer)
                .monospacedDigit()
                .font(.callout)
                .fontWeight(.semibold)
            Text("ETA")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private func expandedCenter(context: ActivityViewContext<DeliveryAttributes>) -> some View {
        VStack(spacing: 2) {
            Text(context.state.status.displayName)
                .font(.headline)
            Text(context.attributes.restaurantName)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private func expandedBottom(context: ActivityViewContext<DeliveryAttributes>) -> some View {
        // Delivery progress bar
        DeliveryProgressView(status: context.state.status)
    }
}

// MARK: - Delivery Progress View

struct DeliveryProgressView: View {
    let status: DeliveryStatus

    private var progress: Double {
        let allCases = DeliveryStatus.allCases
        guard let index = allCases.firstIndex(of: status) else { return 0 }
        return Double(index) / Double(allCases.count - 1)
    }

    var body: some View {
        VStack(spacing: 6) {
            ProgressView(value: progress)
                .tint(.orange)

            HStack {
                ForEach(DeliveryStatus.allCases, id: \.self) { step in
                    Image(systemName: step.systemImage)
                        .font(.caption2)
                        .foregroundStyle(stepColor(for: step))
                    if step != DeliveryStatus.allCases.last {
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal, 4)
    }

    private func stepColor(for step: DeliveryStatus) -> Color {
        let allCases = DeliveryStatus.allCases
        guard let currentIndex = allCases.firstIndex(of: status),
              let stepIndex = allCases.firstIndex(of: step) else { return .secondary }
        return stepIndex <= currentIndex ? .orange : .secondary
    }
}
