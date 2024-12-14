//
//  WARMISITAI_APPApp.swift
//  WARMISITAI_APP
//
//  Created by DAMII on 14/12/24.
//

import SwiftUI

@main
struct WARMISITAI_APPapp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ListaComprasView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
