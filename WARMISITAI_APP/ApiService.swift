//
//  ApiService.swift
//  WARMISITAI_APP
//
//  Created by DAMII on 14/12/24.
//
import Alamofire

class APIService {
    static let shared = APIService()

    // Función para obtener las categorías
    func fetchCategories(completion: @escaping ([String]) -> Void) {
        let url = "http://localhost:9090/api/categories"
        
        // Realizar la solicitud usando Alamofire
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                // Intentar convertir la respuesta en un array de diccionarios
                if let categoriesArray = value as? [[String: Any]] {
                    // Extraer los nombres de las categorías
                    let categoryNames = categoriesArray.compactMap { $0["nombre"] as? String }
                    completion(categoryNames) // Devolver los nombres
                } else {
                    print("Error: Invalid response format for categories.")
                    completion([]) // Retornar un array vacío en caso de error
                }
            case .failure(let error):
                print("Error fetching categories: \(error)")
                completion([]) // Retornar un array vacío si ocurre un error
            }
        }
    }
    
    // Función para obtener las tiendas
    func fetchStores(completion: @escaping ([String]) -> Void) {
        let url = "http://localhost:9090/api/tiendas"
        
        // Realizar la solicitud usando Alamofire
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                // Intentar convertir la respuesta en un array de diccionarios
                if let storesArray = value as? [[String: Any]] {
                    // Extraer los nombres de las tiendas
                    let storeNames = storesArray.compactMap { $0["nombre"] as? String }
                    completion(storeNames) // Devolver los nombres
                } else {
                    print("Error: Invalid response format for stores.")
                    completion([]) // Retornar un array vacío en caso de error
                }
            case .failure(let error):
                print("Error fetching stores: \(error)")
                completion([]) // Retornar un array vacío si ocurre un error
            }
        }
    }
}
