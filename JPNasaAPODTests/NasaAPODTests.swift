//
//  JPNasaAPODTests.swift
//  JPNasaAPODTests
//
//  Created by kumaresh shrivastava on 19/01/2022.
//

import XCTest
@testable import JPNasaAPOD

class NasaAPODTests: XCTestCase,PayLoadFormat {

    
    var apiInteractorProtocol:APODResourceAPIInteractorProtocol?
    var apiModuleProtocol:APIModuleProtocol?
    var apodRequestProtocol:APODRequestProtocol?
    var apiManager: ApiManagerProtocol?
    var homeScreenModelProtocol: HomeViewModelProtocol?
    
    /**
     Mock Api and Core data objects
     */
    var coreDataStackTest = CoreDatatStackTest()
    var mockApiManager = MockApiManager()
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        apiModuleProtocol = APIModule()
        apodRequestProtocol = APODRequest()
        apiManager =  ApiManager()
        homeScreenModelProtocol = HomeViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        apiInteractorProtocol = nil
        apiModuleProtocol = nil
        apodRequestProtocol = nil
        homeScreenModelProtocol = nil
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
     Test check MOCK  API check  APODResouseApi interactor class to get apod data response end to end
     */
    func test_mock_apod_api_dataresponse_success() -> Void {
        
        apodRequestProtocol?.startDate = "2020-07-10"
        apodRequestProtocol?.endDate = "2020-07-10"
        apiModuleProtocol?.payloadType = .requestMethodGET
        apiModuleProtocol?.dateToSearch = apodRequestProtocol?.startDate ?? ""
        let expect = expectation(description: "API response completion")
        let payload = formatGetPayload(url: .AODURL, module: apiModuleProtocol!)
        mockApiManager.getAODInfo(payload: payload, managedObjectContext: coreDataStackTest.mainContext) { result in
            expect.fulfill()
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                XCTAssertFalse(data.isEmpty)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
        waitForExpectations(timeout: 40, handler: nil)
    }
    
    
    /**
     Test  MOCK  APOD API  error
     */
    func test_mock_apod_api_dataresponse_failure() -> Void {
        
        mockApiManager.shouldReturnError = true
        apodRequestProtocol?.startDate = "2020-07-10"
        apodRequestProtocol?.endDate = "2020-07-10"
        apiModuleProtocol?.payloadType = .requestMethodGET
        apiModuleProtocol?.dateToSearch = apodRequestProtocol?.startDate ?? ""
        let expect = expectation(description: "API response completion")
        let payload = formatGetPayload(url: .AODURL, module: apiModuleProtocol!)
        mockApiManager.getAODInfo(payload: payload, managedObjectContext: coreDataStackTest.mainContext) { result in
            expect.fulfill()
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                XCTAssertFalse(data.isEmpty)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
        waitForExpectations(timeout: 40, handler: nil)
    }
    
    /**
     Test Live API check APODResouseApi interactor class to get apod data response end to end
     */
    func test_live_apod__dataresponse_success() -> Void {
        
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
     Test Live API  Error check APODResouseApi interactor class to get apod data response end to end
     */
    func test_live_apod_dataresponse_error() -> Void {
        
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
    
    /**
     Mock Test to check for save fetch operation on the coredata
     */
    
    func test_save_fetch_to_coreData() -> Void {
        
        decode_response_to_coredata_codable_managed_datamodel()
        /// Perform save to core data and fetch to check
        CoreDataStack.shared.saveToMainContext(managedObjectContext: (self.coreDataStackTest.mainContext))
        let aopdData = CoreDataStack.shared.fetchFromCoreData(name: APODEntity.self, managedObjectContext:(self.coreDataStackTest.mainContext))
        
        XCTAssertNotNil(aopdData)
        XCTAssertFalse(aopdData!.isEmpty)
        XCTAssertGreaterThan(aopdData!.count, 0)
        
    }
    
    /**
     Mock Test to check for save fetch and delete all object operation on the coredata
     */
    
    func test_save_clear_alldata_from_coreData() -> Void {
        
        decode_response_to_coredata_codable_managed_datamodel()
        /// Perform save to core data  then fetch to check
        CoreDataStack.shared.saveToMainContext(managedObjectContext: (self.coreDataStackTest.mainContext))
        let aopdData = CoreDataStack.shared.fetchFromCoreData(name: APODEntity.self, managedObjectContext:(self.coreDataStackTest.mainContext))
        //XCTAssertNotNil(aopdData)
        XCTAssertNotNil(aopdData)
        XCTAssertFalse(aopdData!.isEmpty)
        XCTAssertGreaterThan(aopdData!.count, 0)
        CoreDataStack.shared.clearStorage(name: APODEntity.self,managedObjectContext: (self.coreDataStackTest.mainContext))
        let aopdDataEmpty = CoreDataStack.shared.fetchFromCoreData(name: APODEntity.self, managedObjectContext:(self.coreDataStackTest.mainContext))
        XCTAssertNil(aopdDataEmpty)
    }
    
    /**
     Mock Test to check for save fetch and  mapping data from the core data model  to view model which is used by the view
     */
    func test_map_coredata_to_viewmodel_which_is_required_for_view() -> Void {

        decode_response_to_coredata_codable_managed_datamodel()
        /// Perform save to core data and fetch to check
        CoreDataStack.shared.saveToMainContext(managedObjectContext: (self.coreDataStackTest.mainContext))
        let aopdData = CoreDataStack.shared.fetchFromCoreData(name: APODEntity.self, managedObjectContext:(self.coreDataStackTest.mainContext))
        let result:[AODViewModelProtocol] = (homeScreenModelProtocol?.mapToViewModelProtocol(managedObject: aopdData))!
        XCTAssertNotNil(result)
        XCTAssertGreaterThan(result.count, 0)
        XCTAssertEqual( result[0].title, "Orion over the Austrian Alps")
        XCTAssertEqual( result[0].date, "2019-01-23")
        XCTAssertEqual( result[0].mediaSourceURL, "https://apod.nasa.gov/apod/image/1901/OrionAlps_Vesely_960.jpg")
        XCTAssertEqual( result[0].mediaType, "image")
        XCTAssertEqual( result[0].explanation, "Do you recognize this constellation? Through the icicles and past the mountains is Orion, one of the most identifiable star groupings on the sky and an icon familiar to humanity for over 30,000 years. Orion has looked pretty much the same during the past 50,000 years and should continue to look the same for many thousands of years into the future.  Orion is quite prominent in the sky this time of year, a recurring sign of (modern) winter in Earth\'s northern hemisphere and summer in the south. Pictured, Orion was captured recently above the Austrian Alps in a composite of seven images taken by the same camera in the same location during the same night. Below and slightly to the right of Orion\'s three-star belt is the Orion Nebula, while the four bright stars surrounding the belt are, clockwise from the upper left, Betelgeuse, Bellatrix, Rigel, and Saiph.    New: Instagram page features cool images recently submitted to APOD")
        
    }
    
    
    /**
       Function to have the decoded data in the core data model
     */
    func decode_response_to_coredata_codable_managed_datamodel() {
        let responseString = "[{\"copyright\":\"Luk\\ufffd Vesel\\ufffd\",\"date\":\"2019-01-23\",\"explanation\":\"Do you recognize this constellation? Through the icicles and past the mountains is Orion, one of the most identifiable star groupings on the sky and an icon familiar to humanity for over 30,000 years. Orion has looked pretty much the same during the past 50,000 years and should continue to look the same for many thousands of years into the future.  Orion is quite prominent in the sky this time of year, a recurring sign of (modern) winter in Earth\'s northern hemisphere and summer in the south. Pictured, Orion was captured recently above the Austrian Alps in a composite of seven images taken by the same camera in the same location during the same night. Below and slightly to the right of Orion\'s three-star belt is the Orion Nebula, while the four bright stars surrounding the belt are, clockwise from the upper left, Betelgeuse, Bellatrix, Rigel, and Saiph.    New: Instagram page features cool images recently submitted to APOD\",\"hdurl\":\"https://apod.nasa.gov/apod/image/1901/OrionAlps_Vesely_740.jpg\",\"media_type\":\"image\",\"service_version\":\"v1\",\"title\":\"Orion over the Austrian Alps\",\"url\":\"https://apod.nasa.gov/apod/image/1901/OrionAlps_Vesely_960.jpg\"}]\n"
        
        let data = Data(responseString.utf8)
        let expect = expectation(description: "decode completion")
        apiManager?.decodeDataResponse(data: data, managedObjectContext: coreDataStackTest.mainContext, completion: { result in
            expect.fulfill()
        })
        waitForExpectations(timeout: 20, handler: nil)
    }
   
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
