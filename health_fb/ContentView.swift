//
//  ContentView.swift
//  health_fb
//
//  Created by 伊藤倫 on 2023/04/13.
//

import SwiftUI
import CoreData
import HealthKit

@available(macOS 13.0, *)
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        Text("こんにちは")
        
        
            .onAppear(){
                self.health_data()
            }
    }
    
    func health_data(){
        if HKHealthStore.isHealthDataAvailable(){
            let allTypes = Set([HKObjectType.workoutType(),
                                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                                HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                                HKObjectType.quantityType(forIdentifier: .heartRate)!])
            
            let healthStore = HKHealthStore()
            
            healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
                if !success {
                    // Handle the error here.
                }
            }
            
        }else{
            print("ここナッツ")
        }
    }
    
}

@available(macOS 13.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
