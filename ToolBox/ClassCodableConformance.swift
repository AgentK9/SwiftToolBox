//
//  ClassCodableConformance.swift
//  ToolBox
//
//  Created by Keegan on 5/27/20.
//  Copyright © 2020 BirtData. All rights reserved.
//

import Foundation

class exampleClass: Codable {
    var exampleAttrA: Int
    // note: 'let's don't work. Use private(set) public var
    private(set) public var exampleAttrB: String
    
    init(eAttrA: Int, eAttrB: String) {
        self.exampleAttrA = eAttrA
        self.exampleAttrB = eAttrB
    }
    
    // MARK: Codable Conformance
    // MARK:  - Decodable Conformance
    enum CodingKeys: CodingKey {
        case exampleAttrA, exampleAttrB
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let exampleAttrAP = try? container.decode(Int.self, forKey: .exampleAttrA) {
            exampleAttrA = exampleAttrAP
        } else {
            exampleAttrA = 0
            print("Problem with decoding exampleAttrA")
        }
        
        if let exampleAttrBP = try? container.decode(String.self, forKey: .exampleAttrB) {
            exampleAttrB = exampleAttrBP
        } else {
            exampleAttrB = ""
            print("Problem with decoding exampleAttrB")
        }
    }
    
    func read() {
        let decoder: JSONDecoder = JSONDecoder()
        let filePath: String = "blends.json"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(filePath)
            do {
                let dataString: String = try String(contentsOf: fileURL, encoding: .utf8)
                print(dataString.utf8)
                guard let decoded = try? decoder.decode(exampleClass.self, from: Data(dataString.utf8)) else {
                    print("Did not decode data")
                    return
                }
                
                self.exampleAttrA = decoded.exampleAttrA
                self.exampleAttrB = decoded.exampleAttrB
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK:  - Encodable Conformance
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(exampleAttrA, forKey: .exampleAttrA)
        try container.encode(exampleAttrB, forKey: .exampleAttrB)
    }
    
    func write() {
        let filePath: String = "exampleClass.json"
        let encoder: JSONEncoder = JSONEncoder()
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(filePath)
            
            if let encoded = try? encoder.encode(self) {
                let text: String = String(data: encoded, encoding: .utf8)!
                print(text)
                do {
                    try text.write(to: fileURL, atomically: false, encoding: .utf8)
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
