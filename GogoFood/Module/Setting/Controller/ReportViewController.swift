//
//  ReportViewController.swift
//  GogoFood
//
//  Created by Apple on 04/05/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import SBCardPopup
import Charts

class ReportViewController: BaseViewController<BaseData> {

    private let repo = SettingRepository()
    @IBOutlet var mainTableView : UITableView!
    @IBOutlet var collectionViewObj : UICollectionView!
    
    var reportsArray : [ReportsData]!
    var monthwiseNameArray : [MonthWise]!
    
    var durationValue = ["Daily".localized(),"Weekly".localized(),"Monthly".localized(),"Annual".localized()]
    var categorySelectedIndex: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createNavigationLeftButton(NavigationTitleString.report.localized())
        //self.navigationItem.rightBarButtonItem = self.createFilterBarButton()
        
        self.mainTableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callReportAPI(typeStr: "all")
    }
    
    func createFilterBarButton() -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "filter.png"), for: .normal)
        button.addTarget(self, action: #selector(tapOnFilterButtton), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 53, height: 51)
        let barButton = UIBarButtonItem(customView: button)
        return barButton
    }
    
    @objc func tapOnFilterButtton() {
        let popupContent = ReportFilterViewController.create()
        let cardPopup = SBCardPopupViewController(contentViewController: popupContent)
        cardPopup.show(onViewController: self)
    }
    
    func callReportAPI(typeStr : String) {
        repo.getReportList(typeStr: typeStr, onComplition: { (data) in
            self.reportsArray = data.reportsData
            self.repo.getReportGraph(onComplition: { (monthData) in
                self.monthwiseNameArray = monthData.monthWise
                self.mainTableView.reloadData()
            })
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.categorySelectedIndex = 0
        self.collectionViewObj.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class BarGraphTableCell: UITableViewCell {
    @IBOutlet var barChartView: BarChartView!
    weak var axisFormatDelegate: IAxisValueFormatter?
    var months: [String]!
    var unitsSold = [Double]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //barChartView.delegate = self
        axisFormatDelegate = self
        months  = ["Roasted Beef", "Banana Shake", "French Fried", "Beef Steak"]
        unitsSold  = [20.0, 54.0, 30.0, 92.0]
        setChart(dataPoints: months, values: unitsSold)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {

            barChartView.noDataText = "You need to provide data for the chart."

            // Prevent from setting an empty data set to the chart (crashes)
            guard dataPoints.count > 0 else { return }

            var dataEntries = [BarChartDataEntry]()

            for i in 0..<dataPoints.count {
                let entry = BarChartDataEntry(x: Double(i), y: values[i], data: months as AnyObject?)
                dataEntries.append(entry)
            }

            let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Units Sold")
            chartDataSet.drawValuesEnabled = true
            chartDataSet.colors = [UIColor.red]
            chartDataSet.colors = [UIColor.lightGray]
            chartDataSet.highlightColor = UIColor.orange.withAlphaComponent(0.3)
            chartDataSet.highlightAlpha = 1
            let chartData = BarChartData(dataSet: chartDataSet)
            barChartView.data = chartData
            let xAxisValue = barChartView.xAxis
            xAxisValue.valueFormatter = axisFormatDelegate

            chartDataSet.colors = ChartColorTemplates.colorful()    //multiple colors

            //Animation bars
            barChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0, easingOption: .easeInCubic)

            // X axis configurations
            barChartView.xAxis.granularityEnabled = true
            barChartView.xAxis.granularity = 1
            barChartView.xAxis.drawAxisLineEnabled = true
            barChartView.xAxis.drawGridLinesEnabled = false
            barChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 15.0)
            barChartView.xAxis.labelTextColor = UIColor.black
            barChartView.xAxis.labelPosition = .bottom
            barChartView.xAxis.labelRotationAngle = -30
            //barChartView.xAxis.wordWrapEnabled = true
        
            // Right axis configurations
            barChartView.rightAxis.drawAxisLineEnabled = false
            barChartView.rightAxis.drawGridLinesEnabled = false
            barChartView.rightAxis.drawLabelsEnabled = false

            // Other configurations
            barChartView.highlightPerDragEnabled = false
            barChartView.chartDescription?.text = ""
            barChartView.legend.enabled = false
            barChartView.pinchZoomEnabled = false
            barChartView.doubleTapToZoomEnabled = false
            barChartView.scaleYEnabled = false

            barChartView.drawMarkers = true

            let l = barChartView.legend
            l.horizontalAlignment = .left
            l.verticalAlignment = .bottom
            l.orientation = .horizontal
            l.drawInside = false
            l.form = .circle
            l.formSize = 9
            l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
            l.xEntrySpace = 4
        }
}

class LineGraphTableCell: UITableViewCell {
    
    var lineGraphView: LineChart!
    var graphWidth : CGFloat!
    var dateStr : [String]!
    var GraphStr : [String]!
    var monthwiseNameArray : [MonthWise]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func createGraphView() {
        
        self.dateStr = self.monthwiseNameArray.compactMap({$0.name})
        self.GraphStr = self.monthwiseNameArray.compactMap({$0.total?.toString()})
        
        var valueObj = [CGFloat]()
        for item in self.GraphStr {
            valueObj.append(CGFloat((item as NSString).floatValue))
        }
        
        self.graphWidth = self.frame.size.width
        lineGraphView = LineChart()
        lineGraphView.frame = CGRect(x: 0, y: 0, width: self.graphWidth, height: self.frame.size.height)
        lineGraphView.animation.enabled = true
        lineGraphView.area = true
        lineGraphView.x.grid.visible = false
        lineGraphView.x.labels.visible = true
        lineGraphView.y.grid.visible = false
        lineGraphView.y.labels.visible = true
        lineGraphView.dots.visible = true
        
        lineGraphView.x.grid.count = 5
        lineGraphView.y.grid.count = 5
        
        lineGraphView.x.labels.values = self.dateStr
        lineGraphView.addLine(valueObj)
        let bgColor: [UIColor] = [AppConstant.appBlueColor]
        
        lineGraphView.colors = bgColor
        self.addSubview(lineGraphView)

    }
    
}

class ReportsTopTableCell: UITableViewCell {
    
    @IBOutlet weak var lbl_amount: UILabel!
    @IBOutlet weak var lbl_qty: UILabel!
    @IBOutlet weak var lbl_orderStats: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lbl_amount.text = "Amount".localized()
        lbl_qty.text = "Qty".localized()
        lbl_orderStats.text = "Order Statistics".localized()
    }
}

class ReportsBottomTableCell: UITableViewCell {
    
    @IBOutlet weak var lbl_totalOrder: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class ReportsTableCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class ReportsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension ReportViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.reportsArray == nil{
            return 0
        }
        return self.reportsArray.count + 3
      }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.reportsArray.count+2{
            return 300
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let optionCell = tableView.dequeueReusableCell(withIdentifier: "ReportsTopTableCell") as! ReportsTopTableCell
            optionCell.selectionStyle = .none
            return optionCell
        }else if indexPath.row == self.reportsArray.count+1{
            let optionCell = tableView.dequeueReusableCell(withIdentifier: "ReportsBottomTableCell") as! ReportsBottomTableCell
            optionCell.selectionStyle = .none
            return optionCell
        }else if indexPath.row == self.reportsArray.count+2{
            let optionCell = tableView.dequeueReusableCell(withIdentifier: "LineGraphTableCell") as! LineGraphTableCell
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                if optionCell.lineGraphView != nil{
                    optionCell.lineGraphView.removeFromSuperview()
                }
                optionCell.monthwiseNameArray = self.monthwiseNameArray
                optionCell.createGraphView()
            })
            optionCell.selectionStyle = .none
            return optionCell
        }
//        else if indexPath.row == self.reportsArray.count+3{
//            let optionCell = tableView.dequeueReusableCell(withIdentifier: "BarGraphTableCell") as! BarGraphTableCell
//            optionCell.selectionStyle = .none
//            return optionCell
//        }
        let optionCell = tableView.dequeueReusableCell(withIdentifier: "ReportsTableCell") as! ReportsTableCell
        optionCell.titleLbl.text = self.reportsArray[indexPath.row-1].name?.localized() ?? ""
        optionCell.qtyLbl.text = self.reportsArray[indexPath.row-1].count?.toString() ?? "0"
        optionCell.totalLbl.text = String(format: "$ %.2f", self.reportsArray[indexPath.row-1].total ?? 0.0)
        optionCell.selectionStyle = .none
        return optionCell
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ReportViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.durationValue.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellObj = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportsCollectionCell", for: indexPath) as! ReportsCollectionCell
        cellObj.titleLbl.text = self.durationValue[indexPath.row]
        if self.categorySelectedIndex == indexPath.row{
            cellObj.mainView.backgroundColor = AppConstant.primaryColor
            cellObj.titleLbl.textColor = AppConstant.appOffWhiteColor
        }else{
            cellObj.mainView.backgroundColor = AppConstant.appOffWhiteColor
            cellObj.titleLbl.textColor = AppConstant.primaryColor
        }
        return cellObj
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.categorySelectedIndex = indexPath.row
        if indexPath.row == 0{
            self.callReportAPI(typeStr: "all")
        }else if indexPath.row == 1{
            self.callReportAPI(typeStr: "weekly")
        }else if indexPath.row == 2{
            self.callReportAPI(typeStr: "monthly")
        }else if indexPath.row == 3{
            self.callReportAPI(typeStr: "yearly")
        }
        self.collectionViewObj.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let padding: CGFloat =  30
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/4, height: 40)
    }
}

extension BarGraphTableCell: IAxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value)]
    }
}
