//
//  ADOTTableCellTest.swift
//  JPNasaAPODTests
//
//  Created by kumaresh shrivastava on 21/01/2022.
//

import XCTest
@testable import JPNasaAPOD

class APDOExtensionHelperTest: XCTestCase {

    var opadDataProtocol:APODModelProtocol?
    var apodCellView:ADOTableViewCell = ADOTableViewCell()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        opadDataProtocol = APODModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        opadDataProtocol = nil
    }
    
    func test_convert_to_month_day_year_format() -> Void {
        let tempString = "2020-06-14"
        let dateSTr = tempString.convertToMonthDayYear()
        XCTAssertEqual( dateSTr, "Jun 14, 2020")
    }
    
    func test_Convert_to_yyyyMMdd_format() -> Void {
        let tempDate = "2020-01-10" 
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: tempDate)
        let tempDateString = DateFormatter.yyyyMMdd.string(from: date!)
        XCTAssertEqual( tempDateString, tempDate)
    }
    
    func test_get_videoId_from_video_SourceUrl() -> Void {
        let mediaUrl = "https://www.youtube.com/embed/M6-iC_aYcug?rel=0"
        let videoId = apodCellView.getVideoIdFrom(VideoSource: mediaUrl)
        XCTAssertEqual( videoId, "M6-iC_aYcug?rel=0")
    }
    
    
    func test_to_check_Invalid_data() {
        let responseString = "[]"
        let data = Data(responseString.utf8)
        let isInValidData = data.isInValid()
        XCTAssertTrue(isInValidData)
    }
    
   
}
