
import SwiftUI
import Combine

let modelName = "Supply"

@available(iOS 14.0, *)
struct SupplyAddFieldView: View {
    let title: String
    let iconName: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false

    @State private var isFocused: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .foregroundColor(isFocused ? Color.blue : Color.gray)
                    .frame(width: 20)
                
                ZStack(alignment: .leading) {
                    Text(title)
                        .foregroundColor(.gray)
                        .scaleEffect(isFocused || !text.isEmpty ? 0.75 : 1.0)
                        .offset(y: isFocused || !text.isEmpty ? -20 : 0)
                        .animation(.easeInOut(duration: 0.2), value: isFocused)
                        .animation(.easeInOut(duration: 0.2), value: text.isEmpty)

                    if isSecure {
                        SecureField("", text: $text, onCommit: { isFocused = false })
                            .font(.body)
                            .onTapGesture { self.isFocused = true }
                    } else {
                        TextField("", text: $text, onEditingChanged: { isEditing in
                            self.isFocused = isEditing
                        })
                        .keyboardType(keyboardType)
                        .font(.body)
                    }
                }
            }
            .padding(.top, isFocused || !text.isEmpty ? 15 : 0)
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isFocused ? Color.blue : Color(UIColor.systemGray4), lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct SupplyAddDatePickerView: View {
    let title: String
    let iconName: String
    @Binding var date: Date

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .foregroundColor(.blue)
                    .frame(width: 20)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(UIColor.systemGray4), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct SupplyAddToggleView: View {
    let title: String
    let iconName: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .foregroundColor(isOn ? Color.green : Color.red)
                .frame(width: 20)
            Text(title)
                .font(.body)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .padding(.trailing, 4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(UIColor.systemGray4), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct SupplyAddSectionHeaderView: View {
    let title: String
    let iconName: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
            Text(title)
                .fontWeight(.bold)
        }
        .foregroundColor(.primary)
        .font(.title3)
        .padding(.horizontal)
        .padding(.top, 15)
    }
}

@available(iOS 14.0, *)
struct SupplyAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataStore: PerfumeDataStore

    @State private var supplyID: String = ""
    @State private var itemName: String = ""
    @State private var supplierName: String = ""
    @State private var supplierContact: String = ""
    @State private var purchaseOrderNumber: String = ""
    @State private var receivedDate: Date = Date()
    @State private var quantityReceived: String = ""
    @State private var unitType: String = ""
    @State private var unitCost: String = ""
    @State private var totalCost: String = ""
    @State private var paymentStatus: String = ""
    @State private var paymentMethod: String = ""
    @State private var invoiceNumber: String = ""
    @State private var qualityCheckStatus: String = ""
    @State private var warehouseLocation: String = ""
    @State private var reorderThreshold: String = ""
    @State private var stockAvailable: String = ""
    @State private var expirationDate: Date = Date().addingTimeInterval(31536000)
    @State private var remarks: String = ""
    @State private var isReturnable: Bool = false
    @State private var handlingInstructions: String = ""
    @State private var shippingMethod: String = ""
    @State private var trackingNumber: String = ""
    @State private var deliveryStatus: String = ""
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    private func validateAndSave() {
        var errors: [String] = []

        if supplyID.isEmpty { errors.append("Supply ID is required.") }
        if itemName.isEmpty { errors.append("Item Name is required.") }
        if supplierName.isEmpty { errors.append("Supplier Name is required.") }
        if supplierContact.isEmpty { errors.append("Supplier Contact is required.") }
        if purchaseOrderNumber.isEmpty { errors.append("P.O. Number is required.") }
        if unitType.isEmpty { errors.append("Unit Type is required.") }
        if paymentStatus.isEmpty { errors.append("Payment Status is required.") }
        if paymentMethod.isEmpty { errors.append("Payment Method is required.") }
        if invoiceNumber.isEmpty { errors.append("Invoice Number is required.") }
        if qualityCheckStatus.isEmpty { errors.append("Quality Check Status is required.") }
        if warehouseLocation.isEmpty { errors.append("Warehouse Location is required.") }
        if handlingInstructions.isEmpty { errors.append("Handling Instructions are required.") }
        if shippingMethod.isEmpty { errors.append("Shipping Method is required.") }
        if trackingNumber.isEmpty { errors.append("Tracking Number is required.") }
        if deliveryStatus.isEmpty { errors.append("Delivery Status is required.") }

        guard let quantity = Double(quantityReceived), quantity >= 0 else {
            errors.append("Quantity Received must be a valid number.")
            showAlert = true
            return
        }
        guard let costPerUnit = Double(unitCost), costPerUnit >= 0 else {
            errors.append("Unit Cost must be a valid number.")
            showAlert = true
            return
        }
        guard let total = Double(totalCost), total >= 0 else {
            errors.append("Total Cost must be a valid number.")
            showAlert = true
            return
        }
        guard let threshold = Double(reorderThreshold), threshold >= 0 else {
            errors.append("Reorder Threshold must be a valid number.")
            showAlert = true
            return
        }
        guard let stock = Double(stockAvailable), stock >= 0 else {
            errors.append("Stock Available must be a valid number.")
            showAlert = true
            return
        }

        if errors.isEmpty {
            let newSupply = Supply(
                supplyID: supplyID,
                itemName: itemName,
                supplierName: supplierName,
                supplierContact: supplierContact,
                purchaseOrderNumber: purchaseOrderNumber,
                receivedDate: receivedDate,
                quantityReceived: quantity,
                unitType: unitType,
                unitCost: costPerUnit,
                totalCost: total,
                paymentStatus: paymentStatus,
                paymentMethod: paymentMethod,
                invoiceNumber: invoiceNumber,
                qualityCheckStatus: qualityCheckStatus,
                warehouseLocation: warehouseLocation,
                reorderThreshold: threshold,
                stockAvailable: stock,
                expirationDate: expirationDate,
                remarks: remarks,
                isReturnable: isReturnable,
                handlingInstructions: handlingInstructions,
                shippingMethod: shippingMethod,
                trackingNumber: trackingNumber,
                deliveryStatus: deliveryStatus,
                lastUpdated: Date()
            )

            dataStore.addSupply(newSupply)
            alertMessage = "✅ Success! New supply item **\(itemName)** added."
            showAlert = true
        } else {
            alertMessage = "🛑 The following errors occurred:\n\n" + errors.joined(separator: "\n")
            showAlert = true
        }
    }


    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                SupplyAddSectionHeaderView(title: "Item Details & IDs", iconName: "barcode")

                HStack {
                    SupplyAddFieldView(title: "Supply ID", iconName: "tag", text: $supplyID)
                    SupplyAddFieldView(title: "Item Name", iconName: "cube", text: $itemName)
                }

                SupplyAddFieldView(title: "Purchase Order No.", iconName: "doc.text", text: $purchaseOrderNumber)
                SupplyAddFieldView(title: "Invoice Number", iconName: "number.square", text: $invoiceNumber)

                SupplyAddSectionHeaderView(title: "Supplier & Contact", iconName: "person.3")

                HStack {
                    SupplyAddFieldView(title: "Supplier Name", iconName: "person.circle", text: $supplierName)
                    SupplyAddFieldView(title: "Supplier Contact", iconName: "phone", text: $supplierContact)
                }

                SupplyAddSectionHeaderView(title: "Inventory & Pricing", iconName: "dollarsign.circle")

                HStack {
                    SupplyAddFieldView(title: "Qty Received", iconName: "shippingbox", text: $quantityReceived, keyboardType: .decimalPad)
                    SupplyAddFieldView(title: "Unit Type", iconName: "ruler", text: $unitType)
                }
                
                HStack {
                    SupplyAddFieldView(title: "Unit Cost", iconName: "o.circle", text: $unitCost, keyboardType: .decimalPad)
                    SupplyAddFieldView(title: "Total Cost", iconName: "t.circle", text: $totalCost, keyboardType: .decimalPad)
                }
                
                HStack {
                    SupplyAddFieldView(title: "Stock Available", iconName: "bag", text: $stockAvailable, keyboardType: .decimalPad)
                    SupplyAddFieldView(title: "Reorder Threshold", iconName: "bell.badge", text: $reorderThreshold, keyboardType: .decimalPad)
                }
                
                SupplyAddSectionHeaderView(title: "Timeline & Status", iconName: "calendar.badge.clock")

                SupplyAddDatePickerView(title: "Received Date", iconName: "calendar.badge.plus", date: $receivedDate)
                SupplyAddDatePickerView(title: "Expiration Date", iconName: "hourglass.badge.checkmark", date: $expirationDate)

                SupplyAddSectionHeaderView(title: "Quality & Compliance", iconName: "checkmark.shield")

                SupplyAddFieldView(title: "Quality Status", iconName: "hand.raised.slash", text: $qualityCheckStatus)
                SupplyAddFieldView(title: "Payment Status", iconName: "creditcard", text: $paymentStatus)
                SupplyAddFieldView(title: "Payment Method", iconName: "banknote", text: $paymentMethod)
                
                SupplyAddFieldView(title: "Warehouse Location", iconName: "map", text: $warehouseLocation)
                
                SupplyAddToggleView(title: "Is Returnable", iconName: "return", isOn: $isReturnable)
                
                SupplyAddFieldView(title: "Handling Instructions", iconName: "exclamationmark.triangle", text: $handlingInstructions)
                
                SupplyAddSectionHeaderView(title: "Shipping Details", iconName: "truck.box")
                
                HStack {
                    SupplyAddFieldView(title: "Shipping Method", iconName: "airplane", text: $shippingMethod)
                    SupplyAddFieldView(title: "Tracking Number", iconName: "dot.radiowaves.right", text: $trackingNumber)
                }
                SupplyAddFieldView(title: "Delivery Status", iconName: "arrow.down.to.line.alt", text: $deliveryStatus)
                
                SupplyAddSectionHeaderView(title: "Remarks", iconName: "note.text")
                
                TextEditor(text: $remarks)
                    .frame(height: 100)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(UIColor.systemGray4), lineWidth: 1)
                    )
                    .padding(.horizontal)

                Button(action: validateAndSave) {
                    Text("Add New Supply Item")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.blue)
                        )
                }
                .padding(.horizontal)
                .padding(.bottom, 50)
            }
        }
        .navigationTitle("New Supply Item")
        .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Supply Entry Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

@available(iOS 14.0, *)
struct SupplySearchBarView: View {
    @Binding var searchText: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            TextField("Search supplies (e.g., Glass Bottles)", text: $searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.gray).opacity(0.3))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)

                        if isEditing {
                            Button(action: {
                                self.searchText = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.searchText = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                        .foregroundColor(.blue)
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default, value: isEditing)
            }
        }
    }
}

@available(iOS 14.0, *)
struct SupplyListRowView: View {
    let supply: Supply

    private func SupplyRowDetail(icon: String, label: String, value: String, accentColor: Color = .blue) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .foregroundColor(accentColor)
                .font(.caption)
            VStack(alignment: .leading, spacing: 0) {
                Text(label)
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    private func getColor(for status: String) -> Color {
        switch status {
        case "Approved", "Paid", "Delivered":
            return .green
        case "Pending", "In Transit":
            return .orange
        case "Rejected", "Overdue":
            return .red
        default:
            return .gray
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(supply.itemName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(supply.supplierName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(Int(supply.stockAvailable)) \(supply.unitType)")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(supply.stockAvailable <= supply.reorderThreshold ? .red : .green)
                    Text("ID: \(supply.supplyID)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding([.top, .horizontal])

            Divider().padding(.horizontal)

            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    SupplyRowDetail(icon: "dollarsign.circle", label: "Total Cost", value: "$\(String(format: "%.2f", supply.totalCost))", accentColor: Color(red: 0.1, green: 0.5, blue: 0.1))
                    SupplyRowDetail(icon: "map", label: "Location", value: supply.warehouseLocation, accentColor: .purple)
                    SupplyRowDetail(icon: "doc.text", label: "P.O. No.", value: supply.purchaseOrderNumber)
                    SupplyRowDetail(icon: "return", label: "Returnable", value: supply.isReturnable ? "Yes" : "No", accentColor: supply.isReturnable ? .orange : .gray)
                    SupplyRowDetail(icon: "phone", label: "Supplier Contact", value: supply.supplierContact, accentColor: .pink)
                    SupplyRowDetail(icon: "airplane", label: "Shipping Method", value: supply.shippingMethod, accentColor: Color(red: 0.0, green: 0.5, blue: 0.5))
                    SupplyRowDetail(icon: "number.square", label: "Invoice", value: supply.invoiceNumber)
                    SupplyRowDetail(icon: "bag", label: "Stock Available", value: "\(Int(supply.stockAvailable)) \(supply.unitType)")

                }
                
                VStack(alignment: .leading, spacing: 8) {
                    SupplyRowDetail(icon: "hand.raised.slash", label: "Quality", value: supply.qualityCheckStatus, accentColor: getColor(for: supply.qualityCheckStatus))
                    SupplyRowDetail(icon: "creditcard", label: "Payment", value: supply.paymentStatus, accentColor: getColor(for: supply.paymentStatus))
                    SupplyRowDetail(icon: "shippingbox.fill", label: "Threshold", value: "\(Int(supply.reorderThreshold)) \(supply.unitType)", accentColor: .yellow)
                    SupplyRowDetail(icon: "hourglass.tophalf.fill", label: "Expiry", value: formatDate(supply.expirationDate), accentColor: .red)
                    SupplyRowDetail(icon: "truck.box.fill", label: "Delivery", value: supply.deliveryStatus, accentColor: getColor(for: supply.deliveryStatus))
                    SupplyRowDetail(icon: "dot.radiowaves.right", label: "Tracking", value: supply.trackingNumber)
                    SupplyRowDetail(icon: "banknote", label: "Payment Method", value: supply.paymentMethod)
                    SupplyRowDetail(icon: "calendar", label: "Received Date", value: formatDate(supply.receivedDate))
                }
            }
            .padding([.bottom, .horizontal])
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

@available(iOS 14.0, *)
struct SupplyNoDataView: View {
    let message: String

    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "tray.fill")
                .font(.system(size: 80))
                .foregroundColor(Color.gray.opacity(0.4))
                .padding(.bottom, 10)
            
            Text(message)
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Text("Try refining your search or add a new item.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

@available(iOS 14.0, *)
struct SupplyListView: View {
    @EnvironmentObject var dataStore: PerfumeDataStore
    @State private var searchText: String = ""
    @State private var isShowingAddView: Bool = false

    var filteredSupplies: [Supply] {
        if searchText.isEmpty {
            return dataStore.supplies
        } else {
            return dataStore.supplies.filter { supply in
                supply.itemName.localizedCaseInsensitiveContains(searchText) ||
                supply.supplierName.localizedCaseInsensitiveContains(searchText) ||
                supply.supplyID.localizedCaseInsensitiveContains(searchText) ||
                supply.warehouseLocation.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
            VStack {
                SupplySearchBarView(searchText: $searchText)
                    .padding(.top, 8)

                if filteredSupplies.isEmpty {
                    SupplyNoDataView(message: searchText.isEmpty ? "No supply items have been recorded yet." : "No supplies match your search criteria.")
                } else {
                    List {
                        ForEach(filteredSupplies) { supply in
                            NavigationLink(destination: SupplyDetailView(supply: supply)) {
                                SupplyListRowView(supply: supply)
                                    .listRowInsets(EdgeInsets())
                                    .background(Color.clear)
                            }
                        }
                        .listRowBackground(Color.clear)
                        
                        
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Inventory Supplies")
            .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
            .navigationBarItems(
                trailing:
                    Button(action: { isShowingAddView = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
            )
            .sheet(isPresented: $isShowingAddView) {
                NavigationView {
                    SupplyAddView()
                        .environmentObject(dataStore)
                }
            }
        }
    
}

@available(iOS 14.0, *)
struct SupplyDetailFieldRow: View {
    let iconName: String
    let label: String
    let value: String
    let valueColor: Color

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: iconName)
                .foregroundColor(.blue)
                .frame(width: 20)
            
                Text(label)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
            Spacer()
            
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(valueColor)
                    .fixedSize(horizontal: false, vertical: true)
            
        }
        .padding(.vertical, 4)
    }
}

@available(iOS 14.0, *)
struct SupplyDetailGroupBlock<Content: View>: View {
    let title: String
    let iconName: String
    let content: Content

    init(title: String, iconName: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.iconName = iconName
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: iconName)
                Text(title)
                    .font(.headline)
            }
            .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 10) {
                content
            }
            .padding(.horizontal, 10)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
        )
    }
}

@available(iOS 14.0, *)
struct SupplyDetailView: View {
    let supply: Supply
    
    private let dateFmt: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    private func getColor(for status: String) -> Color {
        switch status {
        case "Approved", "Paid", "Delivered":
            return .green
        case "Pending", "In Transit":
            return .orange
        case "Rejected", "Overdue":
            return .red
        default:
            return .gray
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(supply.itemName)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Supplier: \(supply.supplierName)")
                                .font(.title3)
                                .fontWeight(.medium)
                            Text("P.O. \(supply.purchaseOrderNumber) | ID: \(supply.supplyID)")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("\(Int(supply.stockAvailable))")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(supply.stockAvailable <= supply.reorderThreshold ? .red : .green)
                            Text(supply.unitType)
                                .font(.caption)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue.opacity(0.1))
                )
                .padding(.horizontal)
                
                VStack(spacing: 15) {
                    
                    VStack(spacing: 20) {
                        SupplyDetailGroupBlock(title: "Cost & Payments", iconName: "dollarsign.square") {
                            SupplyDetailFieldRow(iconName: "o.circle", label: "Unit Cost", value: "$\(String(format: "%.2f", supply.unitCost))", valueColor: .primary)
                            SupplyDetailFieldRow(iconName: "t.circle", label: "Total Cost", value: "$\(String(format: "%.2f", supply.totalCost))", valueColor: .primary)
                            SupplyDetailFieldRow(iconName: "creditcard.fill", label: "Payment Status", value: supply.paymentStatus, valueColor: getColor(for: supply.paymentStatus))
                            SupplyDetailFieldRow(iconName: "banknote.fill", label: "Payment Method", value: supply.paymentMethod, valueColor: .primary)
                            SupplyDetailFieldRow(iconName: "number.square.fill", label: "Invoice Number", value: supply.invoiceNumber, valueColor: .primary)
                        }
                        
                        SupplyDetailGroupBlock(title: "Inventory & Storage", iconName: "shippingbox.fill") {
                            SupplyDetailFieldRow(iconName: "arrow.up.bin", label: "Quantity Received", value: "\(String(format: "%.2f", supply.quantityReceived)) \(supply.unitType)", valueColor: .primary)
                            SupplyDetailFieldRow(iconName: "map.fill", label: "Warehouse Location", value: supply.warehouseLocation, valueColor: .primary)
                            SupplyDetailFieldRow(iconName: "bag.fill", label: "Stock Available", value: "\(String(format: "%.0f", supply.stockAvailable)) \(supply.unitType)", valueColor: supply.stockAvailable <= supply.reorderThreshold ? .red : .primary)
                            SupplyDetailFieldRow(iconName: "bell.badge.fill", label: "Reorder Threshold", value: "\(String(format: "%.0f", supply.reorderThreshold)) \(supply.unitType)", valueColor: .orange)
                            SupplyDetailFieldRow(iconName: "return", label: "Is Returnable", value: supply.isReturnable ? "Yes" : "No", valueColor: supply.isReturnable ? .orange : .gray)
                        }
                    }
                    
                    VStack(spacing: 20) {
                        SupplyDetailGroupBlock(title: "Quality & Compliance", iconName: "checkmark.shield.fill") {
                            SupplyDetailFieldRow(iconName: "hand.raised.fill", label: "Quality Check Status", value: supply.qualityCheckStatus, valueColor: getColor(for: supply.qualityCheckStatus))
                            SupplyDetailFieldRow(iconName: "exclamationmark.triangle.fill", label: "Handling Instructions", value: supply.handlingInstructions, valueColor: .primary)
                            SupplyDetailFieldRow(iconName: "calendar.badge.plus", label: "Received Date", value: dateFmt.string(from: supply.receivedDate), valueColor: .primary)
                            SupplyDetailFieldRow(iconName: "hourglass.tophalf.fill", label: "Expiration Date", value: dateFmt.string(from: supply.expirationDate), valueColor: .red)
                        }
                        
                        SupplyDetailGroupBlock(title: "Shipping Information", iconName: "truck.box.badge.in.fill") {
                            SupplyDetailFieldRow(iconName: "person.2.fill", label: "Supplier Contact", value: supply.supplierContact, valueColor: .primary)
                            SupplyDetailFieldRow(iconName: "airplane", label: "Shipping Method", value: supply.shippingMethod, valueColor: .primary)
                            SupplyDetailFieldRow(iconName: "dot.radiowaves.right", label: "Tracking Number", value: supply.trackingNumber, valueColor: .primary)
                            SupplyDetailFieldRow(iconName: "arrow.down.to.line.alt", label: "Delivery Status", value: supply.deliveryStatus, valueColor: getColor(for: supply.deliveryStatus))
                            SupplyDetailFieldRow(iconName: "clock.fill", label: "Last Updated", value: dateFmt.string(from: supply.lastUpdated), valueColor: .secondary)
                        }
                    }
                }
                .padding(.horizontal)
                
                SupplyDetailGroupBlock(title: "Remarks", iconName: "note.text.fill") {
                    Text(supply.remarks)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .navigationTitle("Supply Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
    }
}
