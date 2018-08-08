//
//  StudentSingleExamChartTableViewController.swift
//  ProjectCP101005Swift
//
//  Created by Ming-Ta Yang on 2018/8/8.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit
import Charts

class StudentSingleExamChartTableViewController: UITableViewController {
    
    var scoreList = [Int]()
    var scoreAPlusList = [Int]()
    var scoreAList = [Int]()
    var scoreBList = [Int]()
    var scoreCList = [Int]()
    var scoreDList = [Int]()
    var scoreEList = [Int]()
    var examID = 0
    
    @IBOutlet weak var examNameLabel: UILabel!
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var aPlusCountLabel: UILabel!
    @IBOutlet weak var aCountLabel: UILabel!
    @IBOutlet weak var bCountLabel: UILabel!
    @IBOutlet weak var cCountLabel: UILabel!
    @IBOutlet weak var dCountLabel: UILabel!
    @IBOutlet weak var eCountLabel: UILabel!
    @IBOutlet weak var averageScoreLabel: UILabel!
    @IBOutlet weak var highestScoreLabel: UILabel!
    @IBOutlet weak var lowestScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Table view data source
     
     override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 0
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // #warning Incomplete implementation, return the number of rows
     return 0
     }
     */
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - ConfigureView
    func configureView(){
        
        //取得分數資料
        getDataFromDB()
        
        var highestScore = 0
        var lowestScore = 100
        var totalScore = 0
        
        scoreAPlusList.removeAll()
        scoreAList.removeAll()
        scoreBList.removeAll()
        scoreCList.removeAll()
        scoreDList.removeAll()
        scoreEList.removeAll()
        
        for score in scoreList {
            totalScore += score
            if score > highestScore {
                highestScore = score
            }
            if score < lowestScore {
                lowestScore = score
            }
            
            if score == 100 {
                scoreAPlusList.append(score)
            } else if score >= 90 {
                scoreAList.append(score)
            } else if score >= 80 {
                scoreBList.append(score)
            } else if score >= 70 {
                scoreCList.append(score)
            } else if score >= 60 {
                scoreDList.append(score)
            } else {
                scoreEList.append(score)
            }
            
        }
        
        aPlusCountLabel.text = String(scoreAPlusList.count) + "人"
        aCountLabel.text = String(scoreAList.count) + "人"
        bCountLabel.text = String(scoreBList.count) + "人"
        cCountLabel.text = String(scoreCList.count) + "人"
        dCountLabel.text = String(scoreDList.count) + "人"
        eCountLabel.text = String(scoreEList.count) + "人"
        let average = Double(totalScore) / Double(scoreList.count)
        averageScoreLabel.text = String(format: "%.2f", average) + "分"
        highestScoreLabel.text = String(highestScore) + "分"
        lowestScoreLabel.text = String(lowestScore) + "分"
        
        updateCharts()
    }
    
    // MARK: - Charts
    func updateCharts(){
        
        //modify chart
        barChart.legend.enabled = false //隱藏左下顯示dataSet的標籤
        barChart.rightAxis.drawLabelsEnabled = false //右邊不用值
        barChart.rightAxis.drawGridLinesEnabled = false //右邊不用格子框線
        barChart.isUserInteractionEnabled = false //不能互動
        barChart.chartDescription?.enabled = false //關閉右下描述
        
        let xAxisValueFormatter = ScoreAxisValueFormatter()
        barChart.xAxis.valueFormatter = xAxisValueFormatter //設定x軸label
        
        let yAxis = barChart.leftAxis
        yAxis.granularity = 1.0 //y軸只能有整數且為1
        yAxis.granularityEnabled = true
        yAxis.axisMinimum = 0.0 //設定最小值
        
        //set data
        let values = getAllScores() //自方，取得值的資料
        
        let dataSet = BarChartDataSet(values: values, label: "")
        let valueFormatter = PeopleCountValueFormatter()
        dataSet.valueFormatter = valueFormatter  //設定值的標籤
        //        dataSet.colors = ChartColorTemplates.joyful()
        //        dataSet.valueColors = [UIColor.black]
        
        let data = BarChartData(dataSets: [dataSet])
        barChart.data = data
        
        barChart.notifyDataSetChanged()
        
        
    }
    
    func getAllScores() -> [BarChartDataEntry] { //自方，產生值的資料
        var entries = [BarChartDataEntry]()
        
        entries.append(BarChartDataEntry(x: 1.0, y: Double(scoreEList.count)))
        entries.append(BarChartDataEntry(x: 2.0, y: Double(scoreDList.count)))
        entries.append(BarChartDataEntry(x: 3.0, y: Double(scoreCList.count)))
        entries.append(BarChartDataEntry(x: 4.0, y: Double(scoreBList.count)))
        entries.append(BarChartDataEntry(x: 5.0, y: Double(scoreAList.count)))
        entries.append(BarChartDataEntry(x: 6.0, y: Double(scoreAPlusList.count)))
        return entries
        
    }
    
    func getDataFromDB(){
        
        guard examID != 0 else{
            assertionFailure("examID not found")
            return
        }
        
        //get data from DB
        guard let url = URL(string: PropertyKeysForConnection.urlHomeworkServlet) else {
            assertionFailure()
            return
        }
        
        let dictionary: [String: Any] = ["action": "findAchievementByExamId", "examId": examID]
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
            else {
                assertionFailure("fail to create JsonObject")
                return
        }
        
        let communicator = CommunicatorMingTa(targetURL: url)
        communicator.download(from: data) { (error, data) in
            
            if let error = error {
                print("\(#function) error: \(error)")
                return
            }
            
            guard let data = data else {
                assertionFailure()
                return
            }
            
            let jsonDeconder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            jsonDeconder.dateDecodingStrategy = .formatted(dateFormatter)
            
            do{
                try self.scoreList = jsonDeconder.decode([Int].self, from: data)
                
            } catch {
                assertionFailure("json parse fail: \(error)")
                return
            }
            
        }
        
    }
    
    
}
