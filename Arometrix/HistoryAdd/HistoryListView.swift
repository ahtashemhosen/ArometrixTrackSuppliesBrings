
import SwiftUI
import Combine

@available(iOS 14.0, *)
struct HistoryListView: View {
    @EnvironmentObject var dataStore: PerfumeDataStore
    @State private var searchText: String = ""
    
    var filteredHistories: [History] {
        if searchText.isEmpty {
            return dataStore.histories
        } else {
            return dataStore.histories.filter { history in
                history.recordTitle.localizedCaseInsensitiveContains(searchText) ||
                history.recordType.localizedCaseInsensitiveContains(searchText) ||
                history.createdBy.localizedCaseInsensitiveContains(searchText) ||
                history.changeType.localizedCaseInsensitiveContains(searchText) ||
                history.relatedSection.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func deleteHistory(at offsets: IndexSet) {
        dataStore.deleteHistory(at: offsets)
    }
    
    var body: some View {
            VStack(spacing: 0) {
                
                HistorySearchBarView(searchText: $searchText)
                    .padding([.horizontal, .top])
                    .padding(.bottom, 10)
                
                if filteredHistories.isEmpty {
                    Spacer()
                    HistoryNoDataView()
                    Spacer()
                } else {
                    List {
                        ForEach(filteredHistories) { history in
                            
                            NavigationLink(destination: HistoryDetailView(history: history)) {
                                HistoryListRowView(history: history)
                                    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                            }
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteHistory)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("History Records")
            .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
            .navigationBarItems(trailing:
                NavigationLink(destination: HistoryAddView()) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(Color(red: 0/255, green: 122/255, blue: 255/255))
                }
            )

    }
}



@available(iOS 14.0, *)
struct HistorySearchBarView: View {
    @Binding var searchText: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            TextField("Search Histories...", text: $searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
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
                .onTapGesture {
                    self.isEditing = true
                }
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.searchText = ""
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default, value: isEditing)
            }
        }
    }
}

@available(iOS 14.0, *)
struct HistoryListRowView: View {
    let history: History
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Image(systemName: history.isArchived ? "archivebox.fill" : "doc.text.fill")
                    .foregroundColor(history.isArchived ? Color(red: 255/255, green: 149/255, blue: 0/255) : Color(red: 52/255, green: 199/255, blue: 89/255))
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text(history.recordTitle)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    Text("Type: \(history.recordType) (\(history.priorityLevel))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                
                Text(history.dateLogged, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(5)
                    .background(Color(.systemGray5))
                    .cornerRadius(5)
            }
            .padding(.bottom, 5)

            Divider()
            
            VStack(alignment: .leading, spacing: 5) {
                
                HStack(spacing: 20) {
                    detailPill(icon: "person.fill", value: history.createdBy, label: "Created By")
                    detailPill(icon: "gearshape.fill", value: history.changeType, label: "Change Type")
                    detailPill(icon: "checkmark.seal.fill", value: history.verificationStatus, label: "Status")
                }
                
                HStack(spacing: 20) {
                    detailPill(icon: "list.bullet.clipboard.fill", value: history.relatedSection, label: "Section")
                    detailPill(icon: "tag.fill", value: history.assignedTag, label: "Tag")
                    detailPill(icon: "iphone", value: history.deviceName, label: "Device")
                }
                
                HStack(spacing: 20) {
                    detailPill(icon: "clock.fill", value: String(format: "%.1fs", history.actionDurationSeconds), label: "Duration")
                    detailPill(icon: "location.fill", value: history.locationOfChange, label: "Location")
                    detailPill(icon: "shuffle", value: history.syncStatus, label: "Sync")
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Description:")
                        .font(.caption2)
                        .foregroundColor(Color(red: 0/255, green: 122/255, blue: 255/255))
                    Text(history.descriptionText)
                        .font(.caption)
                        .lineLimit(1)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Change Details:")
                        .font(.caption2)
                        .foregroundColor(Color(red: 0/255, green: 122/255, blue: 255/255))
                    Text(history.changeDetails)
                        .font(.caption)
                        .lineLimit(1)
                }
                
                HStack(spacing: 20) {
                    detailPill(icon: "arrow.left.circle", value: history.previousValue.isEmpty ? "N/A" : history.previousValue, label: "Prev Value")
                    detailPill(icon: "arrow.right.circle", value: history.newValue.isEmpty ? "N/A" : history.newValue, label: "New Value")
                    detailPill(icon: "person.2.fill", value: history.reviewerName.isEmpty ? "N/A" : history.reviewerName, label: "Reviewer")
                }
            }
            .padding(.horizontal, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
    
    private func detailPill(icon: String, value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 8))
                    .foregroundColor(.gray)
                Text(label)
                    .font(.system(size: 9))
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
            }
            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

@available(iOS 14.0, *)
struct HistoryNoDataView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "doc.text.magnifyingglass")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)
            
            Text("No History Records Found")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Try adding a new record or adjust your search filters.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

@available(iOS 14.0, *)
struct HistoryDetailFieldRow: View {
    let label: String
    let value: String
    let iconName: String
    let valueColor: Color = .primary
    
    var body: some View {
        HStack(alignment: .top) {
            HStack(spacing: 5) {
                Image(systemName: iconName)
                    .foregroundColor(Color(red: 0/255, green: 122/255, blue: 255/255))
                Text(label)
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(value)
                .font(.callout)
                .fontWeight(.regular)
                .foregroundColor(valueColor)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 5)
    }
}






