pub mod proof_of_speed {
    use starknet::{ContractAddress, get_block_number};
    use dojo::event::EventStorage;
    use dojo::world::WorldStorage;

    #[derive(Drop, Serde)]
    #[dojo::event]
    pub struct StartGame {
        #[key]
        pub player: ContractAddress,
        pub game_id: felt252,
        pub timestamp: u64,
        pub block_number: u64,
    }

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct GameAction {
        #[key]
        pub player: ContractAddress,
        pub game_id: felt252,
        pub action_type: felt252,
        pub timestamp: u64,
        pub block_number: u64,
    }

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct WinGame {
        #[key]
        pub player: ContractAddress,
        pub game_id: felt252,
        pub timestamp: u64,
        pub block_number: u64,
    }

    fn start_game(ref world: WorldStorage, player: ContractAddress, game_id: felt252) {
        let timestamp = get_block_number();
        let block_number = get_block_number();

        world.emit_event(@StartGame { player, game_id, timestamp, block_number });
    }

    fn record_action(
        ref world: WorldStorage, player: ContractAddress, game_id: felt252, action_type: felt252
    ) {
        let timestamp = get_block_number();
        let block_number = get_block_number();

        world.emit_event(@GameAction { player, game_id, action_type, timestamp, block_number });
    }

    fn win_game(ref world: WorldStorage, player: ContractAddress, game_id: felt252) {
        let timestamp = get_block_number();
        let block_number = get_block_number();

        world.emit_event(@WinGame { player, game_id, timestamp, block_number });
    }
}
