import SwiftUI

@available(iOS 14.0, *)
struct HistoryAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataStore: PerfumeDataStore
    
    @State private var recordType: String = ""
    @State private var recordTitle: String = ""
    @State private var descriptionText: String = ""
    @State private var dateLogged: Date = Date()
    @State private var createdBy: String = ""
    @State private var modifiedBy: String = ""
    @State private var changeType: String = ""
    @State private var changeDetails: String = ""
    @State private var previousValue: String = ""
    @State private var newValue: String = ""
    @State private var verificationStatus: String = ""
    @State private var remarks: String = ""
    @State private var isArchived: Bool = false
    @State private var relatedSection: String = ""
    @State private var priorityLevel: String = ""
    @State private var eventTimestamp: Date = Date()
    @State private var systemVersion: String = ""
    @State private var appVersion: String = ""
    @State private var deviceName: String = ""
    @State private var actionDurationSeconds: String = ""
    @State private var statusAfterChange: String = ""
    @State private var reviewerName: String = ""
    @State private var locationOfChange: String = ""
    @State private var assignedTag: String = ""
    @State private var syncStatus: String = ""
    @State private var lastUpdated: Date = Date()
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private func validateAndSave() {
        var errors: [String] = []
        
        if recordType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("• Record Type is missing.") }
        if recordTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("• Record Title is missing.") }
        if createdBy.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("• Created By is missing.") }
        if modifiedBy.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("• Modified By is missing.") }
        if changeType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("• Change Type is missing.") }
        if changeDetails.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("• Change Details is missing.") }
        if previousValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("• Previous Value is missing.") }
        if newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("• New Value is missing.") }
        if verificationStatus.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("• Verification Status is missing.") }
        if remarks.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("• Remarks is missing.") }
        if relatedSection.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("• Related Section is missing.") }
        if priorityLevel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("• Priority Level is missing.") }
        if systemVersion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("• System Version is missing.") }
        if appVersion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("• App Version is missing.") }
        if deviceName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("• Device Name is missing.") }
        if statusAfterChange.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("• Status After Change is missing.") }
        if reviewerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("• Reviewer Name is missing.") }
        if locationOfChange.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("• Location of Change is missing.") }
        if assignedTag.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("• Assigned Tag is missing.") }
        if syncStatus.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("• Sync Status is missing.") }

        
        let duration = Double(actionDurationSeconds) ?? -1
        if duration < 0 { errors.append("• Action Duration must be a valid number.") }
        
        if errors.isEmpty {
            let newHistory = History(
                recordType: recordType,
                recordTitle: recordTitle,
                descriptionText: descriptionText,
                dateLogged: dateLogged,
                createdBy: createdBy,
                modifiedBy: modifiedBy,
                changeType: changeType,
                changeDetails: changeDetails,
                previousValue: previousValue,
                newValue: newValue,
                verificationStatus: verificationStatus,
                remarks: remarks,
                isArchived: isArchived,
                relatedSection: relatedSection,
                priorityLevel: priorityLevel,
                eventTimestamp: eventTimestamp,
                systemVersion: systemVersion,
                appVersion: appVersion,
                deviceName: deviceName,
                actionDurationSeconds: duration,
                statusAfterChange: statusAfterChange,
                reviewerName: reviewerName,
                locationOfChange: locationOfChange,
                assignedTag: assignedTag,
                syncStatus: syncStatus,
                lastUpdated: lastUpdated
            )
            dataStore.addHistory(newHistory)
            
            alertMessage = "✅ Success!\n\nHistory record '\(recordTitle)' added successfully."
            showAlert = true
            
        } else {
            alertMessage = "❌ Validation Failed:\n\n" + errors.joined(separator: "\n")
            showAlert = true
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                HistoryAddSectionHeaderView(title: "Core Record Details", iconName: "list.clipboard.fill")
                
                VStack(spacing: 15) {
                    HStack(spacing: 15) {
                        HistoryAddFieldView(title: "Record Title", text: $recordTitle, iconName: "textformat.alt")
                        HistoryAddFieldView(title: "Record Type", text: $recordType, iconName: "tag.fill")
                    }
                    
                    HistoryAddFieldView(title: "Description Text", text: $descriptionText, iconName: "note.text")
                }
                
                HistoryAddSectionHeaderView(title: "Change & Status", iconName: "arrow.right.arrow.left.square.fill")
                
                VStack(spacing: 15) {
                    HStack(spacing: 15) {
                        HistoryAddFieldView(title: "Change Type", text: $changeType, iconName: "arrow.triangle.swap")
                        HistoryAddFieldView(title: "Change Details", text: $changeDetails, iconName: "text.magnifyingglass")
                    }
                    
                    HStack(spacing: 15) {
                        HistoryAddFieldView(title: "Status After Change", text: $statusAfterChange, iconName: "exclamationmark.triangle.fill")
                        HistoryAddFieldView(title: "Verification Status", text: $verificationStatus, iconName: "checkmark.seal.fill")
                    }
                    
                    HistoryAddToggleView(title: "Is Archived", isOn: $isArchived, iconName: "archivebox.fill")
                }
                
                HistoryAddSectionHeaderView(title: "Values & Remarks", iconName: "chart.bar.doc.horizontal.fill")
                
                VStack(spacing: 15) {
                    HStack(spacing: 15) {
                        HistoryAddFieldView(title: "Previous Value", text: $previousValue, iconName: "arrow.left.circle")
                        HistoryAddFieldView(title: "New Value", text: $newValue, iconName: "arrow.right.circle")
                    }
                    HistoryAddFieldView(title: "Remarks", text: $remarks, iconName: "quote.bubble.fill")
                    
                    HStack(spacing: 15) {
                        HistoryAddFieldView(title: "Priority Level", text: $priorityLevel, iconName: "flame.fill")
                        HistoryAddFieldView(title: "Assigned Tag", text: $assignedTag, iconName: "tag.slash.fill")
                    }
                }
                
                HistoryAddSectionHeaderView(title: "Personnel & Location", iconName: "person.3.fill")
                
                VStack(spacing: 15) {
                    HStack(spacing: 15) {
                        HistoryAddFieldView(title: "Created By", text: $createdBy, iconName: "person.fill")
                        HistoryAddFieldView(title: "Modified By", text: $modifiedBy, iconName: "pencil.circle.fill")
                    }
                    
                    HStack(spacing: 15) {
                        HistoryAddFieldView(title: "Reviewer Name", text: $reviewerName, iconName: "eye.fill")
                        HistoryAddFieldView(title: "Location of Change", text: $locationOfChange, iconName: "mappin.and.ellipse")
                    }
                }
                
                HistoryAddSectionHeaderView(title: "System & Timing", iconName: "laptopcomputer")
                
                VStack(spacing: 15) {
                    HStack(spacing: 15) {
                        HistoryAddFieldView(title: "System Version", text: $systemVersion, iconName: "gear")
                        HistoryAddFieldView(title: "App Version", text: $appVersion, iconName: "apps.iphone")
                    }
                    
                    HStack(spacing: 15) {
                        HistoryAddFieldView(title: "Device Name", text: $deviceName, iconName: "desktopcomputer")
                        HistoryAddFieldView(title: "Sync Status", text: $syncStatus, iconName: "arrow.2.circlepath")
                    }
                    
                    HStack(spacing: 15) {
                        HistoryAddFieldView(title: "Action Duration (s)", text: $actionDurationSeconds, iconName: "timer", isNumber: true)
                        HistoryAddFieldView(title: "Related Section", text: $relatedSection, iconName: "square.grid.2x2.fill")
                    }
                    
                    HistoryAddDatePickerView(title: "Date Logged", date: $dateLogged, iconName: "calendar")
                    HistoryAddDatePickerView(title: "Event Timestamp", date: $eventTimestamp, iconName: "clock.fill")
                    
                    
                    HistoryAddDatePickerView(title: "Last Updated", date: $lastUpdated, iconName: "arrow.clockwise")
                }
                
                Button(action: validateAndSave) {
                    Text("Save History Record")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0/255, green: 122/255, blue: 255/255))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: Color(red: 0/255, green: 122/255, blue: 255/255).opacity(0.4), radius: 5, x: 0, y: 5)
                }
                .padding(.top, 20)
                
            }
            .padding()
        }
        .navigationTitle("Add New History Record")
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertMessage.contains("Success") ? "Operation Complete" : "Error"), 
                  message: Text(alertMessage), 
                  dismissButton: .default(Text("OK")) {
                if alertMessage.contains("Success") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
}


@available(iOS 14.0, *)
struct HistoryAddDatePickerView: View {
    let title: String
    @Binding var date: Date
    let iconName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(Color(red: 0/255, green: 122/255, blue: 255/255))
                
                Spacer()
                DatePicker("", selection: $date)
                    .labelsHidden()
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        }
    }
}

@available(iOS 14.0, *)
struct HistoryAddFieldView: View {
    let title: String
    @Binding var text: String
    let iconName: String
    var isNumber: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
                .opacity(text.isEmpty ? 0 : 1)
                .animation(.easeOut(duration: 0.1), value: text.isEmpty)
            
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(Color(red: 0/255, green: 122/255, blue: 255/255))
                
                TextField(title, text: $text)
                    .keyboardType(isNumber ? .decimalPad : .default)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        }
    }
}

@available(iOS 14.0, *)
struct HistoryAddToggleView: View {
    let title: String
    @Binding var isOn: Bool
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(Color(red: 0/255, green: 122/255, blue: 255/255))
            
            Text(title)
                .foregroundColor(.primary)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

@available(iOS 14.0, *)
struct HistoryAddSectionHeaderView: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.headline)
                .foregroundColor(Color(red: 0/255, green: 122/255, blue: 255/255))
            Text(title)
                .font(.headline)
                .fontWeight(.medium)
            Spacer()
        }
        .padding(.top, 10)
    }
}
