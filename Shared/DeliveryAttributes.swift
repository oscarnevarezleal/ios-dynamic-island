import ActivityKit
import Foundation

/// Defines the data model for the pizza delivery Live Activity.
/// This file has target membership in both the main app and the widget extension.
struct DeliveryAttributes: ActivityAttributes {

    // MARK: - Content State (dynamic, updatable data)

    struct ContentState: Codable, Hashable {
        var status: DeliveryStatus
        var estimatedDeliveryTime: Date
        var driverName: String
    }

    // MARK: - Static Data (set once at activity start)

    var orderNumber: String
    var restaurantName: String
}

// MARK: - Delivery Status

enum DeliveryStatus: String, Codable, Hashable, CaseIterable {
    case preparing
    case inOven
    case outForDelivery
    case nearYou
    case delivered

    var displayName: String {
        switch self {
        case .preparing:      return "Preparing Order"
        case .inOven:         return "In the Oven"
        case .outForDelivery: return "Out for Delivery"
        case .nearYou:        return "Almost There!"
        case .delivered:      return "Delivered"
        }
    }

    var systemImage: String {
        switch self {
        case .preparing:      return "frying.pan.fill"
        case .inOven:         return "oven.fill"
        case .outForDelivery: return "car.fill"
        case .nearYou:        return "mappin.and.ellipse"
        case .delivered:      return "checkmark.circle.fill"
        }
    }

    /// Returns the next status in the delivery flow, or nil if already delivered.
    var next: DeliveryStatus? {
        let all = DeliveryStatus.allCases
        guard let index = all.firstIndex(of: self),
              index + 1 < all.count else { return nil }
        return all[index + 1]
    }
}
