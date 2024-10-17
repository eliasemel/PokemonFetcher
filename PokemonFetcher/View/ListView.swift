import SwiftUI

struct ListView: View {
    @StateObject private var viewModel = ListViewModel(service: DefaultPokemonService())
    @State private var navigationPath = NavigationPath()

    var body: some View {
        switch viewModel.state {
        case .loaded(let page):
            NavigationStack(path: $navigationPath) {
                List(page.results) { pokemon in
                    NavigationLink(value: pokemon) {
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
                .navigationDestination(for: PokemonListItem.self) { pokemon in
                    DetailView(model: .init(pokemon: pokemon, service: DefaultPokemonService()))
                }
            }
        default:
            EmptyView()
        }
    }
}

#Preview {
    ListView()
}
