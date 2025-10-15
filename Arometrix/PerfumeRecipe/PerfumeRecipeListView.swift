
import SwiftUI
import Combine

@available(iOS 14.0, *)
fileprivate extension Color {
    static let customTeal = Color(red: 0.0, green: 0.5, blue: 0.5)
    static let customBrown = Color(red: 0.65, green: 0.16, blue: 0.16)
}

@available(iOS 14.0, *)
fileprivate struct PerfumeRecipeAddSectionHeaderView: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.customMint)
                .font(.headline)
            Text(title)
                .font(.headline)
                .fontWeight(.medium)
            Spacer()
        }
        .padding(.top, 10)
        .padding(.horizontal)
        .background(Color(.systemBackground))
    }
}

@available(iOS 14.0, *)
fileprivate struct PerfumeRecipeAddFieldView: View {
    let title: String
    let iconName: String
    @Binding var text: String
    var isRequired: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.gray)
                    .frame(width: 20)
                TextField("", text: $text)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal)
            .padding(.vertical, 15)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .overlay(
                Text(title + (isRequired ? "*" : ""))
                    .foregroundColor(text.isEmpty ? .gray : .customMint)
                    .offset(y: -25)
                    .scaleEffect(0.8, anchor: .leading)
                    .padding(.horizontal, 40)
                    .animation(.spring(), value: text.isEmpty)
                , alignment: .leading
            )
        }
    }
}

@available(iOS 14.0, *)
fileprivate struct PerfumeRecipeAddDoubleFieldView: View {
    let title: String
    let iconName: String
    @Binding var value: Double?
    
    var body: some View {
        PerfumeRecipeAddFieldView(
            title: title,
            iconName: iconName,
            text: Binding(
                get: {
                    if let value = value {
                        return String(format: "%.2f", value)
                    }
                    return ""
                },
                set: {
                    value = Double($0)
                }
            )
        )
    }
}

@available(iOS 14.0, *)
fileprivate struct PerfumeRecipeAddIntFieldView: View {
    let title: String
    let iconName: String
    @Binding var value: Int?
    
    var body: some View {
        PerfumeRecipeAddFieldView(
            title: title,
            iconName: iconName,
            text: Binding(
                get: {
                    if let value = value {
                        return String(value)
                    }
                    return ""
                },
                set: {
                    value = Int($0)
                }
            )
        )
    }
}

@available(iOS 14.0, *)
fileprivate struct PerfumeRecipeAddToggleView: View {
    let title: String
    let iconName: String
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle(isOn: $isOn) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.customMint)
                    .frame(width: 20)
                Text(title)
                    .font(.subheadline)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

@available(iOS 14.0, *)
fileprivate struct PerfumeRecipeAddDatePickerView: View {
    let title: String
    @Binding var date: Date
    
    var body: some View {
        DatePicker(title, selection: $date, displayedComponents: .date)
            .datePickerStyle(CompactDatePickerStyle())
            .padding(.horizontal)
            .padding(.vertical, 5)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
    }
}

@available(iOS 14.0, *)
fileprivate struct PerfumeRecipeAddMultiSelectView: View {
    let title: String
    let iconName: String
    @Binding var items: [String]
    @State private var newItem: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            PerfumeRecipeAddSectionHeaderView(title: title, iconName: iconName)
            
            HStack {
                TextField("Add Item", text: $newItem)
                    .padding(5)
                    .background(Color(.tertiarySystemBackground))
                    .cornerRadius(5)
                
                Button(action: {
                    if !newItem.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        items.append(newItem.trimmingCharacters(in: .whitespacesAndNewlines))
                        newItem = ""
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.customMint)
                        .padding(5)
                }
                .disabled(newItem.isEmpty)
            }
            .padding(.horizontal)
            
            if !items.isEmpty {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(items, id: \.self) { item in
                        HStack {
                            Text(item)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 3)
                                .background(Color.customMint.opacity(0.1))
                                .cornerRadius(5)
                            
                            Button(action: {
                                items.removeAll(where: { $0 == item })
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
            }
        }
        .padding(.vertical, 5)
        .background(Color(.secondarySystemBackground).opacity(0.5))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}




@available(iOS 14.0, *)
fileprivate struct PerfumeRecipeListRowView: View {
    let recipe: PerfumeRecipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(alignment: .top) {
                Image(systemName: "wand.and.stars")
                    .foregroundColor(.purple)
                    .font(.title3)
                VStack(alignment: .leading) {
                    Text(recipe.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Text(recipe.commercialName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text(recipe.uniqueCode)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.customMint.opacity(0.2))
                    .cornerRadius(6)
            }
            
            Divider()
                .padding(.horizontal, -15)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 7) {
                    detailItem(icon: "person.text.rectangle.fill", label: "Creator", value: recipe.creatorName, color: .blue)
                    detailItem(icon: "tag.circle.fill", label: "Family", value: recipe.fragranceFamily, color: .green)
                    detailItem(icon: "cube.box.fill", label: "Type", value: recipe.concentrationType, color: .orange)
                    detailItem(icon: "ruler.fill", label: "Volume", value: "\(Int(recipe.totalVolumeML)) ML", color: .red)
                    detailItem(icon: "hourglass.tophalf.fill", label: "Aging", value: "\(recipe.agingDurationDays) Days", color: .customBrown)
                    detailItem(icon: "percent", label: "Alcohol %", value: String(format: "%.1f", recipe.alcoholPercentage), color: .customTeal)
                    detailItem(icon: "lock.shield.fill", label: "Safety", value: recipe.safetyRating, color: .purple)
                    detailItem(icon: "lightbulb.fill", label: "Inspired", value: recipe.inspiration, color: .yellow)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 7) {
                    noteDetail(title: "Top", notes: recipe.topNotes, iconColor: .customMint)
                    noteDetail(title: "Middle", notes: recipe.middleNotes, iconColor: .customMint)
                    noteDetail(title: "Base", notes: recipe.baseNotes, iconColor: .customMint)
                    detailItem(icon: "clock.fill", label: "Longevity", value: String(format: "%.1f Hrs", recipe.longevityHours), color: .gray)
                    detailItem(icon: "checkmark.seal.fill", label: "Stability", value: recipe.stabilityTested ? "Tested" : "Pending", color: recipe.stabilityTested ? .green : .orange)
                    detailItem(icon: "paintpalette.fill", label: "Color", value: recipe.colorDescription, color: .pink)
                    detailItem(icon: "calendar", label: "Created", value: formatDate(recipe.creationDate), color: Color(red: 0.3, green: 0.3, blue: 0.9))
                    detailItem(icon: "slider.horizontal.3", label: "Ratio", value: recipe.blendRatioDescription, color: Color(red: 0.3, green: 0.9, blue: 1.0))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
    
    private func detailItem(icon: String, label: String, value: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
            Text("\(label):")
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .lineLimit(1)
        }
    }
    
    private func noteDetail(title: String, notes: [String], iconColor: Color) -> some View {
        HStack(alignment: .top, spacing: 5) {
            Image(systemName: "dot.radiowaves.right")
                .font(.caption)
                .foregroundColor(iconColor)
            Text("\(title):")
                .font(.caption)
                .foregroundColor(.secondary)
            Text(notes.joined(separator: ", "))
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(1)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

@available(iOS 14.0, *)
fileprivate struct PerfumeRecipeSearchBarView: View {
    @Binding var searchText: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            TextField("Search by Name or Code...", text: $searchText)
                .padding(8)
                .padding(.horizontal, 25)
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing && !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .onTapGesture {
                    isEditing = true
                }
            
            if isEditing {
                Button(action: {
                    isEditing = false
                    searchText = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                        .foregroundColor(.customMint)
                }
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

@available(iOS 14.0, *)
fileprivate struct PerfumeRecipeNoDataView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "leaf.sparkles")
                .font(.largeTitle)
                .foregroundColor(.customMint)
                .padding()
                .background(Circle().fill(Color.customMint.opacity(0.1)))
            
            Text("No Recipes Found")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Try searching for a different term or tap '+' to create a new perfume recipe.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.top, 50)
    }
}


@available(iOS 14.0, *)
struct PerfumeRecipeListView: View {
    @EnvironmentObject var dataStore: PerfumeDataStore
    @State private var searchText: String = ""
    @State private var showingAddView: Bool = false
    
    var filteredRecipes: [PerfumeRecipe] {
        if searchText.isEmpty {
            return dataStore.recipes
        } else {
            return dataStore.recipes.filter { recipe in
                recipe.name.localizedCaseInsensitiveContains(searchText) ||
                recipe.uniqueCode.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
            VStack {
                PerfumeRecipeSearchBarView(searchText: $searchText)
                
                if filteredRecipes.isEmpty {
                    PerfumeRecipeNoDataView()
                } else {
                    List {
                        ForEach(filteredRecipes) { recipe in
                            ZStack {
                                NavigationLink(destination: PerfumeRecipeDetailView(recipe: recipe)) {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                PerfumeRecipeListRowView(recipe: recipe)
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                            .background(Color(.systemGroupedBackground))
                            .listRowBackground(Color(.systemGroupedBackground))
                        }
                        .onDelete(perform: deleteRecipe)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationTitle("Perfume Recipes")
            .navigationBarItems(trailing:
                Button(action: {
                    showingAddView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.customMint)
                }
            )
            .sheet(isPresented: $showingAddView) {
                NavigationView {
                    PerfumeRecipeAddView()
                        .environmentObject(dataStore)
                }
            }
        
    }
    
    private func deleteRecipe(at offsets: IndexSet) {
        let recipesToDelete = offsets.map { filteredRecipes[$0] }
        let originalOffsets = IndexSet(recipesToDelete.compactMap { recipe in
            dataStore.recipes.firstIndex(where: { $0.id == recipe.id })
        })
        
        dataStore.deleteRecipe(at: originalOffsets)
    }
}


@available(iOS 14.0, *)
fileprivate struct PerfumeRecipeDetailFieldRow: View {
    let label: String
    let value: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.customTeal)
                .frame(width: 20)
            
            Text(label)
                .foregroundColor(.secondary)
                .font(.callout)
            
            Spacer()
            
            Text(value)
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 4)
    }
}

@available(iOS 14.0, *)
fileprivate struct PerfumeRecipeDetailTagView: View {
    let title: String
    let items: [String]
    let iconName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.customMint)
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.customMint.opacity(0.15))
                        .cornerRadius(10)
                }
            }
            .padding(.leading, 10)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
    }
}

@available(iOS 14.0, *)
struct PerfumeRecipeDetailView: View {
    let recipe: PerfumeRecipe
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 25) {
                    
                    VStack(spacing: 5) {
                        Text(recipe.name)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.customMint)
                        
                        Text("Code: \(recipe.uniqueCode) | Commercial: \(recipe.commercialName)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Core Metrics
                    HStack(alignment: .top, spacing: 20) {
                        VStack(spacing: 10) {
                            PerfumeRecipeDetailFieldRow(label: "Volume (ML)", value: String(format: "%.0f", recipe.totalVolumeML), iconName: "ruler.fill")
                            PerfumeRecipeDetailFieldRow(label: "Aging (Days)", value: "\(recipe.agingDurationDays)", iconName: "hourglass.tophalf.fill")
                            PerfumeRecipeDetailFieldRow(label: "Longevity (Hrs)", value: String(format: "%.1f", recipe.longevityHours), iconName: "clock.fill")
                            PerfumeRecipeDetailFieldRow(label: "Alcohol (%)", value: String(format: "%.1f", recipe.alcoholPercentage), iconName: "percent")
                            PerfumeRecipeDetailFieldRow(label: "Dilution Medium", value: recipe.dilutionMedium, iconName: "water.fill")
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        
                        VStack(spacing: 10) {
                            PerfumeRecipeDetailFieldRow(label: "Creator", value: recipe.creatorName, iconName: "person.fill")
                            PerfumeRecipeDetailFieldRow(label: "Family", value: recipe.fragranceFamily, iconName: "tag.circle.fill")
                            PerfumeRecipeDetailFieldRow(label: "Type", value: recipe.concentrationType, iconName: "cube.fill")
                            PerfumeRecipeDetailFieldRow(label: "Sillage", value: recipe.sillageLevel, iconName: "wind")
                            PerfumeRecipeDetailFieldRow(label: "Safety Rating", value: recipe.safetyRating, iconName: "lock.shield.fill")
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                    
                    // Notes/Tags Section
                    HStack(alignment: .top) {
                        PerfumeRecipeDetailTagView(title: "Top Notes", items: recipe.topNotes, iconName: "chevron.up.circle.fill")
                        PerfumeRecipeDetailTagView(title: "Middle Notes", items: recipe.middleNotes, iconName: "dot.circle.viewfinder")
                        PerfumeRecipeDetailTagView(title: "Base Notes", items: recipe.baseNotes, iconName: "chevron.down.circle.fill")
                    }
                    .padding(.horizontal)

                    // Recipe Details Block
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Recipe Details & Logistics")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        PerfumeRecipeDetailFieldRow(label: "Inspiration", value: recipe.inspiration, iconName: "lightbulb.fill")
                        PerfumeRecipeDetailFieldRow(label: "Blend Ratio", value: recipe.blendRatioDescription, iconName: "divide.circle.fill")
                        PerfumeRecipeDetailFieldRow(label: "Color", value: recipe.colorDescription, iconName: "paintpalette.fill")
                        PerfumeRecipeDetailFieldRow(label: "Temp Sensitivity", value: recipe.temperatureSensitivity, iconName: "thermometer")
                        PerfumeRecipeDetailFieldRow(label: "Stability Tested", value: recipe.stabilityTested ? "Yes" : "No", iconName: "checkmark.seal.fill")
                        PerfumeRecipeDetailFieldRow(label: "Storage Instructions", value: recipe.storageInstructions, iconName: "archivebox.fill")
                        PerfumeRecipeDetailFieldRow(label: "Allergens", value: recipe.allergens.joined(separator: ", "), iconName: "exclamationmark.triangle.fill")
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)

                    // Review & Dates Block
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Review Notes & History")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        PerfumeRecipeDetailFieldRow(label: "Review Notes", value: recipe.reviewNotes, iconName: "hand.raised.fill")
                        PerfumeRecipeDetailFieldRow(label: "Created On", value: formatDate(recipe.creationDate), iconName: "calendar")
                        PerfumeRecipeDetailFieldRow(label: "Last Modified", value: formatDate(recipe.lastModified), iconName: "slider.horizontal.3")
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)

                    
                }
            }
        }
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
