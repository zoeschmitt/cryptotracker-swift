//
//  CoinData.swift
//  Crypto Tracker
//
//  Created by Zoe Schmitt on 3/10/19.
//  Copyright © 2019 Zoe Schmitt. All rights reserved.
//

import UIKit

class CoinData {
    static let shared = CoinData()
    var coins = [Coin]()
    
    private init() {
        let symbols = ["BTC", "ETH", "LTC"]
        
        for                                 //what we are doing here is saying that when we start the singleton for
                                            //CoinData, we wanna make 3 coin objects with these symbols and pass them
                                            //to the coins array
    }
}

class Coin {
    var symbol = ""
    var image = UIImage()
    var price = 0.0
    var amount = 0.0
    var historicalData = [Double]()
}
