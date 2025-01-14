use dojo::event::EventStorage;
use dojo::model::{ModelStorage, ModelValueStorage};
use dojo_starter::models::{Vec2, Grid, Direction};
use starknet::{ContractAddress, get_caller_address, get_block_number};

pub mod proof_of_speed {
    #[derive(Drop, Serde)]
    #[dojo::event]
    pub struct PlayerSpawned {
        #[key]
        pub player: ContractAddress,
        pub timestamp: u64,
        pub grid: Grid,
    }

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct Moved {
        #[key]
        pub player: ContractAddress,
        pub direction: Direction,
    }

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct TreasureFound {
        #[key]
        pub player: ContractAddress,
        pub treasure_position: Vec2,
        pub timestamp: u64,
    }

    fn start_game(world: WorldStorage, player: ContractAddress, grid: Grid) {
        let timestamp = get_block_number();
        let block_number = get_block_number();

        world.emit_event(@PlayerSpawned { player, timestamp, grid });
    }
}
