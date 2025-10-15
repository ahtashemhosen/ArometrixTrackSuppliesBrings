
import SwiftUI

@available(iOS 14.0, *)
struct PerfumeDashboardView: View {
    
    @StateObject private var dataStore = PerfumeDataStore()
    @Namespace private var animation
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Arometrix")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Creative Dashboard")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(LinearGradient(
                        gradient: Gradient(colors: [Color.purple, Color.pink]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing))
                    .cornerRadius(25)
                    .shadow(radius: 6)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    VStack {
                        
                        dashboardCard(title: "Ingredients",
                                      icon: "leaf.fill",
                                      color1: Color(red: 0.0, green: 0.6, blue: 0.2),   // green
                                      color2: Color(red: 0.6, green: 1.0, blue: 0.8),   // mint-like
                                      count: dataStore.ingredients.count) {
                            IngredientListView()
                                .environmentObject(dataStore)
                        }
                        
                        dashboardCard(title: "Recipes",
                                      icon: "flame.fill",
                                      color1: Color(red: 1.0, green: 0.5, blue: 0.0),   // orange
                                      color2: Color(red: 1.0, green: 0.4, blue: 0.6),   // pink-like
                                      count: dataStore.recipes.count) {
                            PerfumeRecipeListView()
                                .environmentObject(dataStore)
                        }
                        
                        dashboardCard(title: "Production",
                                      icon: "cube.box.fill",
                                      color1: Color(red: 0.0, green: 0.4, blue: 1.0),   // blue
                                      color2: Color(red: 0.3, green: 0.9, blue: 1.0),   // cyan-like
                                      count: dataStore.productionRecords.count) {
                            ProductionRecordListView()
                                .environmentObject(dataStore)
                        }
                        
                        dashboardCard(title: "Workers",
                                      icon: "person.3.fill",
                                      color1: Color(red: 0.6, green: 0.2, blue: 0.8),   // purple
                                      color2: Color(red: 0.3, green: 0.3, blue: 0.9),   // indigo-like
                                      count: dataStore.workers.count) {
                            WorkerListView()
                                .environmentObject(dataStore)
                        }
                        
                        dashboardCard(title: "Supplies",
                                      icon: "shippingbox.fill",
                                      color1: Color(red: 0.0, green: 0.6, blue: 0.6),   // teal-like
                                      color2: Color(red: 0.0, green: 0.5, blue: 0.2),   // green-like
                                      count: dataStore.supplies.count) {
                            SupplyListView()
                                .environmentObject(dataStore)
                        }
                        
                        dashboardCard(title: "History",
                                      icon: "clock.arrow.circlepath",
                                      color1: Color(red: 0.5, green: 0.5, blue: 0.5),   // gray
                                      color2: Color(red: 0.0, green: 0.3, blue: 0.8),   // blue-like
                                      count: dataStore.histories.count) {
                            HistoryListView()
                                .environmentObject(dataStore)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)

                }
            }
            .navigationBarHidden(true)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
    
    @ViewBuilder
    private func dashboardCard<Destination: View>(
        title: String,
        icon: String,
        color1: Color,
        color2: Color,
        count: Int,
        destination: @escaping () -> Destination
    ) -> some View {
        NavigationLink(destination: destination()) {
            HStack(spacing: 10) {
                
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .matchedGeometryEffect(id: icon, in: animation)
                    .padding(.top, 8)
                
                    .padding(.leading)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("\(count) items")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                
                Spacer(minLength: 10)
            }
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(LinearGradient(
                gradient: Gradient(colors: [color1, color2]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing))
            .cornerRadius(22)
            .shadow(color: color1.opacity(0.4), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

