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
        VStack{
            HStack{
                Text("歩数")
                Text("100歩")
            }
            HStack{
                Text("テスト")
                Text("テスト２")
            }
            
        }
        
        
        
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
                    print("ここまじかよ\(error)")
                }else{
                    let today = Date()
                    let yesterday = Calendar.current.date(byAdding: .day,value: -1, to: Date())!
                    let yesterday2 = Calendar.current.date(byAdding: .day,value: -10, to: Date())!
                    // 健康データ読み出し
                    let query = HKSampleQuery(sampleType: HKSampleType.quantityType(forIdentifier: .stepCount)!,
                                              predicate: HKQuery.predicateForSamples(withStart: yesterday2, end: yesterday, options: []),
                                              limit: HKObjectQueryNoLimit,
                                              sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)]){ (query, results, error) in
                        
                        if results is [HKQuantitySample] {
                            // 当該箇所で取得したデータを表示用に加工等の処理
                            
                            print("ここは通ってる")
                        }else{
                            print("ここ通ってがっかり\(error)それと\(query)それと\(results)")
                        }
                    }
                    healthStore.execute(query)
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
