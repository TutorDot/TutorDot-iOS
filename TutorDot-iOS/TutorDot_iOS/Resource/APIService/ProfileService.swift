//
//  ProfileService.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/07/14.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import Foundation
import Alamofire
import Kingfisher
import os

struct ProfileService {
    
    // singleton
    static let ProfileServiceShared = ProfileService()
    
    // Mark - GET: 마이페이지 간편 프로필 조회
    func setMyProfile(completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header: HTTPHeaders = ["jwt": UserDefaults.standard.object(forKey: "token") as? String ?? " "]
    
        let dataRequest = Alamofire.request(APIConstants.profileURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
        
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success :
                os_log("profile response success", log: .mypage)
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.result.value else {return}
                let networkResult = self.judge(by: statusCode, value)
                completion(networkResult)
            case .failure : completion(.networkFail)
            }
        }
    }
    
    private func judge(by StatusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch StatusCode {
        case 200 :
            os_log("profile judge success", log: .mypage)
            return isLookup(by: data)
        case 400 :
            return .pathErr
        case 500 :
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func isLookup(by data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(ProfileData.self, from: data)
            else { return .pathErr }
        
        if decodedData.success {
            os_log("profile decoding success", log: .mypage)
            return .success(decodedData.data as Any)
        } else {
            return .requestErr(decodedData.message)
        }
    }
    
    // GET: 수업 목록 조회
    func getClassLid(completion: @escaping (NetworkResult<Any>) -> Void) {
        // 토큰 가져오기
        let header: HTTPHeaders = ["jwt": UserDefaults.standard.object(forKey: "token") as? String ?? " "]
     
        let dataRequest = Alamofire.request(APIConstants.lectureURL, headers: header)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success :
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.result.value else {return}
                let networkResult = self.judge2(by: statusCode,value)
                completion(networkResult)
            case .failure : completion(.networkFail)
            }
        }
    }
    
    
    private func judge2(by StatusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch StatusCode {
        case 200 :
            print("judge 200")
            return isLookup2(by: data)
        case 400 :
            return .pathErr
        case 500 :
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func isLookup2(by data: Data) -> NetworkResult<Any> {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(LidData.self, from: data)
            //print(decodedData)
            return .success(decodedData.data)
        }
        catch {
            print(error)
            return .pathErr
        }
    }
}

