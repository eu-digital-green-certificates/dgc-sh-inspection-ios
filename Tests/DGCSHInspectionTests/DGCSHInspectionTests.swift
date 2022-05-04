import XCTest
@testable import DGCSHInspection
import JOSESwift
// import JOSESwift


final class DGCSHInspectionTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        // XCTAssertEqual(DGCSHInspection().text, "Hello, World!")
        try? SHCert(payload: "", ruleCountryCode: nil)
    }
    
    /*
     Invalid signing: "eyJhbGciOiJFUzI1NiIsImtpZCI6IlRFU1QtRFgiLCJ0eXAiOiJKV1QifQ.eyJjbyI6IkRYIiwiaWF0IjoxNjUwODk4MjYxLjUxOTY5ODEsImlzcyI6Imh0dHBzOi8vZmlsZXMuZW1pbGluYS5kZS9kY2N0ZXN0ZGF0YS9qd3RkeC5qc29uIiwibmJmIjoxNjUwODk4MjYxLjUxOTY5ODEsInZjIjp7ImNyZWRlbnRpYWxTdWJqZWN0Ijp7InZhbHVlMSI6InNvbWV0aGluZyIsInZhbHVlMiI6eyJzdWIxIjoibW9yZSIsInN1YjIiOiJlbHNlIiwic3ViMyI6WyJUaWNrIiwiVHJpY2siLCJUcmFjayJdfX0sInR5cGUiOlsidGVzdGluZy5vbmx5Il19fQ.KBnccL_sNCG1cvJijMExEDYKuUlhnAv_X3a-MPGKwaFP_v4lmeFaoJE8O8cIvsvlWnV_DDFzmC_oRbnjLyHsMA"
     
     Valid signing:
     "eyJ6aXAiOiJERUYiLCJhbGciOiJFUzI1NiIsImtpZCI6IjNLZmRnLVh3UC03Z1h5eXd0VWZVQUR3QnVtRE9QS01ReC1pRUxMMTFXOXMifQ.3ZJNj9MwEIb_ymq4pokTSktzo0XiSyAQy15QD64zbYz8EfkjalnlvzN2u2JBu3viRG6TmXn8vq99C9J7aKEPYfBtVfkBRek1d6FHrkJfCu46X-GR60Ghr2g6ooMCzG4Pbb2YL9jL56xhZT2vCxgFtLcQTgNC-_0382_cs3MxSwWhHp-TWkcjf_IgrXlyUNhRdvUKtgUIhx2aILn6Gnc_UIQkad9Ld4POJ04L85L0Ei_9XUfTKUwzDr2NTuB1lg-XRnGxA8IqRbSzEjrAncgjkaNS35yigbv9ltHAXfEA-DPZof2UIdd4hnAtFfHglaEZ5_MZBzmiSTm-t32q1yVsJzK4k2T-NQ-JVa9e1DNWzxoG01Q8qKZ-Ws27PyP2gYfos9104QHTBY1cCGlwY7tMELaT5pCF-5MPqC_vh26mV8vSukOVkq287CoxHgkg8iY0bAnTdipguESQ5ezRoUna7idIQ1aI6HIrmb2W-oxosmGWbFFUe-s0vcekhYtgXUJ20g-K5zjXm6s3aNBxdfXW-kEGrigoClHZ8CnqXVoFlr_60QSb_zLBZvWvE1ymBoUITnb08-OH0-bYL4dF_EKNXw.qIxp8j32EzRItn7hHrIfFKX163qlyYMMQ30fkYjOwl0Cgy5ssR9Oypas-KK-3AUFygu7mDrQmBGMiw44wgUqug"
     */
    
    func testInvalidSigning() throws {
        let payload = """
eyJhbGciOiJFUzI1NiIsImtpZCI6IlRFU1QtRFgiLCJ0eXAiOiJKV1QifQ.eyJjbyI6IkRYIiwiaWF0IjoxNjUwODk4MjYxLjUxOTY5ODEsImlzcyI6Imh0dHBzOi8vZmlsZXMuZW1pbGluYS5kZS9kY2N0ZXN0ZGF0YS9qd3RkeC5qc29uIiwibmJmIjoxNjUwODk4MjYxLjUxOTY5ODEsInZjIjp7ImNyZWRlbnRpYWxTdWJqZWN0Ijp7InZhbHVlMSI6InNvbWV0aGluZyIsInZhbHVlMiI6eyJzdWIxIjoibW9yZSIsInN1YjIiOiJlbHNlIiwic3ViMyI6WyJUaWNrIiwiVHJpY2siLCJUcmFjayJdfX0sInR5cGUiOlsidGVzdGluZy5vbmx5Il19fQ.KBnccL_sNCG1cvJijMExEDYKuUlhnAv_X3a-MPGKwaFP_v4lmeFaoJE8O8cIvsvlWnV_DDFzmC_oRbnjLyHsMA
"""
        let cert = try SHCert(payload: payload, ruleCountryCode: nil)
    }
    
    func testValidSigning() throws {
        let payload = """
eyJ6aXAiOiJERUYiLCJhbGciOiJFUzI1NiIsImtpZCI6IjNLZmRnLVh3UC03Z1h5eXd0VWZVQUR3QnVtRE9QS01ReC1pRUxMMTFXOXMifQ.3ZJNj9MwEIb_ymq4pokTSktzo0XiSyAQy15QD64zbYz8EfkjalnlvzN2u2JBu3viRG6TmXn8vq99C9J7aKEPYfBtVfkBRek1d6FHrkJfCu46X-GR60Ghr2g6ooMCzG4Pbb2YL9jL56xhZT2vCxgFtLcQTgNC-_0382_cs3MxSwWhHp-TWkcjf_IgrXlyUNhRdvUKtgUIhx2aILn6Gnc_UIQkad9Ld4POJ04L85L0Ei_9XUfTKUwzDr2NTuB1lg-XRnGxA8IqRbSzEjrAncgjkaNS35yigbv9ltHAXfEA-DPZof2UIdd4hnAtFfHglaEZ5_MZBzmiSTm-t32q1yVsJzK4k2T-NQ-JVa9e1DNWzxoG01Q8qKZ-Ws27PyP2gYfos9104QHTBY1cCGlwY7tMELaT5pCF-5MPqC_vh26mV8vSukOVkq287CoxHgkg8iY0bAnTdipguESQ5ezRoUna7idIQ1aI6HIrmb2W-oxosmGWbFFUe-s0vcekhYtgXUJ20g-K5zjXm6s3aNBxdfXW-kEGrigoClHZ8CnqXVoFlr_60QSb_zLBZvWvE1ymBoUITnb08-OH0-bYL4dF_EKNXw.qIxp8j32EzRItn7hHrIfFKX163qlyYMMQ30fkYjOwl0Cgy5ssR9Oypas-KK-3AUFygu7mDrQmBGMiw44wgUqug
"""
        let cert = try SHCert(payload: payload, ruleCountryCode: nil)
    }
}
