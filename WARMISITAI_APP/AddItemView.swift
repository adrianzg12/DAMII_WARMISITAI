//
//  AddItemView.swift
//  WARMISITAI_APP
//
//  Created by DAMII on 14/12/24.
//
import SwiftUI
import CoreData
struct AddItemView: View {
        @Environment(\.managedObjectContext) private var viewContext
        @Environment(\.presentationMode) private var presentationMode
        
        @State private var name: String = ""
        @State private var quantity: Int = 1
        @State private var priority: String = ""
        @State private var notes: String = ""
        @State private var selectedCategory: String? = nil
        @State private var selectedStore: String? = nil
        
        var categories: [String]
        var stores: [String]
        
        var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("Detalles del Artículo").font(.headline)) {
                        TextField("Nombre", text: $name)
                            .textInputAutocapitalization(.words)
                            .disableAutocorrection(true)
                        
                        HStack {
                            Text("Cantidad: \(quantity)")
                            Spacer()
                            Stepper("", value: $quantity, in: 1...100)
                        }
                        
                        TextField("Prioridad", text: $priority)
                            .textInputAutocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        TextField("Notas adicionales", text: $notes)
                    }
                    
                   Section(header: Text("Categoría y Tienda").font(.headline)) {
                        Picker("Categoría", selection: $selectedCategory) {
                            Text("Seleccionar Categoría").tag(nil as String?)
                            ForEach(categories, id: \.self) { category in
                                Text(category).tag(category as String?)
                            }
                        }
                        
                        Picker("Tienda", selection: $selectedStore) {
                            Text("Seleccionar Tienda").tag(nil as String?)
                            ForEach(stores, id: \.self) { store in
                                Text(store).tag(store as String?)
                            }
                        }
                    }
                }
                .navigationBarTitle("Agregar Artículo", displayMode: .inline)
                .navigationBarItems(
                    leading: Button("Cancelar") {
                        presentationMode.wrappedValue.dismiss()
                    },
                    trailing: Button("Guardar") {
                        saveItem()
                    }
                    .disabled(name.isEmpty || selectedCategory == nil || selectedStore == nil)  // Deshabilita guardar si falta información
                )
            }
        }
        
        private func saveItem() {
            guard !name.isEmpty else { return }
            
            let newItem = Articulo(context: viewContext)
            newItem.nombre = name
            newItem.cantidad = Int16(quantity)
            newItem.prioridad = priority
            newItem.notasAdicionales = notes
            newItem.categoria = selectedCategory ?? ""
            newItem.tienda = selectedStore ?? ""
            newItem.comprado = false
            
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()  // Cierra la vista después de guardar
            } catch {
                print("Error al guardar el artículo: \(error.localizedDescription)")
            }
        }
    }

   
