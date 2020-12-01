//
//  NoteService.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/12/01.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import Foundation
import Alamofire
import os

struct NoteService {
    // singleton
    static let Shared = NoteService()
    
    // Mark - GET : 수업 일지 전체 조회
    func getAllClassNotes(completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header: HTTPHeaders = ["jwt": UserDefaults.standard.object(forKey: "token") as? String ?? " "]
    
        let dataRequest = Alamofire.request(APIConstants.diaryURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success :
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.result.value else {return}
                let networkResult = self.allNotesJudge(by: statusCode, value)
                completion(networkResult)
            case .failure : completion(.networkFail)
            }
        }
    }
    
    private func allNotesJudge(by StatusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch StatusCode {
        case 200 :
            return areClassNotes(by: data)
        case 400, 401 :
            return .pathErr
        case 500 :
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func areClassNotes(by data: Data) -> NetworkResult<Any> {

        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(NotesData.self, from: data)
            else { return .pathErr }

        if decodedData.success {
            return .success(decodedData.data as Any)
        } else {
            return .requestErr(decodedData.message)
        }
    }
    
    // Mark - GET : 특정 수업 일지만 조회
    func getOneClassNotes(diaryId: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header: HTTPHeaders = ["jwt": UserDefaults.standard.object(forKey: "token") as? String ?? " "]
    
        let dataRequest = Alamofire.request(APIConstants.diaryURL + "/" + "\(diaryId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success :
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.result.value else {return}
                let networkResult = self.NotesJudge(by: statusCode, value)
                completion(networkResult)
            case .failure : completion(.networkFail)
            }
        }
    }
    
    private func NotesJudge(by StatusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch StatusCode {
        case 200 :
            return isClassNotes(by: data)
        case 400, 401 :
            return .pathErr
        case 500 :
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func isClassNotes(by data: Data) -> NetworkResult<Any> {

        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(NotesData.self, from: data)
            else { return .pathErr }

        if decodedData.success {
            return .success(decodedData.data as Any)
        } else {
            return .requestErr(decodedData.message)
        }
    }
    
    // Mark - PUT : 특정 수업일지 수정하기
    private func makeParameter(_ classProgress: String, _ homework: String, _ hwPerformance: Int) -> Parameters{
        return ["classProgress": classProgress, "homework": homework, "hwPerformance": hwPerformance]
    }
    
    func editClassNote(classProgress: String, homework: String, hwPerformance: Int, diaryId: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        // 토큰 가져오기
        let header: HTTPHeaders = ["jwt": UserDefaults.standard.object(forKey: "token") as? String ?? " "]
        
        let dataRequest = Alamofire.request(APIConstants.diaryHwDidURL + "/" + "\(diaryId)", method: .put, parameters: makeParameter(classProgress, homework, hwPerformance), headers: header)
        
        
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
        case 200, 204:
            return isNoteData(by: data)
        case 400, 401: return .pathErr
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
    private func isNoteData(by data:Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(NotesData.self, from: data)
            else {return .pathErr}
        
        if decodedData.success { return .success(decodedData.data) }
        else {
            return .requestErr(decodedData.message)}
    }
    
    
    // Mark - Get : 수업 리스트 조회하기 (토글)
    func getClassList(completion: @escaping (NetworkResult<Any>) -> Void) {
        
        
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
                return isClassListData(by: data)
            case 400: return .pathErr
            case 500: return .serverErr
            default: return .networkFail
        }
    }
    
    private func isClassListData(by data:Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(classListData.self, from: data)
            else {return .pathErr}

        if decodedData.success {
            return .success(decodedData.data)
        }
        else {
            return .requestErr(decodedData.message)
        }
    }
    
}
