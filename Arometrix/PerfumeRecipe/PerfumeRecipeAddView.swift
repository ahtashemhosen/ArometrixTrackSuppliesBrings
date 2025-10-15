
import SwiftUI

@available(iOS 14.0, *)
struct PerfumeRecipeAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataStore: PerfumeDataStore

    @State private var name: String = ""
    @State private var creatorName: String = ""
    @State private var inspiration: String = ""
    @State private var fragranceFamily: String = ""
    @State private var topNotes: [String] = []
    @State private var middleNotes: [String] = []
    @State private var baseNotes: [String] = []
    @State private var concentrationType: String = "Eau de Parfum"
    @State private var totalVolumeML: Double?
    @State private var blendRatioDescription: String = ""
    @State private var agingDurationDays: Int?
    @State private var stabilityTested: Bool = false
    @State private var sillageLevel: String = ""
    @State private var longevityHours: Double?
    @State private var alcoholPercentage: Double?
    @State private var dilutionMedium: String = "Ethanol"
    @State private var storageInstructions: String = ""
    @State private var allergens: [String] = []
    @State private var colorDescription: String = ""
    @State private var temperatureSensitivity: String = ""
    @State private var creationDate: Date = Date()
    @State private var lastModified: Date = Date()
    @State private var reviewNotes: String = ""
    @State private var safetyRating: String = ""
    @State private var commercialName: String = ""
    @State private var uniqueCode: String = ""

    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private func validateAndSave() -> Bool {
        var errors: [String] = []
        
        if name.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Recipe Name is required.") }
        if creatorName.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Creator Name is required.") }
        if fragranceFamily.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Fragrance Family is required.") }
        if concentrationType.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Concentration Type is required.") }
        if dilutionMedium.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Dilution Medium is required.") }
        if uniqueCode.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Unique Code is required.") }

        if totalVolumeML == nil || totalVolumeML! <= 0 { errors.append("Total Volume (ML) must be a positive number.") }
        if agingDurationDays == nil || agingDurationDays! < 0 { errors.append("Aging Duration must be a non-negative integer.") }
        if longevityHours == nil || longevityHours! <= 0 { errors.append("Longevity (Hours) must be a positive number.") }
        if alcoholPercentage == nil || alcoholPercentage! < 0 || alcoholPercentage! > 100 { errors.append("Alcohol Percentage must be between 0 and 100.") }

        if topNotes.isEmpty { errors.append("Recipe must include Top notes.") }
        if middleNotes.isEmpty { errors.append("Recipe must include Middle notes.") }
        if baseNotes.isEmpty { errors.append("Recipe must include Base notes.") }
        
        if errors.isEmpty {
            let newRecipe = PerfumeRecipe(
                name: name,
                creatorName: creatorName,
                inspiration: inspiration,
                fragranceFamily: fragranceFamily,
                topNotes: topNotes,
                middleNotes: middleNotes,
                baseNotes: baseNotes,
                concentrationType: concentrationType,
                totalVolumeML: totalVolumeML!,
                blendRatioDescription: blendRatioDescription,
                agingDurationDays: agingDurationDays!,
                stabilityTested: stabilityTested,
                sillageLevel: sillageLevel,
                longevityHours: longevityHours!,
                alcoholPercentage: alcoholPercentage!,
                dilutionMedium: dilutionMedium,
                storageInstructions: storageInstructions,
                allergens: allergens,
                colorDescription: colorDescription,
                temperatureSensitivity: temperatureSensitivity,
                creationDate: creationDate,
                lastModified: Date(),
                reviewNotes: reviewNotes,
                safetyRating: safetyRating,
                commercialName: commercialName,
                uniqueCode: uniqueCode
            )
            
            dataStore.addRecipe(newRecipe)
            alertMessage = "✅ Successfully added recipe: \(name)"
            return true
        } else {
            alertMessage = "🚨 Validation Errors:\n\n" + errors.joined(separator: "\n")
            return false
        }
    }

    var body: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 15) {
                        PerfumeRecipeAddSectionHeaderView(title: "Core Identification", iconName: "star.fill")
                        
                        PerfumeRecipeAddFieldView(title: "Recipe Name*", iconName: "tag.fill", text: $name)
                        PerfumeRecipeAddFieldView(title: "Unique Code*", iconName: "barcode", text: $uniqueCode)
                        PerfumeRecipeAddFieldView(title: "Commercial Name", iconName: "cart.fill", text: $commercialName, isRequired: false)
                        PerfumeRecipeAddFieldView(title: "Creator Name*", iconName: "person.fill", text: $creatorName)
                        PerfumeRecipeAddFieldView(title: "Inspiration", iconName: "lightbulb.fill", text: $inspiration, isRequired: false)
                        
                        PerfumeRecipeAddDatePickerView(title: "Creation Date", date: $creationDate)
                        PerfumeRecipeAddDatePickerView(title: "Last Modified", date: $lastModified)
                        
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)

                    
                    VStack(alignment: .leading, spacing: 15) {
                        PerfumeRecipeAddSectionHeaderView(title: "Fragrance Profile", iconName: "drop.fill")
                        
                        PerfumeRecipeAddFieldView(title: "Fragrance Family*", iconName: "leaf.fill", text: $fragranceFamily)
                        PerfumeRecipeAddFieldView(title: "Concentration Type*", iconName: "cube.fill", text: $concentrationType)

                            PerfumeRecipeAddDoubleFieldView(title: "Total Volume (ML)*", iconName: "scalemass.fill", value: $totalVolumeML)
                            PerfumeRecipeAddDoubleFieldView(title: "Longevity (Hours)*", iconName: "clock.fill", value: $longevityHours)
                        
                        
                        PerfumeRecipeAddMultiSelectView(title: "Top Notes*", iconName: "chevron.up.circle.fill", items: $topNotes)
                        PerfumeRecipeAddMultiSelectView(title: "Middle Notes*", iconName: "dot.circle.viewfinder", items: $middleNotes)
                        PerfumeRecipeAddMultiSelectView(title: "Base Notes*", iconName: "chevron.down.circle.fill", items: $baseNotes)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        PerfumeRecipeAddSectionHeaderView(title: "Technical & Regulatory", iconName: "gearshape.2.fill")
                        
                            PerfumeRecipeAddDoubleFieldView(title: "Alcohol Percentage (%)*", iconName: "percent", value: $alcoholPercentage)
                            PerfumeRecipeAddFieldView(title: "Dilution Medium*", iconName: "water.fill", text: $dilutionMedium)
                        
                        
                            PerfumeRecipeAddIntFieldView(title: "Aging Duration (Days)*", iconName: "hourglass.tophalf.fill", value: $agingDurationDays)
                            PerfumeRecipeAddFieldView(title: "Sillage Level", iconName: "wind", text: $sillageLevel, isRequired: false)
                        

                        PerfumeRecipeAddFieldView(title: "Safety Rating", iconName: "lock.shield.fill", text: $safetyRating, isRequired: false)

                        HStack(spacing: 15) {
                            PerfumeRecipeAddToggleView(title: "Stability Tested", iconName: "checkmark.seal.fill", isOn: $stabilityTested)
                        }
                        
                        PerfumeRecipeAddMultiSelectView(title: "Allergens", iconName: "exclamationmark.triangle.fill", items: $allergens)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        PerfumeRecipeAddSectionHeaderView(title: "Notes & Instructions", iconName: "note.text")
                        
                        PerfumeRecipeAddFieldView(title: "Blend Ratio Description", iconName: "divide.circle.fill", text: $blendRatioDescription, isRequired: false)
                        PerfumeRecipeAddFieldView(title: "Color Description", iconName: "paintpalette.fill", text: $colorDescription, isRequired: false)
                        PerfumeRecipeAddFieldView(title: "Temperature Sensitivity", iconName: "thermometer", text: $temperatureSensitivity, isRequired: false)
                        PerfumeRecipeAddFieldView(title: "Storage Instructions", iconName: "archivebox.fill", text: $storageInstructions, isRequired: false)
                        PerfumeRecipeAddFieldView(title: "Review Notes", iconName: "hand.raised.fill", text: $reviewNotes, isRequired: false)

                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    
                    Button(action: {
                        let success = validateAndSave()
                        showAlert = true
                        if success {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }) {
                        Text("Save New Perfume Recipe")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.customMint)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .padding(.bottom, 30)

                }
                .padding(.top, 10)
            }
        }
        .navigationTitle("New Recipe")
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertMessage.contains("✅") ? "Success" : "Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}


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
