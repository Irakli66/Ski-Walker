//
//  AddressesView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 11.01.25.
//

import SwiftUI

struct AddressesView: View {
    @StateObject private var addressesViewModel = AddressViewModel()
    @State private var isSheetPresented = false
    
    var body: some View {
        VStack{
            addressesHeader
            if addressesViewModel.addresses.isEmpty {
                Spacer()
                Image("emptyAddress")
                    .resizable()
                    .frame(width: 200, height: 230)
                Spacer()
            } else {
                ScrollView {
                    addressesContent
                }
            }
        }
        .padding()
        .background(Color.customBackground)
        .sheet(isPresented: $isSheetPresented) {
            AddAddressView()
                .presentationDetents([.height(550)])
                .background(Color.customBackground)
            
        }
        .onAppear() {
            Task {
                do {
                    try await addressesViewModel.fetchAddresses()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        .environmentObject(addressesViewModel)
    }
    
    private var addressesHeader: some View {
        HStack {
            ReusableBackButton()
            Spacer()
            Text("Addresses")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.customPurple)
            Spacer()
            Image(systemName: "plus")
                .font(.system(size: 20))
                .onTapGesture {
                    isSheetPresented = true
                }
        }
    }
    
    private var addressesContent: some View {
        LazyVStack(spacing: 16) {
            ForEach(addressesViewModel.addresses, id: \.self.id) { address in
                HStack(alignment: .top, spacing: 16) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundStyle(Color.customPurple)
                        .font(.system(size: 28))
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(address.fullname)
                            .font(.headline)
                            .foregroundStyle(Color.primary)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(address.street)
                            Text("\(address.city), \(address.country)")
                        }
                        .font(.subheadline)
                        .foregroundStyle(Color.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            do {
                                try await addressesViewModel.removeAddress(with: address.id)
                                try await addressesViewModel.fetchAddresses()
                            } catch {
                                AlertManager.showAlert(message: error.localizedDescription)
                            }
                        }
                    }) {
                        Image(systemName: "trash.fill")
                            .foregroundStyle(Color.red)
                            .padding(8)
                            .background(Color.red.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
                .padding()
                .background(Color.customWhite)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
        }
        .padding()
    }
    
}

#Preview {
    AddressesView()
}
