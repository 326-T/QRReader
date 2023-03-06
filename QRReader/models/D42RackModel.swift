//
//  D42RackModel.swift
//  QRReader
//
//  Created by 竹田恭 on 2023/03/06.
//

import Foundation

struct D42Rack: Identifiable {
    let id = UUID()
    let rackPk: Int
    let name: String
    let roomFk: Int
}

class D42RackModel: ObservableObject {
    struct ResultJson: Codable {
        let rackPk: Int
        let name: String
        let roomFk: Int
    }
    
    @Published var d42rack: D42Rack = D42Rack(rackPk: 0, name: "", roomFk: 0)
    
    func fetchData(knNumber: String) {
        Task {
            await fetch(knNumber: knNumber)
        }
    }
    
    public func reset() {
        d42rack = D42Rack(rackPk: 0, name: "", roomFk: 0)
    }
    
    @MainActor
    private func fetch(knNumber: String) async {
        guard let knNumberEncoded = knNumber.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: "http://mitsuru.local:8080/api/v1/d42/rack?kn-number=\(knNumberEncoded)") else{ return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let json = try decoder.decode(ResultJson.self, from: data)
            self.d42rack = D42Rack(rackPk: json.rackPk, name: json.name, roomFk: json.roomFk)
        }
        catch {
            print("APIコール時にエラーが発生")
        }
    }
}
