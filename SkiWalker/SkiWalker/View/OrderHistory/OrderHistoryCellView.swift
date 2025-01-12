//
//  OrderHistoryCellView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//
import SwiftUI

struct OrderHistoryCellView: View {
    let order: Order
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .center) {
                Image(systemName: order.products[0].imageURLs[0])
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .clipped()
                
                if order.products.count > 1 {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.black.opacity(0.4))
                        .frame(width: 100, height: 100)
                    
                    Text("+\(order.products.count - 1)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 5) {
                    Image(systemName: "doc.plaintext")
                        .foregroundColor(Color.customPurple)
                    Text("Order:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(order.id)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                HStack(spacing: 5) {
                    Image(systemName: "calendar")
                        .foregroundColor(Color.customPurple)
                    Text("Date:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(order.date.formatted(.dateTime.day().month(.abbreviated).year()))
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                HStack(spacing: 5) {
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(order.status == .delivered ? .green : .orange)
                    Text("Status:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(order.status.rawValue)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(order.status == .delivered ? .green : .orange)
                }
                
                Divider()
                
                HStack(spacing: 5) {
                    Image(systemName: "dollarsign.circle")
                        .foregroundColor(Color.customPurple)
                    Text("Total Price:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("$\(order.totalPrice, specifier: "%.2f")")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.customPurple)
                }
            }
            
            Spacer()
        }
        .padding(15)
        .background(Color.customWhite)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}
