//  Gambler Zone.swift
//  Henry'sJoy
//
//  Created by Yi Ling on 2/10/24.
//

import Foundation
import SwiftUI

struct HenryZone: View {
    @ObservedObject var coreComponents: CoreGameComponent
    @State private var dummy: Bool = false
    @State private var isProcessing: Bool = false

    
    var body: some View {
        Text("currentStackedScore:\(coreComponents.Henry.currentStackedScore)")
            .id(dummy)

        Text("stackedScore:\(coreComponents.Henry.stackedScore)")
            .id(dummy)
        
        Text("TotalScore:\(coreComponents.Henry.currentScore)")
            .id(dummy)
        
        let possibleScore = coreComponents.getScore(match: coreComponents.Henry.currentThrow)
        
        if (coreComponents.round % 2 == 1 && (coreComponents.Henry.turn == 0 || possibleScore > 0 || coreComponents.Henry.currentStackedScore > 0) ){
            VStack{
                if (coreComponents.Henry.turn == 0){
                    Button("Roll Dice"){
                        coreComponents.rollDice(p: coreComponents.Henry)
                        dummy.toggle()
                        
                    }
                }else{
                    
                    if (coreComponents.judgeIfLegal(match: coreComponents.Henry.tempChosen) && coreComponents.Henry.num_tempChosen >= 1){
                        
                        Button("Throw again"){
                            coreComponents.stackScore(p: coreComponents.Henry)
                            coreComponents.rollDice(p: coreComponents.Henry)
                            dummy.toggle()
                        }
                        
                        Button("Farkle"){
                            coreComponents.stackScore(p: coreComponents.Henry)
                            coreComponents.farkleScore(p: coreComponents.Henry)
                            dummy.toggle()
                        }
                    }else if (coreComponents.Henry.num_tempChosen < 1){
                        Text("You need to choose at least one dice!")
                    }else{
                        Text("That don't work!")
                    }
                }
                
                HStack{
                    ForEach(Array(coreComponents.Henry.leftOver), id:\.key){ key, value in
                        if (value >= 1){
                            ForEach(0..<value, id: \.self){index in
                                Button("\(key)"){
                                    
                                    if !isProcessing{
                                        
                                        isProcessing = true
                                        
                                        coreComponents.choose(p: coreComponents.Henry, victim: key)
                                        
                                        isProcessing = false
                                    }
                                    dummy.toggle()
                                }
                            }
                        }
                    }
                }
                .padding(50)
                
                HStack{
                    ForEach(Array(coreComponents.Henry.tempChosen), id:\.key){ key, value in
                        
                        if (value >= 1){
                            ForEach(0..<value, id: \.self){index in
                                Button("\(key)"){
                                    if !isProcessing{
                                        isProcessing = true
                                        
                                        coreComponents.dechoose(p: coreComponents.Henry, victim: key)
                                        
                                        isProcessing = false
                                    }
                                    dummy.toggle()
                                }
                            }
                        }
                    }
                }
                .padding(50)
                
                HStack{
                    ForEach(Array(coreComponents.Henry.chosen), id:\.key){ key, value in
                        if (value >= 1){
                            ForEach(0..<value, id: \.self){index in
                                Text("\(key)")
                            }
                        }
                    }
                }
                
            }
        }else if (possibleScore == 0 && coreComponents.round % 2 == 1){
            HStack{
                ForEach(Array(coreComponents.Henry.currentThrow), id:\.key){ key, value in
                    if (value >= 1){
                        ForEach(0..<value, id: \.self){index in
                            Text("\(key)")
                        }
                    }
                }
            }
            Text("Oh no! Henry messed up!")
            Text("It's Gambler's turn now!")
                .onAppear(){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        coreComponents.NextRound(p:coreComponents.Henry)
                    }
                }
        }
        
    }
}

#Preview {
    farkleGame()
}
