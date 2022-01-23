//
//  JPNasaAPODTests.swift
//  JPNasaAPODTests
//
//  Created by kumaresh shrivastava on 19/01/2022.
//

import XCTest
@testable import JPNasaAPOD

class JPNasaAPODTests: XCTestCase,PayLoadFormat {

    
    var apiInteractorProtocol:APODResourceAPIInteractorProtocol?
    var apiModuleProtocol:APIModuleProtocol?
    var apodRequestProtocol:APODRequestProtocol?
    var apiManager: ApiManagerProtocol?
    var coreDataStackTest: CoreDatatStackTest!
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        apiModuleProtocol = APIModule()
        apodRequestProtocol = APODRequest()
        apiManager =  ApiManager()
        coreDataStackTest = CoreDatatStackTest()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        apiInteractorProtocol = nil
        apiModuleProtocol = nil
        apodRequestProtocol = nil
        apiManager = nil
    }
    /**
         Test the payload format which is used for the Api call
     */
    func test_format_https_payLoad() -> Void {
        apiModuleProtocol?.payloadType = .requestMethodGET
        apiModuleProtocol?.dateToSearch = "2020-07-10"
        let urlStr = URL(string:"https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&start_date=2020-07-10&end_date=2020-07-10")
        let httpsPayLoadProtocol:HTTPPayloadProtocol = formatGetPayload(url: .AODURL, module: apiModuleProtocol!)
        XCTAssertEqual(httpsPayLoadProtocol.url?.absoluteURL, urlStr?.absoluteURL)
        XCTAssertEqual(httpsPayLoadProtocol.type, HTTPPayloadType.requestMethodGET)
    }
    /**
     Test check APODResouseApi interactor class to get apod data response
     */
    func test_apod_dataresponse_success() -> Void {
        
        apiManager =  ApiManager()
        apodRequestProtocol?.startDate = "2020-07-10"
        apodRequestProtocol?.endDate = "2020-07-10"
        apiModuleProtocol?.payloadType = .requestMethodGET
        apiModuleProtocol?.dateToSearch = apodRequestProtocol?.startDate ?? ""
        let expect = expectation(description: "API response completion")
        apiInteractorProtocol =  APODResourceAPIInteractor.init(apiModule:apiModuleProtocol!,apodRequest:apodRequestProtocol!,mainContext:coreDataStackTest.mainContext)
        
        apiInteractorProtocol?.getAPODDataRespose() {
            (dataResponse,error) in
            expect.fulfill()
            XCTAssertNil(error)
            XCTAssertNotNil(dataResponse)
           
        }
        waitForExpectations(timeout: 40, handler: nil)
    }
    /**
     Test check APODResouseApi interactor class to get apod error response
     */
    func test_apod_dataresponse_error() -> Void {
        
        apiManager =  ApiManager()
        apodRequestProtocol?.startDate = "20200710"
        apodRequestProtocol?.endDate = "2020-07-10"
        apiModuleProtocol?.payloadType = .requestMethodGET
        apiModuleProtocol?.dateToSearch = apodRequestProtocol?.startDate ?? ""
        let expect = expectation(description: "API response completion")
        apiInteractorProtocol =  APODResourceAPIInteractor.init(apiModule:apiModuleProtocol!,apodRequest:apodRequestProtocol!,mainContext:coreDataStackTest.mainContext)
        
        apiInteractorProtocol?.getAPODDataRespose() {
            (dataResponse,error) in
            expect.fulfill()
            XCTAssertNotNil(error)
            XCTAssertNil(dataResponse)
        }
        waitForExpectations(timeout: 40, handler: nil)
    }

   /**
    Mock Test to check for decode operation of data resposne to coredata codable managed data model
    */
    
    func test_decode_response_to_coredata_codable_managed_datamodel() {
        let responseString = "[{\"copyright\":\"Luk\\ufffd Vesel\\ufffd\",\"date\":\"2019-01-23\",\"explanation\":\"Do you recognize this constellation? Through the icicles and past the mountains is Orion, one of the most identifiable star groupings on the sky and an icon familiar to humanity for over 30,000 years. Orion has looked pretty much the same during the past 50,000 years and should continue to look the same for many thousands of years into the future.  Orion is quite prominent in the sky this time of year, a recurring sign of (modern) winter in Earth\'s northern hemisphere and summer in the south. Pictured, Orion was captured recently above the Austrian Alps in a composite of seven images taken by the same camera in the same location during the same night. Below and slightly to the right of Orion\'s three-star belt is the Orion Nebula, while the four bright stars surrounding the belt are, clockwise from the upper left, Betelgeuse, Bellatrix, Rigel, and Saiph.    New: Instagram page features cool images recently submitted to APOD\",\"hdurl\":\"https://apod.nasa.gov/apod/image/1901/OrionAlps_Vesely_740.jpg\",\"media_type\":\"image\",\"service_version\":\"v1\",\"title\":\"Orion over the Austrian Alps\",\"url\":\"https://apod.nasa.gov/apod/image/1901/OrionAlps_Vesely_960.jpg\"}]\n"
        

        let data = Data(responseString.utf8)
        let expect = expectation(description: "decode completion")
        apiManager?.decodeDataResponse(data: data, managedObjectContext: coreDataStackTest.mainContext, completion: { result in
            expect.fulfill()
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                XCTAssertFalse(data.isEmpty)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        })
        waitForExpectations(timeout: 20, handler: nil)
    }
   
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
