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
}
