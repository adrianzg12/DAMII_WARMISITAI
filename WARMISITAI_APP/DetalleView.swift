//
//  DetalleView.swift
//  WARMISITAI_APP
//
//  Created by DAMII on 14/12/24.
//

import Foundation
import SwiftUI

struct DetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
       @Environment(\.presentationMode) var presentationMode
       
       var item: Articulo
       
       var body: some View {
           VStack(alignment: .leading, spacing: 20) {
               Text("Detalle del Artículo")
                   .font(.largeTitle)
                   .padding(.bottom)
               
               Text("Nombre: \(item.nombre ?? "N/A")")
                   .font(.headline)
               Text("Cantidad: \(item.cantidad)")
               Text("Prioridad: \(item.prioridad ?? "N/A")")
               Text("Categoría: \(item.categoria ?? "N/A")")
               Text("Tienda: \(item.tienda ?? "N/A")")
               Text("Notas: \(item.notasAdicionales ?? "N/A")")
                   .foregroundColor(.secondary)
               
               Spacer()
               
               Button(action: {
                   togglePurchased()
               }) {
                   Text(item.comprado ? "Marcar como No Comprado" : "Marcar como Comprado")
                       .font(.headline)
                       .padding()
                       .frame(maxWidth: .infinity)
                       .background(item.comprado ? Color.red : Color.green)
                       .foregroundColor(.white)
                       .cornerRadius(10)
               }
           }
           .padding()
           .navigationBarTitle("Detalle", displayMode: .inline)
       }
       
       private func togglePurchased() {
           item.comprado.toggle()
           do {
               try viewContext.save()
               presentationMode.wrappedValue.dismiss() // Volver a la lista
           } catch {
               print("Error al guardar el cambio: \(error.localizedDescription)")
           }
       }
}
