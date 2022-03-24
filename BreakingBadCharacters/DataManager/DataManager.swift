//
//  DataManager.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 24/3/22.
//

import Foundation

class DataManager {
    let remoteDataManager: RemoteDataManager
    
    let localDataManager: LocalDataManager

    init(remoteDataManager: RemoteDataManager, localDataManager: LocalDataManager) {
        self.remoteDataManager = remoteDataManager
        self.localDataManager = localDataManager
    }
}
