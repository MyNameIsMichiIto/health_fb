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
            
            let healthStore: HKHealthStore = HKHealthStore()
            
            let allTypes = Set([HKObjectType.workoutType(),
                                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                                HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                                HKObjectType.quantityType(forIdentifier: .heartRate)!,
                                HKObjectType.quantityType(forIdentifier: .stepCount)!])
            
            
            
            healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
                if !success {
                    // Handle the error here.
                    print("ここまじかよ\(error)")
                }else{
                    
                    var sampleArray: [Double] = []
                    /// 取得したいサンプルデータの期間の開始日を指定する。（今回は７日前の日付を取得する。）
                    let sevenDaysAgo = Calendar.current.date(byAdding: DateComponents(day: -7), to: Date())!
                    let startDate = Calendar.current.startOfDay(for: sevenDaysAgo)
                    
                    /// サンプルデータの検索条件を指定する。（フィルタリング）
                    /// 条件は、取得したいサンプルデータの期間（開始日〜終了日）を指定する。
                    ///
                    /// - Parameters:
                    ///   - withStart: サンプルデータの取得開始日を指定する。
                    ///   - end: サンプルデータの終了日を指定する。
                    ///   - options: 今回は不使用（詳しい情報ご存知でしたらコメントいただけると幸いです）
                    ///   @see https://developer.apple.com/documentation/healthkit/hkquery/1614771-predicateforsamples/
                    let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                                end: Date(),
                                                                options: [])
                    
                    /// サンプルデータを取得するためのクエリを生成する。
                    ///
                    /// - Parameters:
                    ///   - quantityType: サンプルデータのタイプを指定する。（今回は歩数。）
                    ///   - quantitySamplePredicate: サンプルデータの検索条件。（取得したいデータの期間）
                    ///   - options: サンプルデータの計算方法を指定する。今回は１日の合計歩数がほしいので `cumulativeSum` を指定する。
                    ///   - anchorDate: 基準となる日付（時間を数直線とした場合に、アンカー日付は原点で過去・未来両方に伸びる目盛りが作成される。（Documentより））
                    ///                 今回の場合、開始日にアンカーを指定してあげれば、指定した機関のサンプルが取得できます。
                    ///                 （詳しい情報ご存知でしたらコメントいただけると幸いです）
                    ///   - intervalComponents: サンプルの時間間隔の長さを指定する。今回は日別に歩数を取得したいので、間隔は１日で指定する。
                    ///   @see https://developer.apple.com/documentation/healthkit/hkstatisticscollectionquery/1615199-init
                    let query = HKStatisticsCollectionQuery(quantityType: HKObjectType.quantityType(forIdentifier: .stepCount)!,
                                                            quantitySamplePredicate: predicate,
                                                            options: .cumulativeSum,
                                                            anchorDate: startDate,
                                                            intervalComponents: DateComponents(day: 1))
                    
                    /// クエリ結果を配列に格納します
                    ///   @see https://developer.apple.com/documentation/healthkit/hkstatisticscollectionquery/1615755-initialresultshandler
                    query.initialResultsHandler = { _, results, _ in
                        /// `results (HKStatisticsCollection?)` からクエリ結果を取り出す。
                        guard let statsCollection = results else { return }
                        /// クエリ結果から期間（開始日・終了日）を指定して歩数の統計情報を取り出す。
                        statsCollection.enumerateStatistics(from: startDate, to: Date()) { statistics, _ in
                            /// `statistics` に最小単位（今回は１日分の歩数）のサンプルデータが返ってくる。
                            /// `statistics.sumQuantity()` でサンプルデータの合計（１日の合計歩数）を取得する。
                            if let quantity = statistics.sumQuantity() {
                                /// サンプルデータは`quantity.doubleValue`で取り出し、単位を指定して取得する。
                                /// 単位：歩数の場合`HKUnit.count()`と指定する。（歩行速度の場合：`HKUnit.meter()`、歩行距離の場合：`HKUnit(from: "m/s")`といった単位を指定する。）
                                let stepValue = quantity.doubleValue(for: HKUnit.count())
                                /// 取得した歩数を配列に格納する。
                                sampleArray.append(floor(stepValue))
                                print("sampleArray", sampleArray)
                            } else {
                                // No Data
                                sampleArray.append(0.0)
                                print("sampleArray", sampleArray)
                            }
                        }
                    }
                    HKHealthStore().execute(query)
                    
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
