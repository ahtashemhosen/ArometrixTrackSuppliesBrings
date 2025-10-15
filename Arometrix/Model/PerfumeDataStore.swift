
import Foundation
import Combine

@available(iOS 14.0, *)
final class PerfumeDataStore: ObservableObject {
    
    @Published var ingredients: [Ingredient] = [] { didSet { saveData(ingredients, key: "ingredients") } }
    @Published var recipes: [PerfumeRecipe] = [] { didSet { saveData(recipes, key: "recipes") } }
    @Published var productionRecords: [ProductionRecord] = [] { didSet { saveData(productionRecords, key: "productionRecords") } }
    @Published var workers: [Worker] = [] { didSet { saveData(workers, key: "workers") } }
    @Published var supplies: [Supply] = [] { didSet { saveData(supplies, key: "supplies") } }
    @Published var histories: [History] = [] { didSet { saveData(histories, key: "histories") } }
    
    init() {
        loadData()
        loadDummyData()
    }
    
    private func saveData<T: Codable>(_ data: [T], key: String) {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    private func loadArray<T: Codable>(for key: String) -> [T] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([T].self, from: data)
        else { return [] }
        return decoded
    }
    
    private func loadData() {
        ingredients = loadArray(for: "ingredients")
        recipes = loadArray(for: "recipes")
        productionRecords = loadArray(for: "productionRecords")
        workers = loadArray(for: "workers")
        supplies = loadArray(for: "supplies")
        histories = loadArray(for: "histories")
    }
    
    // MARK: - Add Functions
    func addIngredient(_ ingredient: Ingredient) { ingredients.append(ingredient) }
    func addRecipe(_ recipe: PerfumeRecipe) { recipes.append(recipe) }
    func addProductionRecord(_ record: ProductionRecord) { productionRecords.append(record) }
    func addWorker(_ worker: Worker) { workers.append(worker) }
    func addSupply(_ supply: Supply) { supplies.append(supply) }
    func addHistory(_ history: History) { histories.append(history) }
    
    // MARK: - Delete Functions
    func deleteIngredient(at offsets: IndexSet) { ingredients.remove(atOffsets: offsets) }
    func deleteRecipe(at offsets: IndexSet) { recipes.remove(atOffsets: offsets) }
    func deleteProductionRecord(at offsets: IndexSet) { productionRecords.remove(atOffsets: offsets) }
    func deleteWorker(at offsets: IndexSet) { workers.remove(atOffsets: offsets) }
    func deleteSupply(at offsets: IndexSet) { supplies.remove(atOffsets: offsets) }
    func deleteHistory(at offsets: IndexSet) { histories.remove(atOffsets: offsets) }
    
    // MARK: - Dummy Data Loader
    func loadDummyData() {
        let now = Date()
        
        ingredients = [
            Ingredient(name: "Rose Oil", category: "Essential Oil", scentNote: "Middle",
                       purityLevel: "99%", supplierName: "FloraEssence", batchCode: "R001",
                       originCountry: "France", extractionMethod: "Steam Distillation",
                       storageLocation: "Shelf A1", quantityML: 200, reorderLevel: 50,
                       costPerML: 2.5, totalStockValue: 500, safetyDataSheetAvailable: true,
                       expiryDate: now.addingTimeInterval(60*60*24*365), receivedDate: now,
                       usageCount: 10, noteDescription: "Sweet floral scent", color: "Light Yellow",
                       volatilityLevel: "Medium", flashPointCelsius: 65, recommendedUsagePercent: 2.5,
                       safetyPrecautions: "Avoid eye contact", storageTemperatureC: 25, lastUpdated: now)
        ]
        
        recipes = [
            PerfumeRecipe(name: "Blossom Mist", creatorName: "Manu", inspiration: "Spring Garden",
                          fragranceFamily: "Floral", topNotes: ["Bergamot", "Lemon"],
                          middleNotes: ["Rose", "Jasmine"], baseNotes: ["Musk"],
                          concentrationType: "Eau de Parfum", totalVolumeML: 50,
                          blendRatioDescription: "30-40-30", agingDurationDays: 14,
                          stabilityTested: true, sillageLevel: "Moderate", longevityHours: 6,
                          alcoholPercentage: 70, dilutionMedium: "Ethanol",
                          storageInstructions: "Keep cool and dark", allergens: ["Linalool"],
                          colorDescription: "Soft pink", temperatureSensitivity: "High",
                          creationDate: now, lastModified: now, reviewNotes: "Smooth balance",
                          safetyRating: "A", commercialName: "BlossomMist50", uniqueCode: "BM-2025")
        ]
        
        productionRecords = [
            ProductionRecord(recordNumber: "PR001", perfumeName: "Blossom Mist",
                             productionDate: now, batchNumber: "BATCH-A1", totalVolumeProduced: 500,
                             totalCost: 1200, supervisorName: "Alex", assistantName: "Sara",
                             processDurationMinutes: 180, roomTemperatureC: 24,
                             humidityPercent: 60, equipmentUsed: "Mixer X1",
                             alcoholUsedML: 350, essenceUsedML: 120, distilledWaterUsedML: 30,
                             remarks: "Successful batch", qualityCheckPassed: true,
                             densityReading: 0.89, viscosityReading: 1.2, sampleTaken: true,
                             packagingType: "Glass Bottles", bottlesFilled: 100,
                             labelAppliedBy: "John", storageShelf: "Shelf B2",
                             recordCreated: now, recordUpdated: now)
        ]
        
        workers = [
            Worker(name: "Sara Khan", employeeID: "W001", role: "Perfumer", department: "Production",
                   joinDate: now.addingTimeInterval(-2000000), shiftTime: "Morning",
                   hourlyRate: 15, totalHoursWorked: 1200, totalEarnings: 18000,
                   contactNumber: "0300-1234567", address: "Lahore", emergencyContact: "0321-9876543",
                   email: "sara@factory.com", isActive: true, leaveDaysTaken: 4,
                   performanceRating: "Excellent", skillLevel: "Advanced",
                   assignedTasks: ["Mixing", "Testing"], safetyTrainingCompleted: true,
                   lastAttendanceDate: now, nextEvaluationDate: now.addingTimeInterval(86400*30),
                   notes: "Highly skilled", preferredLanguage: "en",
                   certifications: ["Aromachemistry", "Safety"], lastUpdated: now)
        ]
        
        supplies = [
            Supply(supplyID: "S001", itemName: "Glass Bottles", supplierName: "PurePack Ltd.",
                   supplierContact: "info@purepack.com", purchaseOrderNumber: "PO123",
                   receivedDate: now, quantityReceived: 500, unitType: "pcs",
                   unitCost: 0.5, totalCost: 250, paymentStatus: "Paid", paymentMethod: "Cash",
                   invoiceNumber: "INV-001", qualityCheckStatus: "Approved",
                   warehouseLocation: "A3", reorderThreshold: 100, stockAvailable: 400,
                   expirationDate: now.addingTimeInterval(31536000), remarks: "Perfect quality",
                   isReturnable: false, handlingInstructions: "Fragile - handle carefully",
                   shippingMethod: "Ground", trackingNumber: "TRK-1234",
                   deliveryStatus: "Delivered", lastUpdated: now)
        ]
        
        histories = [
            History(recordType: "System", recordTitle: "App Initialized",
                    descriptionText: "Initial dummy data loaded", dateLogged: now,
                    createdBy: "System", modifiedBy: "System", changeType: "Initialization",
                    changeDetails: "Dummy data inserted", previousValue: "", newValue: "Created",
                    verificationStatus: "Confirmed", remarks: "Test data only", isArchived: false,
                    relatedSection: "Initialization", priorityLevel: "Low", eventTimestamp: now,
                    systemVersion: "iOS 14", appVersion: "1.0", deviceName: "iPhone",
                    actionDurationSeconds: 0.1, statusAfterChange: "Active",
                    reviewerName: "System", locationOfChange: "Local", assignedTag: "Startup",
                    syncStatus: "Offline", lastUpdated: now)
        ]
    }
}


struct Ingredient: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var category: String
    var scentNote: String
    var purityLevel: String
    var supplierName: String
    var batchCode: String
    var originCountry: String
    var extractionMethod: String
    var storageLocation: String
    var quantityML: Double
    var reorderLevel: Double
    var costPerML: Double
    var totalStockValue: Double
    var safetyDataSheetAvailable: Bool
    var expiryDate: Date
    var receivedDate: Date
    var usageCount: Int
    var noteDescription: String
    var color: String
    var volatilityLevel: String
    var flashPointCelsius: Double
    var recommendedUsagePercent: Double
    var safetyPrecautions: String
    var storageTemperatureC: Double
    var lastUpdated: Date
}

struct PerfumeRecipe: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var creatorName: String
    var inspiration: String
    var fragranceFamily: String
    var topNotes: [String]
    var middleNotes: [String]
    var baseNotes: [String]
    var concentrationType: String
    var totalVolumeML: Double
    var blendRatioDescription: String
    var agingDurationDays: Int
    var stabilityTested: Bool
    var sillageLevel: String
    var longevityHours: Double
    var alcoholPercentage: Double
    var dilutionMedium: String
    var storageInstructions: String
    var allergens: [String]
    var colorDescription: String
    var temperatureSensitivity: String
    var creationDate: Date
    var lastModified: Date
    var reviewNotes: String
    var safetyRating: String
    var commercialName: String
    var uniqueCode: String
}

struct ProductionRecord: Identifiable, Codable, Hashable {
    var id = UUID()
    var recordNumber: String
    var perfumeName: String
    var productionDate: Date
    var batchNumber: String
    var totalVolumeProduced: Double
    var totalCost: Double
    var supervisorName: String
    var assistantName: String
    var processDurationMinutes: Int
    var roomTemperatureC: Double
    var humidityPercent: Double
    var equipmentUsed: String
    var alcoholUsedML: Double
    var essenceUsedML: Double
    var distilledWaterUsedML: Double
    var remarks: String
    var qualityCheckPassed: Bool
    var densityReading: Double
    var viscosityReading: Double
    var sampleTaken: Bool
    var packagingType: String
    var bottlesFilled: Int
    var labelAppliedBy: String
    var storageShelf: String
    var recordCreated: Date
    var recordUpdated: Date
}

// MARK: - Worker Model
struct Worker: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var employeeID: String
    var role: String
    var department: String
    var joinDate: Date
    var shiftTime: String
    var hourlyRate: Double
    var totalHoursWorked: Double
    var totalEarnings: Double
    var contactNumber: String
    var address: String
    var emergencyContact: String
    var email: String
    var isActive: Bool
    var leaveDaysTaken: Int
    var performanceRating: String
    var skillLevel: String
    var assignedTasks: [String]
    var safetyTrainingCompleted: Bool
    var lastAttendanceDate: Date
    var nextEvaluationDate: Date
    var notes: String
    var preferredLanguage: String
    var certifications: [String]
    var lastUpdated: Date
}

// MARK: - Supply Model
struct Supply: Identifiable, Codable, Hashable {
    var id = UUID()
    var supplyID: String
    var itemName: String
    var supplierName: String
    var supplierContact: String
    var purchaseOrderNumber: String
    var receivedDate: Date
    var quantityReceived: Double
    var unitType: String
    var unitCost: Double
    var totalCost: Double
    var paymentStatus: String
    var paymentMethod: String
    var invoiceNumber: String
    var qualityCheckStatus: String
    var warehouseLocation: String
    var reorderThreshold: Double
    var stockAvailable: Double
    var expirationDate: Date
    var remarks: String
    var isReturnable: Bool
    var handlingInstructions: String
    var shippingMethod: String
    var trackingNumber: String
    var deliveryStatus: String
    var lastUpdated: Date
}

// MARK: - History Model
struct History: Identifiable, Codable, Hashable {
    var id = UUID()
    var recordType: String
    var recordTitle: String
    var descriptionText: String
    var dateLogged: Date
    var createdBy: String
    var modifiedBy: String
    var changeType: String
    var changeDetails: String
    var previousValue: String
    var newValue: String
    var verificationStatus: String
    var remarks: String
    var isArchived: Bool
    var relatedSection: String
    var priorityLevel: String
    var eventTimestamp: Date
    var systemVersion: String
    var appVersion: String
    var deviceName: String
    var actionDurationSeconds: Double
    var statusAfterChange: String
    var reviewerName: String
    var locationOfChange: String
    var assignedTag: String
    var syncStatus: String
    var lastUpdated: Date
}
