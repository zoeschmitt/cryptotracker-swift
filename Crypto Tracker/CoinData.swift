//
//  CoinData.swift
//  Crypto Tracker
//
//  Created by Zoe Schmitt on 3/10/19.
//  Copyright © 2019 Zoe Schmitt. All rights reserved.
//

import UIKit
import Alamofire
//all we need to do to add a new crypto is to add it to the symbols array and add the image with the same symbol name in assets.

class CoinData {
    
    static let shared = CoinData()      //singleton
    var coins = [Coin]()        //array of Coins
    
    //Delegates are a design pattern that allows one object to send messages to another object when a specific event happens
    weak var delegate : CoinDataDelegate?
    
    //private init is an initializer for everytime CoinData is called
    private init() {
        let symbols = ["BTC", "ETH", "LTC"]     //symbols for cryptos
        
        //for loop symbol that iterates through our symbols array
        for symbol in symbols {
            
            let coin = Coin(symbol: symbol) //let coin = the first symbol (BTC) this passes it through to Coin class
            coins.append(coin)      //append new coin to coins array
        }
    }
    
    func netWorthAsString() -> String {
        
        var netWorth = 0.0
        
        for coin in coins {
            netWorth += coin.amount * coin.price
        }
        
        return doubleToMoneyString(randomDouble: netWorth)
    }
    
    
    //this function gathers all cryptos and requests them from the api
    func getPrices() {
        
        var listOfSymbols = ""
        
        //iterates in coins array, if its not the last one it will place a comma in between
        //this makes the listOfSymbols witch will be put in the alamo request
        for coin in coins {
            listOfSymbols += coin.symbol
            
            if coin.symbol != coins.last?.symbol {
                listOfSymbols += ","
            }
        }
        //requesting for crypto information and dealing with the response in order to get the prices and put them in price var
        Alamofire.request("https://min-api.cryptocompare.com/data/pricemulti?fsyms=\(listOfSymbols)&tsyms=USD").responseJSON { (response)
            in
            if let json = response.result.value as? [String: Any] {
                for coin in self.coins {
                    if let coinJSON = json[coin.symbol] as? [String: Double] {
                        if let price = coinJSON["USD"] {
                            coin.price = price
                        }
                    }
                }
                self.delegate?.newPrices?() //calling the newPrices func to reload the data
            }
        }
    }
    func doubleToMoneyString(randomDouble: Double) -> String { //takes in double and returns string
        
        //uses apple library to put in commas and $ to the price
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        //using if statement because it was making it optional. code should work but just incase were making it an if else
        if let fancyPrice = formatter.string(from: NSNumber(floatLiteral: randomDouble)) {
            return fancyPrice
        } else {
            return "error"
        }
    }
}
//reloads coin price data
@objc protocol CoinDataDelegate: class {
    @objc optional func newPrices()
    @objc optional func newHistory()
    
}

class Coin {
    var symbol = ""
    var image = UIImage()
    var price = 0.0
    var amount = 0.0
    var historicalData = [Double]()
    
    //initializer function for a Coin
    init(symbol: String) {
        self.symbol = symbol    //says the symbol in Coin is now equal to symbol passed through
        
        //if statement that says if there is an image equal to the symbol, then make the image in Coin equal to that
        if let image = UIImage(named: symbol) {
            self.image = image      //setting image in Coin equal to image
        }
    }
    
    func getHistoricalData() {
        
        Alamofire.request("https://min-api.cryptocompare.com/data/histoday?fsym=\(symbol)&tsym=USD&limit=30").responseJSON{ (response)
            in
            if let json = response.result.value as? [String: Any] {
                if let pricesJSON = json["Data"] as? [[String:Double]] { //array of dictionaries
                    self.historicalData = []
                    for priceJSON in pricesJSON {
                        if let closePrice = priceJSON["close"] {
                            self.historicalData.append(closePrice)
                        }
                    }
                    CoinData.shared.delegate?.newHistory?() //calls newhistory basically saying we have new info
                }
            }
        }
    }
    
    func priceAsString() -> String {    //doesnt take anything in, just returns a string
        
        //shows loading instead of 0.0
        if price == 0.0 {
            return "Loading..."
        }
        
        //converting the price into prettier price using coindata class function
        return CoinData.shared.doubleToMoneyString(randomDouble: price)
    }
    
    func amountAsString() -> String {
        return CoinData.shared.doubleToMoneyString(randomDouble: amount * price)
    }
}


