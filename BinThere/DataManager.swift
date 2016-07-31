//
//  DataManager.swift
//  govhack
//
//  Created by Brendan Hodkinson on 29/07/2016.
//  Copyright © 2016 Brendan Hodkinson. All rights reserved.
//

import Foundation
import CoreLocation

enum Type {
    case None
    case Recycling
    case Dog
    case Waste
    case ButtOut
    case Combo
}

struct Bin{
    var location:CLLocation
    var type:Type
    var fullType:String
    var distFrom:Double = 0.00
}

class DataManager {
    var binDict: [Bin] = [];
    var FilePaths: [String] = ["HobartBins", "LauncestonBins"]

    init() {
        for file in FilePaths {
            if let path = NSBundle.mainBundle().pathForResource(file, ofType: ".csv") {
                var data: String
                do {
                    try data = String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
                    var datalist = data.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
                    datalist.removeAtIndex(0)
                    for element in datalist {
                        if(element == "") {
                            continue
                        }
                        let newBinItem = createBinItem(element)
                        binDict.append(newBinItem);
                    }
                } catch {
                    NSLog("Unable to import data")
                }
            }
        }
    }
    
    
    func createBinItem(element:String) -> Bin{
        
        NSLog("Appending " + element + "to binDict");
        let dataItem = element.characters.split{$0 == ","}.map(String.init)
        var newBinItem = Bin.init(location: CLLocation.init(latitude: Double(dataItem[1])!, longitude: Double(dataItem[0])!), type: Type.None, fullType: dataItem[2],distFrom: 0.00)
        switch(dataItem[3]){
        case "W":
            newBinItem.type = Type.Waste
            break
        case "R":
            newBinItem.type = Type.Recycling
            break
        case "D":
            newBinItem.type = Type.Dog
            break
        case "C":
            newBinItem.type = Type.Combo
            break
        case "B":
            newBinItem.type = Type.ButtOut
            break
        default:
            newBinItem.type = Type.None;
            break
        }
        
        return newBinItem
    }
    
    func getRubbishBins() -> [Bin]{
        var binList:[Bin] = []
        
        for element in binDict{
            if (element.type == Type.Waste || element.type == Type.Combo || element.type == Type.Recycling)
            {
                binList.append(element)
            }
        }
        
        return binList
    }
    
    func getRecyclingBins() -> [Bin]{
        var binList:[Bin] = []
        
        for element in binDict{
            if (element.type == Type.Combo || element.type == Type.Recycling)
            {
                binList.append(element)
            }
        }
        
        return binList
    }
    
    func getButtBins() -> [Bin]{
        var binList:[Bin] = []
        
        for element in binDict{
            if(element.type == Type.ButtOut || element.type == Type.Waste || element.type == Type.Combo){
                binList.append(element)
            }
        }
        
        return binList
    }
    
    func getDogBins() -> [Bin]{
        var binList:[Bin] = []
        
        for element in binDict{
            if (element.type == Type.Dog)
            {
                binList.append(element)
            }
        }
        
        return binList
    }
    
    func getClosestBins(curLocation:CLLocation) -> [Bin]{
        var rubbish:Bin?
        var recycle:Bin?
        var dogWaste:Bin?
        var buttOut:Bin?

        var distToRubbish = 99999.00
        var distToRecycle = 99999.00
        var distToDogWaste = 99999.00
        var distTobuttOut = 99999.00

        for bin in binDict{
            let binDistAway = bin.location.distanceFromLocation(curLocation)
            switch(bin.type){
                case Type.Waste:
                    if (distToRubbish == 99999.00 || binDistAway < distToRubbish){
                        rubbish = bin
                        rubbish!.distFrom = binDistAway
                        distToRubbish = binDistAway
                    }
                    break;
            case Type.Combo:
                if (distToRubbish == 99999.00 || binDistAway < distToRubbish){
                    rubbish = bin
                    rubbish!.distFrom = binDistAway
                    distToRubbish = binDistAway
                }
                if (distToRecycle == 99999.00 || binDistAway < distToRecycle){
                    recycle = bin
                    recycle!.distFrom = binDistAway
                    distToRecycle = binDistAway
                }
                break;
            case Type.Recycling:
                if (distToRecycle == 99999.00 || binDistAway < distToRecycle){
                    recycle = bin
                    recycle!.distFrom = binDistAway
                    distToRecycle = binDistAway
                }
                break;
            case Type.Dog:
                if (distToDogWaste == 99999.00 || binDistAway < distToDogWaste){
                    dogWaste = bin
                    dogWaste!.distFrom = binDistAway
                    distToDogWaste = binDistAway
                }
                break;
            case Type.ButtOut:
                if (distTobuttOut == 99999.00 || binDistAway < distTobuttOut){
                    buttOut = bin
                    buttOut!.distFrom = binDistAway
                    distTobuttOut = binDistAway
                }
                break;
            default: break
            }


        }
        let binList:[Bin] = [rubbish!,recycle!,dogWaste!,buttOut!]
        
        return binList
    }

    func getBins(near:CLLocation, within:CLLocationDistance) -> [Bin] {
        var returnList:[Bin] = []
        
        for bin in binDict{
            if (near.distanceFromLocation(bin.location) < within){
                returnList.append(bin)
            }
        }
        
        return returnList
    }
}