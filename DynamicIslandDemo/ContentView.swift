import SwiftUI

struct ContentView: View {
    @StateObject private var activityManager = LiveActivityManager()

    var body: some View {
        NavigationStack {
            DeliveryView(activityManager: activityManager)
                .navigationTitle("Dynamic Island Demo")
        }
    }
}

#Preview {
    ContentView()
}
