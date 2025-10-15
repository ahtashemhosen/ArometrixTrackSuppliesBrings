
import SwiftUI

@available(iOS 14.0, *)
struct IngredientListView: View {
    @EnvironmentObject var dataStore: PerfumeDataStore
    @State private var searchText: String = ""
    @State private var showingAddView = false

    var filteredIngredients: [Ingredient] {
        if searchText.isEmpty {
            return dataStore.ingredients
        } else {
            return dataStore.ingredients.filter { ingredient in
                ingredient.name.localizedCaseInsensitiveContains(searchText) ||
                ingredient.scentNote.localizedCaseInsensitiveContains(searchText) ||
                ingredient.supplierName.localizedCaseInsensitiveContains(searchText) ||
                ingredient.category.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
            VStack {
                IngredientSearchBarView(searchText: $searchText)
                    .padding(.bottom, 5)

                if filteredIngredients.isEmpty {
                    Spacer()
                    IngredientNoDataView()
                    Spacer()
                } else {
                    List {
                        ForEach(filteredIngredients) { ingredient in
                            NavigationLink(destination: IngredientDetailView(ingredient: ingredient)) {
                                IngredientListRowView(ingredient: ingredient)
                                    .padding(.vertical, 5)
                                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .listRowBackground(Color.clear)
                            }
                        }
                        .onDelete(perform: deleteIngredient)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Ingredients Inventory 🫙")
            .navigationBarItems(trailing:
                Button(action: { showingAddView = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(red: 0.6, green: 1.0, blue: 0.8))
                }
            )
            .sheet(isPresented: $showingAddView) {
                NavigationView {
                    IngredientAddView()
                        .environmentObject(dataStore)
                }
            }
        
    }

    func deleteIngredient(at offsets: IndexSet) {
        let ingredientsToDelete = offsets.map { filteredIngredients[$0] }
        for ingredient in ingredientsToDelete {
            if let index = dataStore.ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                dataStore.ingredients.remove(at: index)
            }
        }
    }
}
