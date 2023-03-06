//
//  D42DeviceModel.swift
//  QRReader
//
//  Created by 竹田恭 on 2023/03/06.
//

import Foundation

struct D42Device: Identifiable {
    let id = UUID()
    let devicePk: Int
    let customerFk: Int
    let buildingFk: Int
    let roomFk: Int
    let rackFk: Int
    let hardwareFk: Int
    let vendorFk: Int
    let name: String
    let serialNo: String
    let startAt: String
    let orientation: String
    let xpos: String
    let statusOfUse: String
    let status: String
    let knNumber: String
    let assetNumber: String
    let hardwareType: String
    let pduWhere: String
}

class D42DeviceModel: ObservableObject {
    struct ResultJson: Codable {
        let devicePk: Int
        let customerFk: Int
        let buildingFk: Int
        let roomFk: Int
        let rackFk: Int
        let hardwareFk: Int
        let vendorFk: Int
        let name: String
        let serialNo: String
        let startAt: String
        let orientation: String
        let xpos: String
        let statusOfUse: String
        let status: String
        let knNumber: String
        let assetNumber: String
        let hardwareType: String
        let pduWhere: String
    }
    
    @Published var d42DeviceList: [D42Device] = []
    
    func fetchData(knNumberList: [String]) {
        Task {
            await fetch(knNumberList: knNumberList)
        }
    }
    
    func getNameList() -> [ListItem] {
        var nameList: [ListItem] = []
        for d42Device in d42DeviceList {
            nameList.append(ListItem(name: d42Device.name))
        }
        return nameList
    }
    
    public func removeAll() {
        d42DeviceList.removeAll()
    }
    
    @MainActor
    private func fetch(knNumberList: [String]) async {
        for knNumber in knNumberList {
            guard let knNumberEncoded = knNumber.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            guard let url = URL(string: "http://mitsuru.local:8080/api/v1/d42/device?kn-number=\(knNumberEncoded)") else{ return }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoder = JSONDecoder()
                let json = try decoder.decode(ResultJson.self, from: data)
                
                if d42DeviceList.contains(where: { $0.devicePk == json.devicePk }) {
                    continue
                }
                
                self.d42DeviceList.append(
                    D42Device(devicePk: json.devicePk, customerFk: json.customerFk, buildingFk: json.buildingFk, roomFk: json.roomFk, rackFk: json.rackFk, hardwareFk: json.hardwareFk, vendorFk: json.vendorFk, name: json.name, serialNo: json.serialNo, startAt: json.startAt, orientation: json.orientation, xpos: json.xpos, statusOfUse: json.statusOfUse, status: json.status, knNumber: json.knNumber, assetNumber: json.assetNumber, hardwareType: json.hardwareType, pduWhere: json.pduWhere)
                    )
            }
            catch {
                print("APIコール時にエラーが発生")
            }
        }
    }
}
