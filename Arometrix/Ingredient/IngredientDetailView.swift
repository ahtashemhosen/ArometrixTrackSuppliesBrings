
import SwiftUI

@available(iOS 14.0, *)
struct IngredientDetailView: View {
    let ingredient: Ingredient

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {

                VStack(alignment: .leading, spacing: 10) {
                    Text(ingredient.name)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)

                    Text("\(ingredient.scentNote) Note | \(ingredient.category)")
                        .font(.title3)
                        .foregroundColor(Color.white.opacity(0.8))

                    HStack {
                        Image(systemName: "drop.fill")
                            .foregroundColor(.white)
                        Text("Quantity: \(String(format: "%.1f ML", ingredient.quantityML))")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(25)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(CustomColor.mint)
                        .shadow(color: CustomColor.mint.opacity(0.6), radius: 15, x: 0, y: 10)
                )
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Inventory & Lifespan")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    HStack(alignment: .top) {
                        VStack(spacing: 15) {
                            IngredientDetailFieldRow(title: "Batch Code", value: ingredient.batchCode, iconName: "barcode", color: .red)
                            IngredientDetailFieldRow(title: "Reorder Level (ML)", value: String(format: "%.1f", ingredient.reorderLevel), iconName: "arrow.up.bin.fill", color: .orange)
                            IngredientDetailFieldRow(title: "Received Date", value: DateFormatter.mediumDate.string(from: ingredient.receivedDate), iconName: "calendar.badge.plus", color: .blue)
                            IngredientDetailFieldRow(title: "Expiry Date", value: DateFormatter.mediumDate.string(from: ingredient.expiryDate), iconName: "calendar.badge.minus", color: .red)
                        }
                        .frame(maxWidth: .infinity)

                        Divider().frame(height: 150)

                        VStack(spacing: 15) {
                            IngredientDetailFieldRow(title: "Storage Location", value: ingredient.storageLocation, iconName: "shippingbox", color: .purple)
                            IngredientDetailFieldRow(title: "Usage Count", value: "\(ingredient.usageCount)", iconName: "arrow.turn.up.left", color: .pink)
                            IngredientDetailFieldRow(title: "Total Stock Value", value: String(format: "$%.2f", ingredient.totalStockValue), iconName: "sum", color: .green)
                            IngredientDetailFieldRow(title: "Cost Per ML", value: String(format: "$%.2f", ingredient.costPerML), iconName: "dollarsign.circle", color: .green)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Source & Purity")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Group {
                        IngredientDetailFieldRow(title: "Supplier Name", value: ingredient.supplierName, iconName: "person.2.fill", color: .blue)
                        IngredientDetailFieldRow(title: "Origin Country", value: ingredient.originCountry, iconName: "globe", color: .blue)
                        IngredientDetailFieldRow(title: "Purity Level", value: ingredient.purityLevel, iconName: "p.circle.fill", color: .green)
                        IngredientDetailFieldRow(title: "Extraction Method", value: ingredient.extractionMethod, iconName: "lab.flask.fill", color: .green)
                    }
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Technical Specifications")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    VStack(spacing: 15) {
                        HStack(alignment: .top) {
                            VStack(spacing: 15) {
                                IngredientDetailFieldRow(title: "Color", value: ingredient.color, iconName: "paintpalette", color: CustomColor.brown)
                                IngredientDetailFieldRow(title: "Volatility Level", value: ingredient.volatilityLevel, iconName: "cloud.drizzle.fill", color: CustomColor.indigo)
                                IngredientDetailFieldRow(title: "Flash Point (°C)", value: String(format: "%.1f", ingredient.flashPointCelsius), iconName: "flame.fill", color: .orange)
                            }
                            .frame(maxWidth: .infinity)

                            Divider().frame(height: 100)

                            VStack(spacing: 15) {
                                IngredientDetailFieldRow(title: "Storage Temp (°C)", value: String(format: "%.1f", ingredient.storageTemperatureC), iconName: "thermometer", color: CustomColor.teal)
                                IngredientDetailFieldRow(title: "Recommended Usage (%)", value: String(format: "%.1f", ingredient.recommendedUsagePercent), iconName: "percent", color: CustomColor.teal)
                                IngredientDetailFieldRow(title: "Last Updated", value: DateFormatter.mediumDate.string(from: ingredient.lastUpdated), iconName: "clock.fill", color: .gray)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Safety and Notes")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .top) {
                            Image(systemName: ingredient.safetyDataSheetAvailable ? "doc.text.fill" : "doc.text.times")
                                .foregroundColor(ingredient.safetyDataSheetAvailable ? .green : .red)
                            Text("SDS Available: \(ingredient.safetyDataSheetAvailable ? "Yes" : "No")")
                                .font(.headline)
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Safety Precautions")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            Text(ingredient.safetyPrecautions)
                                .font(.callout)
                        }
                        .padding(.top, 5)

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Note Description")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            Text(ingredient.noteDescription)
                                .font(.callout)
                        }
                        .padding(.top, 5)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                }
                .padding(.horizontal)

            }
            .padding(.vertical)
        }
        .navigationTitle(ingredient.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension DateFormatter {
    static let mediumDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
