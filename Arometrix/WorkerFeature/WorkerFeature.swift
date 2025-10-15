
import SwiftUI
import Combine

fileprivate extension DateFormatter {
    static let workerDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    static let workerDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

@available(iOS 14.0, *)
struct WorkerFeature: View {
    @EnvironmentObject var dataStore: PerfumeDataStore
    
    var body: some View {
        NavigationView {
            WorkerListView()
                .environmentObject(dataStore)
        }
    }
}

@available(iOS 14.0, *)
struct WorkerAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataStore: PerfumeDataStore
    
    @State private var name: String = ""
    @State private var employeeID: String = ""
    @State private var role: String = ""
    @State private var department: String = ""
    @State private var joinDate: Date = Date()
    @State private var shiftTime: String = "Morning"
    @State private var hourlyRate: String = "15.00"
    @State private var totalHoursWorked: String = "0.0"
    @State private var totalEarnings: String = "0.0"
    @State private var contactNumber: String = ""
    @State private var address: String = ""
    @State private var emergencyContact: String = ""
    @State private var email: String = ""
    @State private var isActive: Bool = true
    @State private var leaveDaysTaken: String = "0"
    @State private var performanceRating: String = "Good"
    @State private var skillLevel: String = "Intermediate"
    @State private var assignedTasks: String = "Mixing, Packaging"
    @State private var safetyTrainingCompleted: Bool = false
    @State private var lastAttendanceDate: Date = Date()
    @State private var nextEvaluationDate: Date = Calendar.current.date(byAdding: .month, value: 6, to: Date())!
    @State private var notes: String = ""
    @State private var preferredLanguage: String = "English"
    @State private var certifications: String = "Safety"
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let shiftTimes = ["Morning", "Evening", "Night"]
    let performanceRatings = ["Excellent", "Good", "Average", "Poor"]
    let skillLevels = ["Beginner", "Intermediate", "Advanced"]
    
    private func validateWorker() -> [String] {
        var errors: [String] = []
        
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Name is required.") }
        if employeeID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Employee ID is required.") }
        if role.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Role is required.") }
        if department.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Department is required.") }
        if Double(hourlyRate) == nil || (Double(hourlyRate) ?? 0) <= 0 { errors.append("Hourly Rate must be a positive number.") }
        if Double(totalHoursWorked) == nil || (Double(totalHoursWorked) ?? 0) < 0 { errors.append("Total Hours Worked must be a number.") }
        if Double(totalEarnings) == nil || (Double(totalEarnings) ?? 0) < 0 { errors.append("Total Earnings must be a number.") }
        if Int(leaveDaysTaken) == nil || (Int(leaveDaysTaken) ?? 0) < 0 { errors.append("Leave Days must be a non-negative integer.") }
        
        return errors
    }
    
    private func saveWorker() {
        let errors = validateWorker()
        
        if errors.isEmpty {
            let newWorker = Worker(
                name: name,
                employeeID: employeeID,
                role: role,
                department: department,
                joinDate: joinDate,
                shiftTime: shiftTime,
                hourlyRate: Double(hourlyRate) ?? 0.0,
                totalHoursWorked: Double(totalHoursWorked) ?? 0.0,
                totalEarnings: Double(totalEarnings) ?? 0.0,
                contactNumber: contactNumber,
                address: address,
                emergencyContact: emergencyContact,
                email: email,
                isActive: isActive,
                leaveDaysTaken: Int(leaveDaysTaken) ?? 0,
                performanceRating: performanceRating,
                skillLevel: skillLevel,
                assignedTasks: assignedTasks.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) },
                safetyTrainingCompleted: safetyTrainingCompleted,
                lastAttendanceDate: lastAttendanceDate,
                nextEvaluationDate: nextEvaluationDate,
                notes: notes,
                preferredLanguage: preferredLanguage,
                certifications: certifications.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) },
                lastUpdated: Date()
            )
            
            dataStore.addWorker(newWorker)
            alertMessage = "Worker '\(newWorker.name)' successfully added! 🎉"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                presentationMode.wrappedValue.dismiss()
            }
        } else {
            alertMessage = "Please correct the following errors:\n\n• " + errors.joined(separator: "\n• ")
        }
        
        showingAlert = true
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                
                WorkerAddSectionHeaderView(title: "Identity & Role", iconName: "person.text.rectangle.fill")
                
                HStack(spacing: 15) {
                    WorkerAddFieldView(title: "Name", text: $name, icon: "person.fill")
                    WorkerAddFieldView(title: "ID", text: $employeeID, icon: "number.square.fill")
                }
                
                HStack(spacing: 15) {
                    WorkerAddFieldView(title: "Role", text: $role, icon: "briefcase.fill")
                    WorkerAddFieldView(title: "Department", text: $department, icon: "building.2.fill")
                }
                
                WorkerAddDatePickerView(title: "Join Date", date: $joinDate, icon: "calendar")
                
                WorkerAddSectionHeaderView(title: "Compensation & Status", iconName: "dollarsign.circle.fill")
                
                HStack(spacing: 15) {
                    WorkerAddFieldView(title: "Hourly Rate", text: $hourlyRate, icon: "clock.fill", keyboardType: .decimalPad)
                    WorkerAddFieldView(title: "Total Hours", text: $totalHoursWorked, icon: "timer", keyboardType: .decimalPad)
                }
                
                HStack(spacing: 15) {
                    WorkerAddFieldView(title: "Total Earnings", text: $totalEarnings, icon: "creditcard.fill", keyboardType: .decimalPad)
                    WorkerAddFieldView(title: "Leave Days Taken", text: $leaveDaysTaken, icon: "figure.walk", keyboardType: .numberPad)
                }
                
                WorkerAddPickerView(title: "Shift Time", selection: $shiftTime, options: shiftTimes, icon: "moon.stars.fill")
                
                WorkerAddSectionHeaderView(title: "Contact Information", iconName: "phone.circle.fill")
                
                HStack(spacing: 15) {
                    WorkerAddFieldView(title: "Contact Number", text: $contactNumber, icon: "phone.fill", keyboardType: .phonePad)
                    WorkerAddFieldView(title: "Emergency Contact", text: $emergencyContact, icon: "exclamationmark.triangle.fill", keyboardType: .phonePad)
                }
                
                WorkerAddFieldView(title: "Email", text: $email, icon: "envelope.fill", keyboardType: .emailAddress)
                WorkerAddFieldView(title: "Address", text: $address, icon: "house.fill")
                
                WorkerAddSectionHeaderView(title: "Skills & Performance", iconName: "star.fill")
                
                    WorkerAddPickerView(title: "Rating", selection: $performanceRating, options: performanceRatings, icon: "chart.bar.fill")
                    WorkerAddPickerView(title: "Skill Level", selection: $skillLevel, options: skillLevels, icon: "target")
                
                
                WorkerAddFieldView(title: "Assigned Tasks (Comma Separated)", text: $assignedTasks, icon: "checklist")
                WorkerAddFieldView(title: "Certifications (Comma Separated)", text: $certifications, icon: "doc.text.fill")
                
                WorkerAddDatePickerView(title: "Last Attendance", date: $lastAttendanceDate, icon: "person.crop.square.fill")
                WorkerAddDatePickerView(title: "Next Evaluation", date: $nextEvaluationDate, icon: "text.book.closed.fill")
                
                WorkerAddSectionHeaderView(title: "Miscellaneous", iconName: "note.text")
                
                WorkerAddToggleView(title: "Currently Active", isOn: $isActive, icon: "bolt.fill", color: isActive ? Color(red: 0.1, green: 0.6, blue: 0.1) : Color(red: 0.8, green: 0.1, blue: 0.1))
                WorkerAddToggleView(title: "Safety Training Completed", isOn: $safetyTrainingCompleted, icon: "cross.case.fill", color: safetyTrainingCompleted ? .blue : Color(.systemOrange))
                
                WorkerAddFieldView(title: "Preferred Language", text: $preferredLanguage, icon: "globe")
                WorkerAddFieldView(title: "Notes", text: $notes, icon: "pencil.circle.fill")
                
                Button(action: saveWorker) {
                    Text("Add Worker Record")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemPink).opacity(0.8))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .shadow(color: Color(.systemPink).opacity(0.5), radius: 5, x: 0, y: 5)
                }
                .padding(.top, 20)
                
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .navigationTitle("New Worker Profile 👨‍🏭")
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text(alertMessage.contains("successfully") ? "Success" : "Validation Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

@available(iOS 14.0, *)
struct WorkerAddSectionHeaderView: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(Color(.systemPink))
                .font(.title3)
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.vertical, 8)
        .background(Color(.systemGray5).opacity(0.5))
        .cornerRadius(8)
    }
}

@available(iOS 14.0, *)
struct WorkerAddFieldView: View {
    let title: String
    @Binding var text: String
    let icon: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color(.systemPink))
                    .frame(width: 20)
                
                TextField(title, text: $text)
                    .keyboardType(keyboardType)
                    .disableAutocorrection(true)
            }
            .padding(.horizontal)
            .frame(height: 44)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemPink).opacity(0.4), lineWidth: 1)
            )
            .offset(y: -8)
        }
    }
}

@available(iOS 14.0, *)
struct WorkerAddDatePickerView: View {
    let title: String
    @Binding var date: Date
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color(.systemPink))
            Text(title)
                .font(.callout)
            Spacer()
            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
        }
        .padding()
        .background(Color(.systemPink).opacity(0.1))
        .cornerRadius(12)
    }
}

@available(iOS 14.0, *)
struct WorkerAddPickerView: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color(.systemPink))
            Text(title)
                .font(.callout)
            Spacer()
            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Color(.systemPink).opacity(0.1))
        .cornerRadius(12)
    }
}

@available(iOS 14.0, *)
struct WorkerAddToggleView: View {
    let title: String
    @Binding var isOn: Bool
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(title)
                .font(.callout)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: color))
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

@available(iOS 14.0, *)
struct WorkerListView: View {
    @EnvironmentObject var dataStore: PerfumeDataStore
    @State private var searchText: String = ""
    @State private var showingAddWorker = false
    
    var filteredWorkers: [Worker] {
        if searchText.isEmpty {
            return dataStore.workers
        } else {
            return dataStore.workers.filter { worker in
                worker.name.localizedCaseInsensitiveContains(searchText) ||
                worker.role.localizedCaseInsensitiveContains(searchText) ||
                worker.employeeID.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
            VStack(spacing: 0) {
                
                WorkerSearchBarView(searchText: $searchText)
                    .padding(.bottom, 5)
                
                if filteredWorkers.isEmpty && dataStore.workers.isEmpty {
                    WorkerNoDataView(title: "No Workers Registered", message: "Start by adding your first employee to the team.")
                } else if filteredWorkers.isEmpty {
                    WorkerNoDataView(title: "No Matching Workers", message: "Try a different name, role, or ID.")
                } else {
                    List {
                        ForEach(filteredWorkers) { worker in
                            NavigationLink(destination: WorkerDetailView(worker: worker)) {
                                WorkerListRowView(worker: worker)
                            }
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        }
                        .onDelete(perform: deleteWorker)
                    }
                    .listStyle(PlainListStyle())
                }
            }.navigationTitle("Team Members 👷")
                .background(Color(.systemGroupedBackground))
                .sheet(isPresented: $showingAddWorker) {
                    NavigationView {
                        WorkerAddView()
                            .environmentObject(dataStore)
                    }
                }
                .navigationBarItems(trailing:
                    Button(action: {
                        showingAddWorker = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color(.systemPink))
                    }
                )
        
        
    }
    
    private func deleteWorker(at offsets: IndexSet) {
        dataStore.deleteWorker(at: offsets)
    }
}

@available(iOS 14.0, *)
struct WorkerListRowView: View {
    let worker: Worker
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color(.systemPink))
                
                VStack(alignment: .leading) {
                    Text(worker.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text(worker.employeeID)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(worker.isActive ? "Active" : "Inactive")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(worker.isActive ? Color(.systemGreen).opacity(0.2) : Color(.systemRed).opacity(0.2))
                            .foregroundColor(worker.isActive ? Color(.systemGreen) : Color(.systemRed))
                            .cornerRadius(8)
                    }
                }
            }
            .padding([.horizontal, .top], 15)
            
            Divider().padding(.horizontal, 15)
            
            HStack(spacing: 20) {
                WorkerListDetailBlock(icon: "briefcase.fill", label: "Role", value: worker.role)
                WorkerListDetailBlock(icon: "clock.fill", label: "Shift", value: worker.shiftTime)
                WorkerListDetailBlock(icon: "dollarsign.circle", label: "Rate", value: String(format: "%.2f/hr", worker.hourlyRate))
            }
            .padding(.horizontal, 15)
            
            HStack(spacing: 20) {
                WorkerListDetailBlock(icon: "star.fill", label: "Rating", value: worker.performanceRating)
                WorkerListDetailBlock(icon: "cross.case.fill", label: "Safety", value: worker.safetyTrainingCompleted ? "Complete" : "Pending")
                WorkerListDetailBlock(icon: "calendar", label: "Joined", value: worker.joinDate, formatter: DateFormatter.workerDateFormatter)
            }
            .padding(.horizontal, 15)
            
            HStack(spacing: 20) {
                WorkerListDetailBlock(icon: "figure.walk", label: "Leave Days", value: "\(worker.leaveDaysTaken)")
                WorkerListDetailBlock(icon: "timer", label: "Hours Worked", value: String(format: "%.1f", worker.totalHoursWorked))
                WorkerListDetailBlock(icon: "envelope.fill", label: "Email", value: worker.email)
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 15)
            
        }
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

@available(iOS 14.0, *)
struct WorkerListDetailBlock: View {
    let icon: String
    let label: String
    let value: String
    
    init(icon: String, label: String, value: String) {
        self.icon = icon
        self.label = label
        self.value = value
    }
    
    init(icon: String, label: String, value: Date, formatter: DateFormatter) {
        self.icon = icon
        self.label = label
        self.value = formatter.string(from: value)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundColor(Color(.systemPink))
                    .font(.caption)
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(1)
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

@available(iOS 14.0, *)
struct WorkerSearchBarView: View {
    @Binding var searchText: String
    @State private var isSearching = false
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(isSearching ? Color(.systemPink) : Color(.systemGray))
            
            TextField("Search by name, role, or ID...", text: $searchText, onEditingChanged: { isEditing in
                withAnimation(.spring()) {
                    isSearching = isEditing || !searchText.isEmpty
                }
            })
            .padding(7)
            .padding(.horizontal, 10)
            .background(Color(.gray).opacity(0.5))
            .cornerRadius(10)
            .animation(.easeInOut, value: isSearching)
            
            if isSearching {
                Button(action: {
                    searchText = ""
                    withAnimation(.spring()) {
                        isSearching = false
                        UIApplication.shared.endEditing()
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(.systemGray))
                }
                .padding(.trailing, 5)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

@available(iOS 14.0, *)
struct WorkerNoDataView: View {
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "person.crop.square.fill.and.at.rectangle")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(Color(.systemPink).opacity(0.6))
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 250)
        }
        .padding(.top, 50)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

@available(iOS 14.0, *)
struct WorkerDetailView: View {
    let worker: Worker
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                WorkerDetailHeaderView(worker: worker)
                    .padding(.bottom, 10)
                
                WorkerDetailSectionHeader(title: "Role & Contact", iconName: "person.text.rectangle")
                
                VStack(spacing: 15) {
                    WorkerDetailFieldRow(label: "Employee ID", value: worker.employeeID, icon: "number")
                    WorkerDetailFieldRow(label: "Role / Department", value: "\(worker.role) in \(worker.department)", icon: "building.2")
                    WorkerDetailFieldRow(label: "Contact Number", value: worker.contactNumber, icon: "phone.fill")
                    WorkerDetailFieldRow(label: "Emergency Contact", value: worker.emergencyContact, icon: "exclamationmark.shield.fill")
                    WorkerDetailFieldRow(label: "Email", value: worker.email, icon: "envelope.fill")
                    WorkerDetailFieldRow(label: "Address", value: worker.address, icon: "house.fill")
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(15)
                
                WorkerDetailSectionHeader(title: "Financial & Schedule", iconName: "dollarsign.square")
                
                VStack(spacing: 15) {
                        WorkerDetailFieldRow(label: "Hourly Rate", value: String(format: "$%.2f", worker.hourlyRate), icon: "dollarsign.circle")
                        WorkerDetailFieldRow(label: "Shift Time", value: worker.shiftTime, icon: "clock")

                        WorkerDetailFieldRow(label: "Total Hours Worked", value: String(format: "%.1f hrs", worker.totalHoursWorked), icon: "timer")
                        WorkerDetailFieldRow(label: "Total Earnings", value: String(format: "$%.2f", worker.totalEarnings), icon: "creditcard")
                    
                    WorkerDetailFieldRow(label: "Leave Days Taken", value: "\(worker.leaveDaysTaken) days", icon: "figure.walk")
                    WorkerDetailFieldRow(label: "Preferred Language", value: worker.preferredLanguage, icon: "globe")
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(15)
                
                WorkerDetailSectionHeader(title: "Skills & Performance", iconName: "star.circle.fill")
                
                VStack(spacing: 15) {
                    WorkerDetailFieldRow(label: "Performance Rating", value: worker.performanceRating, icon: "hand.thumbsup.fill")
                    WorkerDetailFieldRow(label: "Skill Level", value: worker.skillLevel, icon: "target.fill")
                    WorkerDetailFieldRow(label: "Safety Training", value: worker.safetyTrainingCompleted ? "Completed" : "Pending", icon: "cross.case.fill", accentColor: worker.safetyTrainingCompleted ? .blue : Color(.systemOrange))
                    WorkerDetailFieldRow(label: "Assigned Tasks", value: worker.assignedTasks.joined(separator: ", "), icon: "list.bullet.rectangle")
                    WorkerDetailFieldRow(label: "Certifications", value: worker.certifications.joined(separator: ", "), icon: "doc.text.fill")
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(15)
                
                WorkerDetailSectionHeader(title: "History & Metadata", iconName: "calendar.badge.clock")
                
                VStack(spacing: 15) {
                        WorkerDetailFieldRow(label: "Join Date", value: worker.joinDate, formatter: DateFormatter.workerDateFormatter, icon: "figure.wave")
                        WorkerDetailFieldRow(label: "Last Attendance", value: worker.lastAttendanceDate, formatter: DateFormatter.workerDateFormatter, icon: "calendar.badge.person.fill")
                    
                    WorkerDetailFieldRow(label: "Next Evaluation", value: worker.nextEvaluationDate, formatter: DateFormatter.workerDateFormatter, icon: "text.book.closed.fill")
                    WorkerDetailFieldRow(label: "Last Updated", value: worker.lastUpdated, formatter: DateFormatter.workerDateTimeFormatter, icon: "arrow.triangle.2.circlepath")
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(15)
                
                WorkerDetailSectionHeader(title: "Notes", iconName: "note.text")
                
                Text(worker.notes.isEmpty ? "No specific notes recorded." : worker.notes)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                
                Spacer()
                
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
        .navigationTitle("Worker Details")
        .background(Color(.systemGroupedBackground))
    }
}

@available(iOS 14.0, *)
struct WorkerDetailHeaderView: View {
    let worker: Worker
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "person.crop.square.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(Color(.systemPink))
            
            Text(worker.name)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
            
            Text(worker.address)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(worker.preferredLanguage)
                .font(.caption)
                .fontWeight(.bold)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color(.systemPurple).opacity(0.1))
                .foregroundColor(Color(.systemPurple))
                .cornerRadius(8)
            
            Text(worker.isActive ? "🟢 Active Status" : "🔴 Inactive Status")
                .font(.callout)
                .fontWeight(.semibold)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(worker.isActive ? Color(.systemGreen).opacity(0.2) : Color(.systemRed).opacity(0.2))
                .foregroundColor(worker.isActive ? Color(.systemGreen) : Color(.systemRed))
                .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 5)
    }
}

@available(iOS 14.0, *)
struct WorkerDetailSectionHeader: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(Color(.systemPink))
                .font(.title3)
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.top, 5)
    }
}

@available(iOS 14.0, *)
struct WorkerDetailFieldRow: View {
    let label: String
    let value: String
    let icon: String
    var accentColor: Color = Color(.systemPink)
    
    init(label: String, value: String, icon: String, accentColor: Color = Color(.systemPink)) {
        self.label = label
        self.value = value
        self.icon = icon
        self.accentColor = accentColor
    }
    
    init(label: String, value: Date, formatter: DateFormatter, icon: String, accentColor: Color = Color(.systemPink)) {
        self.label = label
        self.value = formatter.string(from: value)
        self.icon = icon
        self.accentColor = accentColor
    }
    
    var body: some View {
        HStack(alignment: .top) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .frame(width: 20)
                    .foregroundColor(accentColor)
                Text(label)
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            .frame(width: 150, alignment: .leading)
            
            Spacer()
            
            Text(value)
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
        }
    }
}

