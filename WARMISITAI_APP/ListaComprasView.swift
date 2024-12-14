//
//  ListaComprasView.swift
//  WARMISITAI_APP
//
//  Created by DAMII on 14/12/24.
//
import SwiftUI
import CoreData

struct ListaComprasView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Articulo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Articulo.nombre, ascending: true)])
    private var items: FetchedResults<Articulo>
    
    @State private var categories: [String] = []
    @State private var stores: [String] = []
    
    @State private var selectedCategory: String? = nil
    @State private var selectedStore: String? = nil
    
    @State private var showingAddItemForm = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Filtros de Categoría y Tienda
                HStack(spacing: 10) {
                    filterButton(title: selectedCategory ?? "Categoría", options: categories, selection: $selectedCategory)
                    
                    filterButton(title: selectedStore ?? "Tienda", options: stores, selection: $selectedStore)
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Lista de artículos
                List {
                    ForEach(filteredItems, id: \.self) { item in
                        NavigationLink(destination: DetailView(item: item)) {
                            itemRow(item)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(PlainListStyle())
                .background(Color(UIColor.systemGroupedBackground))
                
                // Botón agregar
                Button(action: {
                    showingAddItemForm.toggle()
                }) {
                    Text("Agregar Artículo")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                .sheet(isPresented: $showingAddItemForm) {
                    AddItemView(categories: categories, stores: stores)
                }
                .onAppear {
                    loadCategoriesAndStores()
                }
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Lista de Compras")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Vista de cada artículo
    private func itemRow(_ item: Articulo) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(item.nombre ?? "Sin nombre")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text(item.comprado ? "Comprado" : "Pendiente")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(item.comprado ? .green : .red)
            }
            
            HStack {
                Text("Cantidad: \(item.cantidad)")
                Text("Prioridad: \(item.prioridad ?? "N/A")")
                    .foregroundColor(item.prioridad?.lowercased() == "alta" ? .red : .blue)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            HStack {
                Text("Categoría: \(item.categoria ?? "N/A")")
                Text("Tienda: \(item.tienda ?? "N/A")")
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.vertical, 4)
    }
    
    // Botón para filtros
    private func filterButton(title: String, options: [String], selection: Binding<String?>) -> some View {
        Menu {
            Button("Todas", action: { selection.wrappedValue = nil })
            ForEach(options, id: \.self) { option in
                Button(option, action: { selection.wrappedValue = option })
            }
        } label: {
            HStack {
                Text(title)
                    .font(.subheadline)
                Image(systemName: "chevron.down")
                    .font(.system(size: 12))
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 2)
        }
    }
    
    private var filteredItems: [Articulo] {
        items.filter {
            (selectedCategory == nil || $0.categoria == selectedCategory) &&
            (selectedStore == nil || $0.tienda == selectedStore)
        }
    }
    
    private func loadCategoriesAndStores() {
        APIService.shared.fetchCategories { categories in
            self.categories = categories
        }
        
        APIService.shared.fetchStores { stores in
            self.stores = stores
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = items[index]
            viewContext.delete(item)
        }
        try? viewContext.save()
    }
}
