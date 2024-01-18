//
//  AdressView.swift
//  CupcakeCorner
//
//  Created by Kirill Baranov on 18/01/24.
//

import SwiftUI

struct AddressView: View {
    @Bindable var order: Order

    var body: some View {
            Form {
                Section {
                    TextField("Name", text: $order.user.name)
                    TextField("Street Address", text: $order.user.address.streetAddress)
                    TextField("City", text: $order.user.address.city)
                    TextField("Zip", text: $order.user.address.zip)
                }
                
                Section {
                    NavigationLink("Check out") {
                        CheckoutView(order: order)
                    }
                }
                .disabled(order.user.address.hasValidAddress == false)

            }
            .navigationTitle("Delivery details")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                order.user.address.saveAddress()
            }
        }
    }

#Preview {
    AddressView(order: Order())
}
