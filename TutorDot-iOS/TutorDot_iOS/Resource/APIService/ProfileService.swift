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
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.result.value else {return}
                let networkResult = self.judge(by: statusCode, value)
                completion(networkResult)
            case .failure : completion(.networkFail)
            }
        }
    }
    
    // Mark - 이미지 url 업로드 서버통신
    private func makeParameterImage(_ userName: String, _ role: String, _ intro:  String) -> Parameters{
        return ["userName": userName, "role": role,  "intro": intro]
    }
    
    func uploadImage(_ image: UIImage, _ imageName: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let headers: HTTPHeaders = ["Content-Type" : "multipart/form-data", "jwt" : UserDefaults.standard.object(forKey: "token") as? String ?? " "]

            Alamofire.upload(multipartFormData: { multipartFormData in
                let imageData = image.jpegData(compressionQuality: 1.0)!
                multipartFormData.append(imageData, withName: "profile", fileName: imageName, mimeType: "image/jpeg")
            }, usingThreshold: UInt64.init(), to: APIConstants.profileURL, method: .post, headers: headers, encodingCompletion: { (result) in switch result {
            case .success(let upload, _, _): upload.uploadProgress(closure: { (progress) in
                print(progress.fractionCompleted) })
            upload.responseData { response in
                guard let statusCode = response.response?.statusCode,
                let data = response.result.value else { return }
                let networkResult = self.judgeUpload(by: statusCode, data)
                completion(networkResult)
                }
                print("프로필 사진 등록 성공")
            case .failure(let error):
                print(error.localizedDescription)
                completion(.networkFail) }
            })

    }
    
    
    private func judgeUpload(by StatusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch StatusCode {
        case 200 :
            print("프로필 사진 등록 성공 200")
            return isUpdating(by: data)
        case 400 :
            return .pathErr
        case 500 :
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func isUpdating(by data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(ProfileData.self, from: data)
        else { return .pathErr }
        
        if decodedData.success {
            guard let profileData = decodedData.data else { return .requestErr(decodedData.message) }
            print("프로필 사진 등록 성공", profileData.profileUrl)
            return .success(profileData)
        } else {
            return .requestErr(decodedData.message)
        }
    }
    
    // Mark - Put : 프로필 수정 - 자기소개
    private func makeParameterIntro(_ intro: String) -> Parameters{
        return ["intro": intro]
    }
    
    func editProfile(intro: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        // 토큰 가져오기
        let header: HTTPHeaders = ["jwt": UserDefaults.standard.object(forKey: "token") as? String ?? " "]
        
        let dataRequest = Alamofire.request(APIConstants.profileintroURL, method: .put, parameters: makeParameterIntro(intro), headers: header)
        
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
    
    
    private func judge(by StatusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch StatusCode {
        case 200 :
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
    
    // MARK - POST: 비밀번호 변경
    private func makeParameter(_ email: String, _ newPassword: String) -> Parameters{
        return ["email": email, "newPassword": newPassword]
    }
    
    func changePassword(email: String, newPassword: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        // 토큰 가져오기
        let header: HTTPHeaders = ["Content-Type":"application/json"]
        let dataRequest = Alamofire.request(APIConstants.changePassword, method: .post, parameters: makeParameter(email, newPassword), encoding: JSONEncoding.default, headers: header)
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success :
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.result.value else {return}
                let networkResult = self.judge3(by: statusCode,value)
                completion(networkResult)
            case .failure : completion(.networkFail)
            }
        }
    }
    
    private func judge3(by StatusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch StatusCode {
        case 200 :
            print("judge 200")
            return isLookup3(by: data)
        case 204 :
            print("judge 204")
            return isLookup3(by: data)
        case 400 :
            return .pathErr
        case 500 :
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func isLookup3(by data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(PasswordData.self, from: data)
            else {return .pathErr}
        print(decodedData.status, "\n", decodedData.success, "\n", decodedData.message, "\n")
        
        if decodedData.success {
            return .success(decodedData.data)
        }
        else {
            return .requestErr(decodedData.message)}
    }
    
}

