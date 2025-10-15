
import SwiftUI
import Combine

@available(iOS 14.0, *)
extension Color {
    static let customMint = Color(red: 0 / 255, green: 199 / 255, blue: 190 / 255)
    static let systemBackgroundLight = Color(red: 229 / 255, green: 229 / 255, blue: 234 / 255)
}

@available(iOS 14.0, *)
extension ProductionRecord {
    var isValid: Bool {
        return !recordNumber.isEmpty &&
               !perfumeName.isEmpty &&
               !batchNumber.isEmpty &&
               totalVolumeProduced > 0 &&
               totalCost >= 0 &&
               !supervisorName.isEmpty &&
               !assistantName.isEmpty &&
               processDurationMinutes > 0
    }
}

@available(iOS 14.0, *)
struct ProductionRecordAddFieldView: View {
    @Binding var text: String
    var title: String
    var iconName: String
    var keyboardType: UIKeyboardType = .default
    var isNumber: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
                .offset(y: 0)
                .animation(.easeOut(duration: 0.2), value: text.isEmpty)

            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.customMint)
                TextField("", text: $text)
                    .keyboardType(keyboardType)
                    .foregroundColor(.primary)
            }
            .padding(.top, -5)
            .padding(.bottom, 5)

            Divider()
                .background(Color.customMint.opacity(0.5))
        }
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct ProductionRecordAddDatePickerView: View {
    @Binding var date: Date
    var title: String
    var iconName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.customMint)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Spacer()
                DatePicker("", selection: $date)
                    .labelsHidden()
                    .accentColor(.customMint)
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            
            Divider()
                .background(Color.customMint.opacity(0.5))
        }
    }
}

@available(iOS 14.0, *)
struct ProductionRecordAddToggleView: View {
    @Binding var isOn: Bool
    var title: String
    var iconName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.customMint)
                Toggle(title, isOn: $isOn)
                    .toggleStyle(SwitchToggleStyle(tint: .customMint))
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            
            Divider()
                .background(Color.customMint.opacity(0.5))
        }
    }
}

@available(iOS 14.0, *)
struct ProductionRecordAddSectionHeaderView: View {
    var title: String
    var iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.title3)
                .foregroundColor(.customMint)
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 20)
        .padding(.bottom, 5)
    }
}

@available(iOS 14.0, *)
struct ProductionRecordSearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(searchText.isEmpty ? .gray : .customMint)
                
                TextField("Search Production Records...", text: $searchText)
                    .foregroundColor(.primary)
                    .disableAutocorrection(true)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color.systemBackgroundLight)
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.2), radius: 3, x: 0, y: 2)
            .padding(.horizontal, 10)
        }
        .padding(.vertical, 5)
        .animation(.default, value: searchText)
    }
}

@available(iOS 14.0, *)
struct ProductionRecordNoDataView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray.opacity(0.4))
            
            Text("No Production Records Found 😥")
                .font(.headline)
                .foregroundColor(.gray)
            
            Text("Try adjusting your search or adding a new record.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(50)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

@available(iOS 14.0, *)
struct ProductionRecordDetailFieldRow: View {
    var label: String
    var value: String
    var iconName: String
    var isPrimary: Bool = false
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: iconName)
                .foregroundColor(isPrimary ? .customMint : .secondary)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(isPrimary ? .body : .subheadline)
                    .fontWeight(isPrimary ? .medium : .regular)
                    .foregroundColor(.primary)
                    .lineLimit(isPrimary ? 2 : 1)
            }
            Spacer()
        }
    }
}


@available(iOS 14.0, *)
struct ProductionRecordAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataStore: PerfumeDataStore
    
    @State private var recordNumber: String = ""
    @State private var perfumeName: String = ""
    @State private var productionDate: Date = Date()
    @State private var batchNumber: String = ""
    @State private var totalVolumeProduced: String = ""
    @State private var totalCost: String = ""
    @State private var supervisorName: String = ""
    @State private var assistantName: String = ""
    @State private var processDurationMinutes: String = ""
    @State private var roomTemperatureC: String = ""
    @State private var humidityPercent: String = ""
    @State private var equipmentUsed: String = ""
    @State private var alcoholUsedML: String = ""
    @State private var essenceUsedML: String = ""
    @State private var distilledWaterUsedML: String = ""
    @State private var remarks: String = ""
    @State private var qualityCheckPassed: Bool = false
    @State private var densityReading: String = ""
    @State private var viscosityReading: String = ""
    @State private var sampleTaken: Bool = false
    @State private var packagingType: String = ""
    @State private var bottlesFilled: String = ""
    @State private var labelAppliedBy: String = ""
    @State private var storageShelf: String = ""
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    private func validateAndSave() {
        var errors: [String] = []
        
        let volume = Double(totalVolumeProduced) ?? 0
        let cost = Double(totalCost) ?? 0
        let duration = Int(processDurationMinutes) ?? 0
        let temp = Double(roomTemperatureC) ?? 0
        let humidity = Double(humidityPercent) ?? 0
        let alcohol = Double(alcoholUsedML) ?? 0
        let essence = Double(essenceUsedML) ?? 0
        let water = Double(distilledWaterUsedML) ?? 0
        let density = Double(densityReading) ?? 0
        let viscosity = Double(viscosityReading) ?? 0
        let bottles = Int(bottlesFilled) ?? 0
        
        if recordNumber.isEmpty { errors.append("• Record Number is required.") }
        if perfumeName.isEmpty { errors.append("• Perfume Name is required.") }
        if batchNumber.isEmpty { errors.append("• Batch Number is required.") }
        if totalVolumeProduced.isEmpty || volume <= 0 { errors.append("• Total Volume Produced must be > 0.") }
        if totalCost.isEmpty || cost < 0 { errors.append("• Total Cost must be non-negative.") }
        if supervisorName.isEmpty { errors.append("• Supervisor Name is required.") }
        if assistantName.isEmpty { errors.append("• Assistant Name is required.") }
        if processDurationMinutes.isEmpty || duration <= 0 { errors.append("• Process Duration must be > 0.") }
        if roomTemperatureC.isEmpty || temp == 0 { errors.append("• Room Temperature is required.") }
        if humidityPercent.isEmpty || humidity == 0 { errors.append("• Humidity Percent is required.") }
        if equipmentUsed.isEmpty { errors.append("• Equipment Used is required.") }
        if alcoholUsedML.isEmpty || alcohol < 0 { errors.append("• Alcohol Used is required.") }
        if essenceUsedML.isEmpty || essence < 0 { errors.append("• Essence Used is required.") }
        if distilledWaterUsedML.isEmpty || water < 0 { errors.append("• Water Used is required.") }
        if densityReading.isEmpty || density <= 0 { errors.append("• Density Reading is required.") }
        if viscosityReading.isEmpty || viscosity <= 0 { errors.append("• Viscosity Reading is required.") }
        if packagingType.isEmpty { errors.append("• Packaging Type is required.") }
        if bottlesFilled.isEmpty || bottles <= 0 { errors.append("• Bottles Filled must be > 0.") }
        if labelAppliedBy.isEmpty { errors.append("• Label Applied By is required.") }
        if storageShelf.isEmpty { errors.append("• Storage Shelf is required.") }


        if errors.isEmpty {
            let newRecord = ProductionRecord(
                recordNumber: recordNumber,
                perfumeName: perfumeName,
                productionDate: productionDate,
                batchNumber: batchNumber,
                totalVolumeProduced: volume,
                totalCost: cost,
                supervisorName: supervisorName,
                assistantName: assistantName,
                processDurationMinutes: duration,
                roomTemperatureC: temp,
                humidityPercent: humidity,
                equipmentUsed: equipmentUsed,
                alcoholUsedML: alcohol,
                essenceUsedML: essence,
                distilledWaterUsedML: water,
                remarks: remarks,
                qualityCheckPassed: qualityCheckPassed,
                densityReading: density,
                viscosityReading: viscosity,
                sampleTaken: sampleTaken,
                packagingType: packagingType,
                bottlesFilled: bottles,
                labelAppliedBy: labelAppliedBy,
                storageShelf: storageShelf,
                recordCreated: Date(),
                recordUpdated: Date()
            )
            
            dataStore.addProductionRecord(newRecord)
            alertTitle = "Success! ✅"
            alertMessage = "Production Record \(recordNumber) for '\(perfumeName)' has been saved."
            showAlert = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                presentationMode.wrappedValue.dismiss()
            }
            
        } else {
            alertTitle = "Validation Errors ⚠️"
            alertMessage = "Please fix the following issues:\n\(errors.joined(separator: "\n"))"
            showAlert = true
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    
                    ProductionRecordAddSectionHeaderView(title: "Primary Details", iconName: "tag.fill")
                    VStack(spacing: 15) {
                        ProductionRecordAddFieldView(text: $recordNumber, title: "Record Number", iconName: "number.square.fill")
                        ProductionRecordAddFieldView(text: $perfumeName, title: "Perfume Name", iconName: "drop.fill")
                        ProductionRecordAddFieldView(text: $batchNumber, title: "Batch Number", iconName: "barcode")
                        ProductionRecordAddDatePickerView(date: $productionDate, title: "Production Date", iconName: "calendar")
                    }
                    .padding(.bottom)
                    
                    ProductionRecordAddSectionHeaderView(title: "Quantities & Cost", iconName: "dollarsign.circle.fill")
                    VStack(spacing: 15) {
                        HStack {
                            ProductionRecordAddFieldView(text: $totalVolumeProduced, title: "Total Volume (ML)", iconName: "ruler.fill", keyboardType: .decimalPad, isNumber: true)
                            ProductionRecordAddFieldView(text: $totalCost, title: "Total Cost ($)", iconName: "banknote.fill", keyboardType: .decimalPad, isNumber: true)
                        }
                        HStack {
                            ProductionRecordAddFieldView(text: $alcoholUsedML, title: "Alcohol Used (ML)", iconName: "testtube.2", keyboardType: .decimalPad, isNumber: true)
                            ProductionRecordAddFieldView(text: $essenceUsedML, title: "Essence Used (ML)", iconName: "leaf.fill", keyboardType: .decimalPad, isNumber: true)
                        }
                        ProductionRecordAddFieldView(text: $distilledWaterUsedML, title: "Water Used (ML)", iconName: "drop.triangle.fill", keyboardType: .decimalPad, isNumber: true)
                    }
                    .padding(.bottom)
                    
                    ProductionRecordAddSectionHeaderView(title: "Personnel & Environment", iconName: "person.3.fill")
                    VStack(spacing: 15) {
                        ProductionRecordAddFieldView(text: $supervisorName, title: "Supervisor Name", iconName: "person.crop.square.fill")
                        ProductionRecordAddFieldView(text: $assistantName, title: "Assistant Name", iconName: "person.fill")
                        ProductionRecordAddFieldView(text: $processDurationMinutes, title: "Process Duration (Mins)", iconName: "timer", keyboardType: .numberPad)
                        ProductionRecordAddFieldView(text: $equipmentUsed, title: "Equipment Used", iconName: "gearshape.fill")
                        
                        HStack {
                            ProductionRecordAddFieldView(text: $roomTemperatureC, title: "Room Temp (°C)", iconName: "thermometer", keyboardType: .decimalPad)
                            ProductionRecordAddFieldView(text: $humidityPercent, title: "Humidity (%)", iconName: "cloud.fill", keyboardType: .decimalPad)
                        }
                    }
                    .padding(.bottom)
                    
                    ProductionRecordAddSectionHeaderView(title: "Quality & Logistics", iconName: "shippingbox.fill")
                    VStack(spacing: 15) {
                        HStack {
                            ProductionRecordAddFieldView(text: $densityReading, title: "Density Reading", iconName: "gauge.badge.plus", keyboardType: .decimalPad)
                            ProductionRecordAddFieldView(text: $viscosityReading, title: "Viscosity Reading", iconName: "speedometer", keyboardType: .decimalPad)
                        }
                        ProductionRecordAddToggleView(isOn: $qualityCheckPassed, title: "Quality Check Passed", iconName: "checkmark.seal.fill")
                        ProductionRecordAddToggleView(isOn: $sampleTaken, title: "Sample Taken for Lab", iconName: "eyedropper.full.fill")
                        
                        ProductionRecordAddFieldView(text: $packagingType, title: "Packaging Type", iconName: "box.truck.fill")
                        HStack {
                            ProductionRecordAddFieldView(text: $bottlesFilled, title: "Bottles Filled", iconName: "bottle.fill", keyboardType: .numberPad)
                            ProductionRecordAddFieldView(text: $storageShelf, title: "Storage Shelf", iconName: "archivebox.fill")
                        }
                        ProductionRecordAddFieldView(text: $labelAppliedBy, title: "Label Applied By", iconName: "person.text.rectangle.fill")

                    }
                    .padding(.bottom)

                    ProductionRecordAddSectionHeaderView(title: "Remarks", iconName: "note.text")
                    VStack(spacing: 15) {
                        VStack(alignment: .leading) {
                            Text("Process Remarks (Optional)")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            TextEditor(text: $remarks)
                                .frame(height: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .padding(.horizontal)
                        }
                    }
                    .padding(.bottom)
                    
                    Button(action: validateAndSave) {
                        Text("SAVE PRODUCTION RECORD")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.customMint)
                            .cornerRadius(12)
                            .shadow(color: Color.customMint.opacity(0.4), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 30)

                }
            }
            .navigationTitle("New Production Log")
            .navigationBarItems(leading: Button("Cancel") { presentationMode.wrappedValue.dismiss() })
            .background(Color.systemBackgroundLight.ignoresSafeArea(.all))
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

@available(iOS 14.0, *)
struct ProductionRecordListView: View {
    @EnvironmentObject var dataStore: PerfumeDataStore
    @State private var searchText: String = ""
    @State private var isShowingAddView: Bool = false
    
    var filteredRecords: [ProductionRecord] {
        if searchText.isEmpty {
            return dataStore.productionRecords
        } else {
            return dataStore.productionRecords.filter { record in
                record.perfumeName.localizedCaseInsensitiveContains(searchText) ||
                record.batchNumber.localizedCaseInsensitiveContains(searchText) ||
                record.supervisorName.localizedCaseInsensitiveContains(searchText) ||
                record.recordNumber.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    struct ProductionRecordListRowView: View {
        var record: ProductionRecord
        
        private var shortDateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            return formatter
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(record.perfumeName)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.customMint)
                        
                        Text("Record \(record.recordNumber) | Batch \(record.batchNumber) | \(record.packagingType)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    
                    Image(systemName: record.qualityCheckPassed ? "checkmark.circle.fill" : "xmark.octagon.fill")
                        .foregroundColor(record.qualityCheckPassed ? .green : .red)
                        .font(.title2)
                }
                
                Divider()
                
                VStack(spacing: 5) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            RowDetail(icon: "calendar", label: "Date", value: shortDateFormatter.string(from: record.productionDate))
                            RowDetail(icon: "chart.bar.fill", label: "Vol (ML)", value: String(format: "%.1f", record.totalVolumeProduced))
                            RowDetail(icon: "person.crop.square.fill", label: "Supervisor", value: record.supervisorName)
                            RowDetail(icon: "clock.fill", label: "Duration", value: "\(record.processDurationMinutes) M")
                            RowDetail(icon: "cross.case.fill", label: "Equipment", value: record.equipmentUsed)
                            RowDetail(icon: "drop.triangle.fill", label: "Water", value: "\(Int(record.distilledWaterUsedML)) ML")
                            RowDetail(icon: "archivebox.fill", label: "Shelf", value: record.storageShelf)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            RowDetail(icon: "dollarsign.circle", label: "Cost", value: String(format: "$%.2f", record.totalCost))
                            RowDetail(icon: "thermometer", label: "Temp", value: String(format: "%.0f°C", record.roomTemperatureC))
                            RowDetail(icon: "cloud.fill", label: "Humidity", value: String(format: "%.0f%%", record.humidityPercent))
                            RowDetail(icon: "testtube.2", label: "Alcohol", value: "\(Int(record.alcoholUsedML)) ML")
                            RowDetail(icon: "leaf.fill", label: "Essence", value: "\(Int(record.essenceUsedML)) ML")
                            RowDetail(icon: "gauge.badge.plus", label: "Density", value: String(format: "%.2f", record.densityReading))
                            RowDetail(icon: "speedometer", label: "Viscosity", value: String(format: "%.2f", record.viscosityReading))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                HStack {
                    RowDetail(icon: "bottle.fill", label: "Bottles", value: "\(record.bottlesFilled)")
                    RowDetail(icon: "pencil.and.ruler.fill", label: "Labeler", value: record.labelAppliedBy)
                    RowDetail(icon: "checkmark.square.fill", label: "Sample", value: record.sampleTaken ? "Taken" : "No")
                }
                .padding(.top, 5)

                if !record.remarks.isEmpty {
                    Text("Remarks: \(record.remarks)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            .padding(15)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.customMint.opacity(0.15), radius: 8, x: 0, y: 4)
        }
        
        struct RowDetail: View {
            var icon: String
            var label: String
            var value: String
            
            var body: some View {
                HStack(spacing: 5) {
                    Image(systemName: icon)
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Text("\(label):")
                        .font(.caption)
                        .fontWeight(.medium)
                    Text(value)
                        .font(.caption)
                        .foregroundColor(.primary)
                }
            }
        }
    }
    
    var body: some View {
            VStack {
                ProductionRecordSearchBarView(searchText: $searchText)
                
                if filteredRecords.isEmpty {
                    ProductionRecordNoDataView()
                } else {
                    List {
                        ForEach(filteredRecords) { record in
                            NavigationLink(destination: ProductionRecordDetailView(record: record)) {
                                ProductionRecordListRowView(record: record)
                                    .padding(.vertical, 5)
                            }
                            .listRowInsets(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
                        }
                        .onDelete(perform: deleteRecords)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Production Logs")
            .navigationBarItems(trailing:
                Button(action: {
                    isShowingAddView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.customMint)
                }
            )
            .sheet(isPresented: $isShowingAddView) {
                ProductionRecordAddView()
                    .environmentObject(dataStore)
            }
        
    }
    
    private func deleteRecords(offsets: IndexSet) {
        let indicesToDelete = offsets.map { filteredRecords[$0] }
        let originalIndices = IndexSet(indicesToDelete.compactMap { recordToDelete in
            dataStore.productionRecords.firstIndex(where: { $0.id == recordToDelete.id })
        })
        dataStore.deleteProductionRecord(at: originalIndices)
    }
}

@available(iOS 14.0, *)
struct ProductionRecordDetailView: View {
    var record: ProductionRecord
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(record.perfumeName)
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                            
                            Text("Record: \(record.recordNumber) | Batch: \(record.batchNumber)")
                                .font(.headline)
                                .foregroundColor(Color.white.opacity(0.8))
                        }
                        Spacer()
                        Image(systemName: "flask.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                    }
                    
                    Divider().background(Color.white.opacity(0.7))
                    
                    HStack {
                        ProductionRecordDetailFieldRow(label: "Supervisor", value: record.supervisorName, iconName: "person.2.fill", isPrimary: true)
                        Spacer()
                        ProductionRecordDetailFieldRow(label: "Production Date", value: dateFormatter.string(from: record.productionDate), iconName: "calendar.badge.clock", isPrimary: true)
                    }
                    
                    HStack {
                        ProductionRecordDetailFieldRow(label: "Volume Produced", value: String(format: "%.1f ML", record.totalVolumeProduced), iconName: "ruler.fill", isPrimary: true)
                        Spacer()
                        ProductionRecordDetailFieldRow(label: "Total Cost", value: String(format: "$%.2f", record.totalCost), iconName: "banknote.fill", isPrimary: true)
                    }
                }
                .padding(25)
                .background(LinearGradient(gradient: Gradient(colors: [Color.customMint, Color.customMint.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(20)
                .padding(.horizontal)
                .shadow(color: Color.customMint.opacity(0.4), radius: 15, x: 0, y: 8)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Process Metrics")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                    
                    VStack(spacing: 10) {
                        HStack {
                            ProductionRecordDetailFieldRow(label: "Duration", value: "\(record.processDurationMinutes) Mins", iconName: "timer")
                            Spacer()
                            ProductionRecordDetailFieldRow(label: "Assistant", value: record.assistantName, iconName: "person.fill")
                        }
                        
                        HStack {
                            ProductionRecordDetailFieldRow(label: "Room Temp", value: String(format: "%.1f °C", record.roomTemperatureC), iconName: "thermometer")
                            Spacer()
                            ProductionRecordDetailFieldRow(label: "Humidity", value: String(format: "%.1f %%", record.humidityPercent), iconName: "cloud.fill")
                        }
                        
                        ProductionRecordDetailFieldRow(label: "Equipment Used", value: record.equipmentUsed, iconName: "gearshape.fill")
                        
                    }
                    .padding(15)
                    .background(Color.systemBackgroundLight)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Ingredient Usage")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                    
                    VStack(spacing: 10) {
                        HStack {
                            ProductionRecordDetailFieldRow(label: "Alcohol Used", value: String(format: "%.1f ML", record.alcoholUsedML), iconName: "testtube.2")
                            Spacer()
                            ProductionRecordDetailFieldRow(label: "Essence Used", value: String(format: "%.1f ML", record.essenceUsedML), iconName: "leaf.fill")
                        }
                        ProductionRecordDetailFieldRow(label: "Distilled Water Used", value: String(format: "%.1f ML", record.distilledWaterUsedML), iconName: "drop.triangle.fill")
                    }
                    .padding(15)
                    .background(Color.systemBackgroundLight)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Quality & Logistics")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                    
                    VStack(spacing: 10) {
                        HStack {
                            ProductionRecordDetailFieldRow(label: "Density Reading", value: String(format: "%.2f", record.densityReading), iconName: "gauge.badge.plus")
                            Spacer()
                            ProductionRecordDetailFieldRow(label: "Viscosity Reading", value: String(format: "%.2f", record.viscosityReading), iconName: "speedometer")
                        }
                        
                        HStack {
                            ProductionRecordDetailFieldRow(label: "Quality Check Passed", value: record.qualityCheckPassed ? "YES ✅" : "NO ❌", iconName: "checkmark.seal.fill")
                            Spacer()
                            ProductionRecordDetailFieldRow(label: "Sample Taken", value: record.sampleTaken ? "YES" : "NO", iconName: "eyedropper.full.fill")
                        }
                        
                        HStack {
                            ProductionRecordDetailFieldRow(label: "Packaging Type", value: record.packagingType, iconName: "box.truck.fill")
                            Spacer()
                            ProductionRecordDetailFieldRow(label: "Bottles Filled", value: "\(record.bottlesFilled) Pcs", iconName: "bottle.fill")
                        }
                        
                        HStack {
                            ProductionRecordDetailFieldRow(label: "Label Applied By", value: record.labelAppliedBy, iconName: "person.text.rectangle.fill")
                            Spacer()
                            ProductionRecordDetailFieldRow(label: "Storage Shelf", value: record.storageShelf, iconName: "archivebox.fill")
                        }
                    }
                    .padding(15)
                    .background(Color.systemBackgroundLight)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Remarks & Audit")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("**Remarks:** \(record.remarks)")
                            .font(.subheadline)
                            .lineLimit(nil)
                        Divider()
                        ProductionRecordDetailFieldRow(label: "Record Created", value: dateFormatter.string(from: record.recordCreated), iconName: "clock")
                        ProductionRecordDetailFieldRow(label: "Last Updated", value: dateFormatter.string(from: record.recordUpdated), iconName: "clock.fill")
                    }
                    .padding(15)
                    .background(Color.systemBackgroundLight)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 30)
        }
        .navigationTitle("Record \(record.recordNumber)")
        .navigationBarTitleDisplayMode(.inline)
    }
}
