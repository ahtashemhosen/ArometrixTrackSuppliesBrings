
import SwiftUI


@available(iOS 14.0, *)
struct HistoryDetailView: View {
    let history: History
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                
                VStack(alignment: .center, spacing: 10) {
                    Image(systemName: history.isArchived ? "archivebox.fill" : "doc.text.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color(red: 0/255, green: 122/255, blue: 255/255))
                    
                    Text(history.recordTitle)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
                    
                    Text("Type: \(history.recordType) | Priority: \(history.priorityLevel)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(formatDate(history.dateLogged))
                        .font(.subheadline)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color(red: 0/255, green: 122/255, blue: 255/255).opacity(0.1))
                        .cornerRadius(8)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                
                HStack{
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "note.text.badge.plus")
                                .foregroundColor(Color(red: 52/255, green: 199/255, blue: 89/255))
                            Text("Description & Remarks")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Description Text:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(history.descriptionText.isEmpty ? "N/A" : history.descriptionText)
                                .padding(.leading, 5)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Remarks:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(history.remarks.isEmpty ? "N/A" : history.remarks)
                                .padding(.leading, 5)
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "checklist.checked")
                            .foregroundColor(Color(red: 255/255, green: 149/255, blue: 0/255))
                        Text("Change & Status Details")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    
                    VStack(spacing: 8) {
                        HistoryDetailFieldRow(label: "Verification Status", value: history.verificationStatus, iconName: "checkmark.seal.fill")
                        HistoryDetailFieldRow(label: "Status After Change", value: history.statusAfterChange, iconName: "exclamationmark.triangle.fill")
                        HistoryDetailFieldRow(label: "Change Type", value: history.changeType, iconName: "arrow.triangle.swap")
                        HistoryDetailFieldRow(label: "Change Details", value: history.changeDetails, iconName: "text.magnifyingglass")
                        HistoryDetailFieldRow(label: "Related Section", value: history.relatedSection, iconName: "square.grid.2x2.fill")
                        HistoryDetailFieldRow(label: "Assigned Tag", value: history.assignedTag, iconName: "tag.slash.fill")
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(Color(red: 175/255, green: 82/255, blue: 222/255))
                        Text("Personnel & Location")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    
                    VStack(spacing: 8) {
                        HistoryDetailFieldRow(label: "Created By", value: history.createdBy, iconName: "person.fill")
                        HistoryDetailFieldRow(label: "Modified By", value: history.modifiedBy.isEmpty ? "N/A" : history.modifiedBy, iconName: "pencil.circle.fill")
                        HistoryDetailFieldRow(label: "Reviewer Name", value: history.reviewerName.isEmpty ? "N/A" : history.reviewerName, iconName: "eye.fill")
                        HistoryDetailFieldRow(label: "Location of Change", value: history.locationOfChange, iconName: "mappin.and.ellipse")
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "laptopcomputer")
                            .foregroundColor(Color(red: 142/255, green: 142/255, blue: 147/255))
                        Text("System & Value Changes")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    
                    VStack(spacing: 8) {
                        HistoryDetailFieldRow(label: "System Version", value: history.systemVersion, iconName: "gear")
                        HistoryDetailFieldRow(label: "App Version", value: history.appVersion, iconName: "apps.iphone")
                        HistoryDetailFieldRow(label: "Device Name", value: history.deviceName, iconName: "desktopcomputer")
                        HistoryDetailFieldRow(label: "Sync Status", value: history.syncStatus, iconName: "arrow.2.circlepath")
                        HistoryDetailFieldRow(label: "Action Duration (s)", value: String(format: "%.2f", history.actionDurationSeconds), iconName: "timer")
                        Divider()
                        HistoryDetailFieldRow(label: "Previous Value", value: history.previousValue, iconName: "arrow.left.circle")
                        HistoryDetailFieldRow(label: "New Value", value: history.newValue, iconName: "arrow.right.circle")
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(Color(red: 255/255, green: 59/255, blue: 48/255))
                        Text("Timestamps")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    
                    VStack(spacing: 8) {
                        HistoryDetailFieldRow(label: "Date Logged", value: formatDate(history.dateLogged), iconName: "calendar")
                        HistoryDetailFieldRow(label: "Event Timestamp", value: formatDate(history.eventTimestamp), iconName: "clock.fill")
                        HistoryDetailFieldRow(label: "Last Updated", value: formatDate(history.lastUpdated), iconName: "arrow.clockwise")
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                
            }
            .padding()
        }
        .navigationTitle(history.recordTitle)
        .background(Color(.systemGray5).edgesIgnoringSafeArea(.all))
    }
}
