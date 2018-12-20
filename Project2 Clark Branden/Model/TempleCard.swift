//
//  Temple.swift
//  Project2 Clark Branden
//
//  Created by Branden Clark on 10/17/18.
//  Copyright © 2018 Branden Clark. All rights reserved.
//

import Foundation

class TempleCard {
    // MARK: - Properties
    private var name: String
    private var region: String
    private var fileName: String
    private var isStudyMode: Bool
    
    // MARK: - Constructor
    init(fileName: String, name: String, region: String){
        self.name = name
        self.fileName = fileName
        self.region = region
        self.isStudyMode = false
    }
    
    // MARK: - Getters
    func getRegion() -> String {
        return self.region
    }
    
    func getName() -> String {
    return self.name
    }
    
    func getFileName() -> String {
        return self.fileName
    }
    
    func getIsStudyMode() -> Bool {
        return self.isStudyMode
    }
    
    // MARK: - Setters
    func toggleStudyMode() {
        if self.isStudyMode {
            self.isStudyMode = false
        } else {
            self.isStudyMode = true
        }
    }
    
}
