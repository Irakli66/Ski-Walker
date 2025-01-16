struct SubcategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    let category: ProductCategory
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 25) {
                ZStack {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.backward")
                                .imageScale(.large)
                                .foregroundColor(.primary)
                        }
                        Spacer()
                    }
                    
                    Text("Categories")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.customBlue)
                }
                
                NavigationLink {
                    ProductsView(searchQuery: "")
                } label: {
                    Text("See All")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.customBlue)
                }
                LazyVStack(spacing: 30) {
                    ForEach(category.subcategories, id: \.self) { subcategory in
                        NavigationLink {
                            ProductsView(searchQuery: subcategory.rawValue)
                        } label: {
                            HStack {
                                HStack {
                                    Image(subcategory.iconName)
                                        .padding(10)
                                        .background(Color.customWhite)
                                        .clipShape(RoundedRectangle(cornerRadius: 50))
                                    Text(subcategory.rawValue)
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundStyle(Color.customBlue)
                                }
                                
                                Spacer()
                                Image(systemName: "chevron.forward")
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .background(Color.customBackground)
            .navigationBarBackButtonHidden(true)
        }
    }
}