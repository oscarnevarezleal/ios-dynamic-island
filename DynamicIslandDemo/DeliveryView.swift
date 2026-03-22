import SwiftUI
import ActivityKit

struct DeliveryView: View {
    @ObservedObject var activityManager: LiveActivityManager

    var body: some View {
        VStack(spacing: 24) {
            headerSection
            statusSection
            controlButtons
            Spacer()
        }
        .padding()
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "shippingbox.fill")
                .font(.system(size: 60))
                .foregroundStyle(.blue)

            Text("Pizza Delivery Tracker")
                .font(.title2)
                .fontWeight(.bold)

            Text("Start a Live Activity to track your delivery on the Dynamic Island and Lock Screen.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }

    // MARK: - Status

    private var statusSection: some View {
        Group {
            if activityManager.isActivityActive {
                VStack(spacing: 12) {
                    Label("Live Activity Running", systemImage: "livephoto")
                        .font(.headline)
                        .foregroundStyle(.green)

                    Text("Current Status: \(activityManager.currentStatus.displayName)")
                        .font(.subheadline)

                    if let estimatedDelivery = activityManager.estimatedDeliveryTime {
                        Text("Estimated delivery: \(estimatedDelivery, style: .timer)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    // MARK: - Controls

    private var controlButtons: some View {
        VStack(spacing: 12) {
            if !activityManager.isActivityActive {
                Button {
                    activityManager.startDeliveryActivity()
                } label: {
                    Label("Start Delivery Tracking", systemImage: "play.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            } else {
                Button {
                    activityManager.advanceStatus()
                } label: {
                    Label("Advance to Next Status", systemImage: "forward.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Button(role: .destructive) {
                    activityManager.endDeliveryActivity()
                } label: {
                    Label("End Delivery", systemImage: "stop.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
        }
    }
}

#Preview {
    DeliveryView(activityManager: LiveActivityManager())
}
