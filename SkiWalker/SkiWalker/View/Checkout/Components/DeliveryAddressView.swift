//
//  DeliveryAddressView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 22.01.25.
//

import SwiftUI

struct DeliveryAddressView: View {
    @EnvironmentObject private var checkoutViewModel: CheckoutViewModel
    @State private var showAddressSheet = false
    @State private var showAddNewAddress = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Delivery Details")
                .font(.system(size: 16, weight: .bold))
            deliveryContent
        }
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $showAddressSheet) {
            AddressSelectionSheet(showAddressView: $showAddNewAddress)
                .presentationDetents([.height(450)])
                .background(Color.customBackground)
        }
        .fullScreenCover(isPresented: $showAddNewAddress) {
            AddressesView()
        }
    }
    
    @ViewBuilder
    private var deliveryContent: some View {
        if checkoutViewModel.addresses.isEmpty {
            noAddress
        } else {
            addressDetails
        }
    }
    
    @ViewBuilder
    private var addressDetails: some View {
        HStack(alignment: .center) {
            Image(systemName: "mappin.circle.fill")
                .foregroundStyle(Color.customPurple)
                .font(.system(size: 28))
            
            VStack(alignment: .leading) {
                if let selectedAddress = checkoutViewModel.selectedAddress {
                    Text(selectedAddress.fullname)
                        .font(.system(size: 14, weight: .bold))
                    Text("\(selectedAddress.street), \(selectedAddress.city), \(selectedAddress.country)")
                        .font(.system(size: 13, weight: .regular))
                }
            }
            
            Spacer()
            Image(systemName: "arrow.up.arrow.down")
        }
        .onTapGesture {
            showAddressSheet = true
        }
    }
    
    @ViewBuilder
    private var noAddress: some View {
        HStack(alignment: .center) {
            Image(systemName: "mappin.circle.fill")
                .foregroundStyle(Color.customPurple)
                .font(.system(size: 28))
            
            VStack(alignment: .leading) {
                Text("You don't have any saved addresses.")
                    .font(.system(size: 14, weight: .bold))
                NavigationLink(destination: AddressesView().navigationBarBackButtonHidden(), label: {
                    Text("Add one here")
                        .font(.system(size: 13, weight: .regular))
                })
            }
            Spacer()
        }
    }
}

struct AddressSelectionSheet: View {
    @EnvironmentObject private var checkoutViewModel: CheckoutViewModel
    @Environment(\.presentationMode) private var presentationMode
    @Binding var showAddressView: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Select Address")
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(.customWhite)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 15)
                        .background(Color.customPurple)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            }
            
            addressList
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                showAddressView = true
            }) {
                Text("Add new address")
                    .buttonModifier()
            }
        }
        .padding()
        .onAppear() {
            Task {
                await checkoutViewModel.fetchAddresses()
            }
        }
    }
    
    private var addressList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                ForEach(checkoutViewModel.addresses, id: \.self.id) { address in
                    HStack(alignment: .center) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundStyle(Color.customPurple)
                            .font(.system(size: 28))
                        
                        VStack(alignment: .leading) {
                            Text(address.fullname)
                                .font(.system(size: 14, weight: .bold))
                            Text("\(address.street), \(address.city), \(address.country)")
                                .font(.system(size: 13, weight: .regular))
                        }
                        
                        Spacer()
                    }
                    .onTapGesture {
                        checkoutViewModel.selectedAddress = address
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    DeliveryAddressView()
}
