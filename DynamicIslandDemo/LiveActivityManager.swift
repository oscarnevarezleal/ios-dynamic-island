import ActivityKit
import Foundation

/// Manages the lifecycle of the delivery Live Activity — start, update, and end.
@MainActor
final class LiveActivityManager: ObservableObject {

    @Published private(set) var isActivityActive = false
    @Published private(set) var currentStatus: DeliveryStatus = .preparing
    @Published private(set) var estimatedDeliveryTime: Date?

    private var currentActivity: Activity<DeliveryAttributes>?

    // MARK: - Start

    func startDeliveryActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live Activities are not enabled.")
            return
        }

        let estimatedTime = Date().addingTimeInterval(30 * 60) // 30 minutes
        let initialStatus = DeliveryStatus.preparing

        let attributes = DeliveryAttributes(
            orderNumber: "#\(Int.random(in: 1000...9999))",
            restaurantName: "Mario's Pizza"
        )

        let state = DeliveryAttributes.ContentState(
            status: initialStatus,
            estimatedDeliveryTime: estimatedTime,
            driverName: "Marco"
        )

        do {
            let activity = try Activity<DeliveryAttributes>.request(
                attributes: attributes,
                content: .init(state: state, staleDate: nil),
                pushType: nil
            )
            currentActivity = activity
            currentStatus = initialStatus
            estimatedDeliveryTime = estimatedTime
            isActivityActive = true
            print("Started Live Activity: \(activity.id)")
        } catch {
            print("Failed to start Live Activity: \(error.localizedDescription)")
        }
    }

    // MARK: - Update (advance status)

    func advanceStatus() {
        guard let next = currentStatus.next else {
            endDeliveryActivity()
            return
        }

        currentStatus = next

        let updatedState = DeliveryAttributes.ContentState(
            status: next,
            estimatedDeliveryTime: estimatedDeliveryTime ?? Date(),
            driverName: "Marco"
        )

        Task {
            await currentActivity?.update(
                ActivityContent(state: updatedState, staleDate: nil)
            )
        }
    }

    // MARK: - End

    func endDeliveryActivity() {
        let finalState = DeliveryAttributes.ContentState(
            status: .delivered,
            estimatedDeliveryTime: Date(),
            driverName: "Marco"
        )

        Task {
            await currentActivity?.end(
                ActivityContent(state: finalState, staleDate: nil),
                dismissalPolicy: .default
            )
            currentActivity = nil
            currentStatus = .preparing
            estimatedDeliveryTime = nil
            isActivityActive = false
        }
    }
}
