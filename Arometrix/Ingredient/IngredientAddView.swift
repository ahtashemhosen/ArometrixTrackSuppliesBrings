
import SwiftUI
import Combine

struct CustomColor {
    static let teal = Color(red: 0/255, green: 150/255, blue: 136/255)
    static let brown = Color(red: 121/255, green: 85/255, blue: 72/255)
    static let indigo = Color(red: 92/255, green: 71/255, blue: 219/255)
    static let mint = Color(red: 0.3, green: 0.9, blue: 1.0)
}

@available(iOS 14.0, *)
struct IngredientAddDatePickerView: View {
    let title: String
    @Binding var date: Date
    let iconName: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(CustomColor.mint)
                .frame(width: 30)
            DatePicker(title, selection: $date, displayedComponents: .date)
                .labelsHidden()
                .padding(.vertical, 8)
            Spacer()
        }
        .padding(.horizontal)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

@available(iOS 14.0, *)
struct IngredientAddToggleView: View {
    let title: String
    @Binding var isOn: Bool
    let iconName: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(CustomColor.mint)
                .frame(width: 30)
            Toggle(title, isOn: $isOn)
                .foregroundColor(Color(.darkText))
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

@available(iOS 14.0, *)
struct IngredientAddSectionHeaderView: View {
    let title: String
    let iconName: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(CustomColor.mint)
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.top, 10)
    }
}

@available(iOS 14.0, *)
struct IngredientAddFieldView: View {
    let title: String
    @Binding var text: String
    let iconName: String
    let keyboardType: UIKeyboardType

    var body: some View {
        ZStack(alignment: .leading) {
            Text(title)
                .foregroundColor(text.isEmpty ? Color(.placeholderText) : CustomColor.mint)
                .offset(y: text.isEmpty ? 0 : -25)
                .scaleEffect(text.isEmpty ? 1 : 0.8, anchor: .leading)

            TextField("", text: $text)
                .keyboardType(keyboardType)
                .padding(.top, 15)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            VStack {
                Spacer()
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(text.isEmpty ? Color(.systemGray4) : CustomColor.mint)
            }
        )
    }
}

@available(iOS 14.0, *)
struct IngredientAddDoubleFieldView: View {
    let title: String
    @Binding var value: Double?
    let iconName: String

    @State private var text: String = ""

    var body: some View {
        IngredientAddFieldView(
            title: title,
            text: $text,
            iconName: iconName,
            keyboardType: .decimalPad
        )
        .onAppear {
            if let value = value {
                text = String(format: "%.2f", value)
            }
        }
        .onChange(of: text) { newValue in
            value = Double(newValue)
        }
    }
}

@available(iOS 14.0, *)
struct IngredientAddIntFieldView: View {
    let title: String
    @Binding var value: Int?
    let iconName: String

    @State private var text: String = ""

    var body: some View {
        IngredientAddFieldView(
            title: title,
            text: $text,
            iconName: iconName,
            keyboardType: .numberPad
        )
        .onAppear {
            if let value = value {
                text = String(value)
            }
        }
        .onChange(of: text) { newValue in
            value = Int(newValue)
        }
    }
}

@available(iOS 14.0, *)
struct IngredientAddView: View {
    @EnvironmentObject var dataStore: PerfumeDataStore
    @Environment(\.presentationMode) var presentationMode

    @State private var name: String = ""
    @State private var category: String = ""
    @State private var scentNote: String = ""
    @State private var purityLevel: String = ""
    @State private var supplierName: String = ""
    @State private var batchCode: String = ""
    @State private var originCountry: String = ""
    @State private var extractionMethod: String = ""
    @State private var storageLocation: String = ""
    @State private var quantityML: Double?
    @State private var reorderLevel: Double?
    @State private var costPerML: Double?
    @State private var totalStockValue: Double?
    @State private var safetyDataSheetAvailable: Bool = false
    @State private var expiryDate: Date = Date()
    @State private var receivedDate: Date = Date()
    @State private var usageCount: Int?
    @State private var noteDescription: String = ""
    @State private var color: String = ""
    @State private var volatilityLevel: String = ""
    @State private var flashPointCelsius: Double?
    @State private var recommendedUsagePercent: Double?
    @State private var safetyPrecautions: String = ""
    @State private var storageTemperatureC: Double?
    @State private var lastUpdated: Date = Date()

    @State private var showAlert = false
    @State private var alertMessage = ""

    private func validateAndSave() {
        var errors: [String] = []

        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Name is required.") }
        if category.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Category is required.") }
        if scentNote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Scent Note is required.") }
        if purityLevel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Purity Level is required.") }
        if supplierName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Supplier Name is required.") }
        if originCountry.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Origin Country is required.") }
        if extractionMethod.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Extraction Method is required.") }
        if storageLocation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Storage Location is required.") }
        if quantityML == nil || quantityML! <= 0 { errors.append("Quantity (ML) must be a positive number.") }
        if reorderLevel == nil || reorderLevel! < 0 { errors.append("Reorder Level must be non-negative.") }
        if costPerML == nil || costPerML! <= 0 { errors.append("Cost Per ML must be a positive number.") }
        if totalStockValue == nil || totalStockValue! <= 0 { errors.append("Total Stock Value must be a positive number.") }
        if usageCount == nil || usageCount! < 0 { errors.append("Usage Count must be non-negative.") }
        if noteDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Note Description is required.") }
        if color.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Color is required.") }
        if volatilityLevel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Volatility Level is required.") }
        if flashPointCelsius == nil { errors.append("Flash Point is required.") }
        if recommendedUsagePercent == nil { errors.append("Recommended Usage is required.") }
        if safetyPrecautions.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Safety Precautions are required.") }
        if storageTemperatureC == nil { errors.append("Storage Temperature is required.") }

        if errors.isEmpty {
            let newIngredient = Ingredient(
                name: name,
                category: category,
                scentNote: scentNote,
                purityLevel: purityLevel,
                supplierName: supplierName,
                batchCode: batchCode,
                originCountry: originCountry,
                extractionMethod: extractionMethod,
                storageLocation: storageLocation,
                quantityML: quantityML!,
                reorderLevel: reorderLevel!,
                costPerML: costPerML!,
                totalStockValue: totalStockValue!,
                safetyDataSheetAvailable: safetyDataSheetAvailable,
                expiryDate: expiryDate,
                receivedDate: receivedDate,
                usageCount: usageCount!,
                noteDescription: noteDescription,
                color: color,
                volatilityLevel: volatilityLevel,
                flashPointCelsius: flashPointCelsius!,
                recommendedUsagePercent: recommendedUsagePercent!,
                safetyPrecautions: safetyPrecautions,
                storageTemperatureC: storageTemperatureC!,
                lastUpdated: Date()
            )
            dataStore.addIngredient(newIngredient)
            alertMessage = "✅ Ingredient **\(name)** added successfully!"
        } else {
            alertMessage = "❌ **Validation Errors:**\n" + errors.joined(separator: "\n")
        }

        showAlert = true
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                IngredientAddSectionHeaderView(title: "Essential Details", iconName: "star.fill")
                VStack(spacing: 15) {
                    IngredientAddFieldView(title: "Name", text: $name, iconName: "tag", keyboardType: .default)
                    IngredientAddFieldView(title: "Category", text: $category, iconName: "briefcase", keyboardType: .default)
                    HStack(spacing: 15) {
                        IngredientAddFieldView(title: "Scent Note", text: $scentNote, iconName: "music.note", keyboardType: .default)
                        IngredientAddFieldView(title: "Purity Level", text: $purityLevel, iconName: "p.circle", keyboardType: .default)
                    }
                    IngredientAddFieldView(title: "Note Description", text: $noteDescription, iconName: "text.bubble", keyboardType: .default)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)

                IngredientAddSectionHeaderView(title: "Supply Chain & Stock", iconName: "truck.box.fill")
                VStack(spacing: 15) {
                    HStack(spacing: 15) {
                        IngredientAddFieldView(title: "Supplier Name", text: $supplierName, iconName: "person.2", keyboardType: .default)
                        IngredientAddFieldView(title: "Batch Code", text: $batchCode, iconName: "barcode", keyboardType: .default)
                    }
                    HStack(spacing: 15) {
                        IngredientAddDoubleFieldView(title: "Quantity (ML)", value: $quantityML, iconName: "drop.fill")
                        IngredientAddDoubleFieldView(title: "Reorder Level (ML)", value: $reorderLevel, iconName: "arrow.up.bin.fill")
                    }
                    HStack(spacing: 15) {
                        IngredientAddFieldView(title: "Origin Country", text: $originCountry, iconName: "globe", keyboardType: .default)
                        IngredientAddFieldView(title: "Extraction Method", text: $extractionMethod, iconName: "lab.flask.fill", keyboardType: .default)
                    }
                    IngredientAddFieldView(title: "Storage Location", text: $storageLocation, iconName: "shippingbox", keyboardType: .default)
                    IngredientAddDatePickerView(title: "Received Date", date: $receivedDate, iconName: "calendar.badge.plus")
                    IngredientAddDatePickerView(title: "Expiry Date", date: $expiryDate, iconName: "calendar.badge.minus")
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: CustomColor.mint.opacity(0.2), radius: 8, x: 0, y: 4)

                IngredientAddSectionHeaderView(title: "Financial & Safety", iconName: "banknote.fill")
                VStack(spacing: 15) {
                    HStack(spacing: 15) {
                        IngredientAddDoubleFieldView(title: "Cost/ML", value: $costPerML, iconName: "dollarsign.circle")
                        IngredientAddDoubleFieldView(title: "Total Stock Value", value: $totalStockValue, iconName: "sum")
                    }
                    IngredientAddIntFieldView(title: "Usage Count", value: $usageCount, iconName: "arrow.turn.up.left")
                    HStack(spacing: 15) {
                        IngredientAddFieldView(title: "Color", text: $color, iconName: "paintpalette", keyboardType: .default)
                        IngredientAddFieldView(title: "Volatility Level", text: $volatilityLevel, iconName: "cloud.drizzle.fill", keyboardType: .default)
                    }
                    HStack(spacing: 15) {
                        IngredientAddDoubleFieldView(title: "Flash Point (°C)", value: $flashPointCelsius, iconName: "flame.fill")
                        IngredientAddDoubleFieldView(title: "Storage Temp (°C)", value: $storageTemperatureC, iconName: "thermometer")
                    }
                    IngredientAddDoubleFieldView(title: "Recommended Usage (%)", value: $recommendedUsagePercent, iconName: "percent")
                    IngredientAddFieldView(title: "Safety Precautions", text: $safetyPrecautions, iconName: "hand.raised.fill", keyboardType: .default)

                    IngredientAddToggleView(title: "SDS Available", isOn: $safetyDataSheetAvailable, iconName: "doc.text.fill")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)

                Button(action: validateAndSave) {
                    Text("Add New Ingredient")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(CustomColor.mint)
                        .cornerRadius(15)
                        .shadow(color: CustomColor.mint.opacity(0.4), radius: 10, x: 0, y: 5)
                }
                .padding(.top, 20)

            }
            .padding()
            .navigationTitle("New Ingredient Log 🧪")
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertMessage.contains("✅") ? "Success" : "Error"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")) {
                if alertMessage.contains("✅") {
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
}

@available(iOS 14.0, *)
struct IngredientNoDataView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bottle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(CustomColor.mint.opacity(0.6))

            Text("No Ingredients Found")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Text("Try adding a new ingredient record to get started, or adjust your search query.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding(40)
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .padding(.horizontal, 30)
    }
}

@available(iOS 14.0, *)
struct IngredientSearchBarView: View {
    @Binding var searchText: String

    @State private var isEditing = false

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField("Search ingredients...", text: $searchText, onEditingChanged: { editing in
                    withAnimation {
                        self.isEditing = editing
                    }
                })

                if isEditing {
                    Button(action: {
                        self.searchText = ""
                    }) {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(7)
            .background(Color(.systemGray6))
            .cornerRadius(10)

            if isEditing {
                Button(action: {
                    withAnimation {
                        self.isEditing = false
                        self.searchText = ""
                        UIApplication.shared.endEditing()
                    }
                }) {
                    Text("Cancel")
                        .foregroundColor(CustomColor.mint)
                }
                .transition(.move(edge: .trailing))
            }
        }
        .padding(.horizontal)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

@available(iOS 14.0, *)
struct IngredientListRowView: View {
    let ingredient: Ingredient

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(ingredient.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text("\(ingredient.scentNote) Note (\(ingredient.category))")
                        .font(.caption)
                        .foregroundColor(CustomColor.mint)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Image(systemName: "drop.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(CustomColor.mint)
                    Text("Stock: \(String(format: "%.0f ML", ingredient.quantityML))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            Divider().padding(.vertical, 5)

            VStack(spacing: 8) {
                HStack {
                    InfoPill(icon: "person.2.fill", title: "Supplier", value: ingredient.supplierName)
                    Spacer()
                    InfoPill(icon: "p.circle.fill", title: "Purity", value: ingredient.purityLevel)
                    Spacer()
                    InfoPill(icon: "dollarsign.circle.fill", title: "Cost/ML", value: String(format: "$%.2f", ingredient.costPerML))
                }

                HStack {
                    InfoPill(icon: "globe", title: "Origin", value: ingredient.originCountry)
                    Spacer()
                    InfoPill(icon: "barcode", title: "Batch", value: ingredient.batchCode)
                    Spacer()
                    InfoPill(icon: "arrow.up.bin.fill", title: "Reorder", value: String(format: "%.0f ML", ingredient.reorderLevel))
                }

                HStack {
                    InfoPill(icon: "calendar.badge.plus", title: "Received", value: ingredient.receivedDate, isDate: true)
                    Spacer()
                    InfoPill(icon: "calendar.badge.minus", title: "Expires", value: ingredient.expiryDate, isDate: true)
                    Spacer()
                    InfoPill(icon: "sum", title: "Value", value: String(format: "$%.0f", ingredient.totalStockValue))
                }

                HStack {
                    InfoPill(icon: "thermometer", title: "Temp", value: String(format: "%.0f°C", ingredient.storageTemperatureC))
                    Spacer()
                    InfoPill(icon: "flame.fill", title: "Flash", value: String(format: "%.0f°C", ingredient.flashPointCelsius))
                    Spacer()
                    InfoPill(icon: "percent", title: "Usage", value: String(format: "%.1f%%", ingredient.recommendedUsagePercent))
                }

                HStack {
                    InfoPill(icon: ingredient.safetyDataSheetAvailable ? "checkmark.shield.fill" : "xmark.shield.fill",
                             title: "SDS",
                             value: ingredient.safetyDataSheetAvailable ? "Available" : "Missing")
                    Spacer()
                    InfoPill(icon: "arrow.turn.up.left", title: "Used", value: "\(ingredient.usageCount) times")
                    Spacer()
                    InfoPill(icon: "location.fill", title: "Location", value: ingredient.storageLocation)
                }
            }
        }
        .padding(15)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
}

@available(iOS 14.0, *)
struct InfoPill: View {
    let icon: String
    let title: String
    let value: String
    let isDate: Bool

    init(icon: String, title: String, value: String) {
        self.icon = icon
        self.title = title
        self.value = value
        self.isDate = false
    }

    init(icon: String, title: String, value: Date, isDate: Bool) {
        self.icon = icon
        self.title = title
        self.value = DateFormatter.shortDate.string(from: value)
        self.isDate = isDate
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
            }
            Text(value)
                .font(.footnote)
                .fontWeight(.semibold)
                .lineLimit(1)
                .foregroundColor(.black)
        }
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}



@available(iOS 14.0, *)
struct IngredientDetailFieldRow: View {
    let title: String
    let value: String
    let iconName: String
    let color: Color

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: iconName)
                .foregroundColor(color)
                .frame(width: 20, alignment: .leading)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)

                Text(value)
                    .font(.callout)
                    .foregroundColor(.primary)
            }
            Spacer()
        }
        .padding(.vertical, 5)
    }
}

