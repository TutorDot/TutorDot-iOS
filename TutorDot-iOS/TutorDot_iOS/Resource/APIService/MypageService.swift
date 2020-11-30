//
//  MypageService.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/29.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import Foundation
import Alamofire
import os

struct MypageService {
    
    // singleton
    static let MypageServiceShared = MypageService()
    
    // MARK - DELETE: 마이페이지 - 수업연결해제, 수업방나가기
    private func makeParameter(_ classId: Int) -> Parameters{
        return ["classId": classId]
    }
    
    func deleteClassConnection(classId: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        
        let header: HTTPHeaders = ["jwt": UserDefaults.standard.object(forKey: "token") as? String ?? " "]
        
        let dataRequest = Alamofire.request(APIConstants.lectureURL + "/" + "\(classId)", method: .delete, parameters: makeParameter(classId), headers: header)

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
        case 200: return isClassInfo(by: data)
        case 204: return isClassInfo(by: data)
        case 400: return .pathErr
        case 401: return .pathErr
        case 500: return .serverErr
        default: return .networkFail
            
        }
    }
    
    private func isClassInfo(by data:Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(SignUpData.self, from: data) else { return .pathErr }
        
        if decodedData.success {
            return .success(data)
        }
        else {
            return .requestErr(decodedData.message)}
    }
    
    // MARK - DELETE: 마이페이지 - 서비스 탈퇴
    func deleteUser(completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header: HTTPHeaders = ["jwt": UserDefaults.standard.object(forKey: "token") as? String ?? " "]
        
        let dataRequest = Alamofire.request(APIConstants.profileURL, method: .delete, headers: header)

        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success :
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.result.value else {return}
                let networkResult = self.deleteUserJudge(by: statusCode,value)
                completion(networkResult)
            case .failure : completion(.networkFail)
            }
        }
    }
    
    private func deleteUserJudge(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case 200: return isUserInfo(by: data)
        case 204: return isUserInfo(by: data)
        case 400: return .pathErr
        case 401: return .pathErr
        case 500: return .serverErr
        default: return .networkFail
            
        }
    }
    
    private func isUserInfo(by data:Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(SignUpData.self, from: data) else { return .pathErr }
        if decodedData.success {
            return .success(data)
        }
        else {
            return .requestErr(decodedData.message)}
    }
    
    
    // Mark - GET : 마이페이지 수업 초대코드 받아오기
    func getInvitaionCode(classId: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header: HTTPHeaders = ["jwt": UserDefaults.standard.object(forKey: "token") as? String ?? " "]
    
        let dataRequest = Alamofire.request(APIConstants.invitationURL + "/" + "\(classId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success :
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.result.value else {return}
                let networkResult = self.invitationJudge(by: statusCode, value)
                completion(networkResult)
            case .failure : completion(.networkFail)
            }
        }
    }
    
    private func invitationJudge(by StatusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch StatusCode {
        case 200 :
            return isInvitationCode(by: data)
        case 400 :
            return .pathErr
        case 500 :
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func isInvitationCode(by data: Data) -> NetworkResult<Any> {

        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(InvitationData.self, from: data)
            else { return .pathErr }

        if decodedData.success {
            return .success(decodedData.data as Any)
        } else {
            return .requestErr(decodedData.message)
        }
    }
    
    // Mark - POST : 마이페이지 초대코드로 수업 연결하기
    private func makeParameterCode(_ code: String) -> Parameters{
        return ["code": code]
    }
    
    func connectInvitaionCode(code: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header: HTTPHeaders = ["jwt": UserDefaults.standard.object(forKey: "token") as? String ?? " "]
    
        let dataRequest = Alamofire.request(APIConstants.invitationURL, method: .post, parameters: makeParameterCode(code), encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success :
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.result.value else {return}
                let networkResult = self.connectCodeJudge(by: statusCode, value)
                completion(networkResult)
            case .failure : completion(.networkFail)
            }
        }
    }
    
    private func connectCodeJudge(by StatusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch StatusCode {
        case 200, 204 :
            return isConnectCode(by: data)
        case 400, 401 :
            return isConnectCode(by: data)
        case 500 :
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func isConnectCode(by data: Data) -> NetworkResult<Any> {

        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(SignUpData.self, from: data) else { return .pathErr }

        if decodedData.success { return .success(data)
        } else { return .requestErr(decodedData.message)
        }
    }
    
}
