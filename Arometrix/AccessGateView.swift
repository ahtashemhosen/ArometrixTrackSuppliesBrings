
import SwiftUI

@available(iOS 14.0, *)
struct AccessGateView: View {
    
    @StateObject private var gateController = GateAccessManager()
    @State private var activeURL: URL?
    @State private var busy = true
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            if activeURL == nil && !busy {
                PerfumeDashboardView().ignoresSafeArea()
            }
            if let url = activeURL {
                PortalContainerView(url: url, loading: $busy)
                    .edgesIgnoringSafeArea(.all)
                    .statusBar(hidden: true)
            }
            if busy {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.8)
                    )
            }
        }
        .onReceive(gateController.$state) { state in
            switch state {
            case .validating:
                busy = true
            case .authorized(_, let url):
                activeURL = url
                busy = false
            case .fallback:
                activeURL = nil
                busy = false
            case .idle:
                break
            }
        }
        .onAppear {
            busy = true
            gateController.beginAccess()
        }
    }
}
