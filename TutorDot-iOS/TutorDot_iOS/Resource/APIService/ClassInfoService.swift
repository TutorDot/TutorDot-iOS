//
//  ClassInfoService.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 2020/07/13.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import Foundation
import Alamofire
import Kingfisher
import os

// 수업 정보 가져오는 서비스 파일
struct ClassInfoService {
    // Singleton
    static let classInfoServiceShared = ClassInfoService()
    
    // MARK - GET: 캘린더 탭 했을 때 전체 수업 정보 가져오기
    func getAllClassInfo(completion: @escaping (NetworkResult<Any>) -> Void) {
        // 토큰 가져오기
        let header: HTTPHeaders = ["jwt": UserDefaults.standard.object(forKey: "token") as? String ?? " "]
        
//        let header: HTTPHeaders = ["jwt": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEwMywibmFtZSI6IuulmOyEuO2ZlCIsImlhdCI6MTYwNTM1MDk2NywiZXhwIjoxNjA2NTYwNTY3LCJpc3MiOiJvdXItc29wdCJ9.8UDWwpaXIW07eUiDz6C24D5yHLNdw84NllwEcC4Zwe8"]
        
        let dataRequest = Alamofire.request(APIConstants.calendarURL, headers: header)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success :
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.result.value else {return}
                let networkResult = self.judge(by: statusCode,value)
                completion(networkResult)
            case .failure : completion(.networkFail)
            }
        }
    }
    
    // MARK - POST: 캘린더 플러스 버튼 눌렀을 때 일정 추가하기
    private func makeParameter(_ lectureId: Int, _ date: String, _ startTime: String, _ endTime: String, _ location: String ) -> Parameters{
        return ["lectureId": lectureId, "date": date, "startTime": startTime, "endTime": endTime, "location": location]
    }
    
    func addClassSchedule(lectureId:Int, date: String, startTime: String, endTime: String, location: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        // 토큰 가져오기
        let header: HTTPHeaders = ["jwt": UserDefaults.standard.object(forKey: "token") as? String ?? " "]
        
        let dataRequest = Alamofire.request(APIConstants.calendarClassURL, method: .post, parameters: makeParameter(lectureId, date, startTime, endTime, location), headers: header)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success :
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.result.value else {return}
                let networkResult = self.judge(by: statusCode,value)
                completion(networkResult)
            case .failure : completion(.networkFail)
            }
        }
    }
    
    // MARK - PUT : 수업일정 상세뷰에서 일정 하나 수정하기
    private func makeParameter2(_ classId: Int, _ date: String, _ startTime: String, _ endTime: String, _ location: String ) -> Parameters{
        return ["classId": classId, "date": date, "startTime": startTime, "endTime": endTime, "location": location]
    }
    
    func editClassSchedule(classId:Int, date: String, startTime: String, endTime: String, location: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        // 토큰 가져오기
        let header: HTTPHeaders = ["jwt": UserDefaults.standard.object(forKey: "token") as? String ?? " "]
        
        let dataRequest = Alamofire.request(APIConstants.calendarClassURL + "/" + "\(classId)", method: .put, parameters: makeParameter2(classId, date, startTime, endTime, location), headers: header)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success :
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.result.value else {return}
                let networkResult = self.judge(by: statusCode,value)
                completion(networkResult)
            case .failure : completion(.networkFail)
            }
        }
    }
    
    // MARK - GET: 특정 수업 일정 조회
    func getOneClassInfo(completion: @escaping (NetworkResult<Any>) -> Void) {
        let dataRequest = Alamofire.request(APIConstants.calendarLidURL)
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success :
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.result.value else {return}
                let networkResult = self.judge(by: statusCode,value)
                completion(networkResult)
            case .failure : completion(.networkFail)
            }
        }
    }
    
    
    
    // MARK - DELETE: 특정 수업 일정 하나 삭제 by CID
    private func makeParameter3(_ classId: Int) -> Parameters{
        return ["classId": classId]
    }
    func deleteOneClassInfo(classId: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        let header: HTTPHeaders = ["jwt": UserDefaults.standard.object(forKey: "token") as? String ?? " "]
        let dataRequest = Alamofire.request(APIConstants.calendarClassURL + "/" + "\(classId)", method: .delete,parameters: makeParameter3(classId), headers: header)

        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success :
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.result.value else {return}
                let networkResult = self.judge(by: statusCode,value)
                completion(networkResult)
            case .failure : completion(.networkFail)
            }
        }
    }
    
    private func judge(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case 200:
            print("judge success")
            return isClassData(by: data)
        case 204:
            print("judge success2")
            return isClassData(by: data)
        case 400: return .pathErr
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
    private func isClassData(by data:Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(ClassData.self, from: data)
            else {return .pathErr}
        print(decodedData.status, "\n", decodedData.success, "\n", decodedData.message, "\n")
        
        if decodedData.success {
            //print(decodedData.data)
            return .success(decodedData.data)
        }
        else {
            return .requestErr(decodedData.message)}
    }
    
    // MARK - GET: 수업 초대코드 가져오기
//    private func parameterForInvite(_ classId: Int, _ date: String, _ startTime: String, _ endTime: String, _ location: String ) -> Parameters{
//        return ["classId": classId, "date": date, "startTime": startTime, "endTime": endTime, "location": location]
//    }
//    
//    func getClassInviteCoed(completion: @escaping (NetworkResult<Any>) -> Void) {
//        // 토큰 가져오기
//        let header: HTTPHeaders = ["jwt": UserDefaults.standard.object(forKey: "token") as? String ?? " "]
//
//        let dataRequest = Alamofire.request(APIConstants.invitationURL+ "/" + "\(classId)", method: .get, pa(classId), headers: header)
//      
//        
//        
//        dataRequest.responseData { dataResponse in
//            switch dataResponse.result {
//            case .success :
//                guard let statusCode = dataResponse.response?.statusCode else {return}
//                guard let value = dataResponse.result.value else {return}
//                let networkResult = self.judge(by: statusCode,value)
//                completion(networkResult)
//            case .failure : completion(.networkFail)
//            }
//        }
//    }
//
    
    // GET: 마이페이지 수업 목록 조회
    func setMypageClassList(completion: @escaping (NetworkResult<Any>) -> Void) {
        
        
        let header: HTTPHeaders = ["jwt": UserDefaults.standard.object(forKey: "token") as? String ?? " "]
    
        let dataRequest = Alamofire.request(APIConstants.lectureURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
        
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success :
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.result.value else {return}
                let networkResult = self.judgeClassList(by: statusCode,value)
                completion(networkResult)
            case .failure : completion(.networkFail)
            }
        }
    }
    
    private func judgeClassList(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
            case 200:
                os_log("judge classList success", log: .mypage)
                return isClassListData(by: data)
            case 400: return .pathErr
            case 500: return .serverErr
            default: return .networkFail
        }
    }
    
    private func isClassListData(by data:Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(LidData.self, from: data)
            else {return .pathErr}
        if decodedData.success {
            return .success(decodedData.data)
        }
        else {
            return .requestErr(decodedData.message)}
    }
    
    
   
}
