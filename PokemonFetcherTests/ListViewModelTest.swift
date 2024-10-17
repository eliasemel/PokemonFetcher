//
//  ListViewModelTest.swift
//  PokemonFetcherTests
//
//  Created by Emel Elias on 2024-10-17.
//

import XCTest
@testable import PokemonFetcher
final class ListViewModelTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetch() async {
        let viewModel = await ListViewModel(service: MockPokemonService())
        switch await viewModel.state {
        case .loaded(let result):
            XCTAssertEqual(result.results.count, 0, "before loading it should be 0")
        default:
            XCTFail()
        }
        await viewModel.fetchPokemones()
        switch await viewModel.state {
        case .loaded(let result):
            XCTAssertEqual(result.results.count, MockData.pokeMonList().results.count, "before loading it should be 0")
        default:
            XCTFail()
        }
        
    }
    
    func testNextPage() async {
        let viewModel = await ListViewModel(service: MockPokemonService())
        await viewModel.fetchPokemones()
        await viewModel.nextPage()
        switch await viewModel.state {
        case .loaded(let result):
            XCTAssertEqual(result.results.count, MockData.pokeMonList().results.count*2, "The results should have twice the page content since its mocked ")
        default:
            XCTFail()
        }
        
    }

}
