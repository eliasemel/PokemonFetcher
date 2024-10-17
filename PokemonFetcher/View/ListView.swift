import SwiftUI

struct ListView: View {
    @StateObject private var viewModel = ListViewModel(service: DefaultPokemonService())
    
    var body: some View {
        switch viewModel.state {
        case .loaded(let page):
            NavigationView {
                List(page.results) { pokemon in
                    NavigationLink(destination: DetailView(model: .init(pokemon: pokemon, service: DefaultPokemonService()))) {
                        HStack {
                            Text(pokemon.name)
                                .font(.headline)
                        }
                    }
                    .onAppear {
                        let lastPokemon = page.results.last
                        if lastPokemon == pokemon {
                            Task {
                                await viewModel.nextPage()
                            }
                        }
                    }
                }
                .navigationTitle("Pokémon List")
            }
        default:
            EmptyView()
        }
    }
}

#Preview {
    ListView()
}

