use dojo_starter::models::{Direction, Position, Grid};

// define the interface
#[starknet::interface]
trait IActions<T> {
    fn spawn(ref self: T);
    fn move(ref self: T, direction: Direction);
}

// dojo decorator
#[dojo::contract]
pub mod actions {
    use super::{IActions, Direction, Position, next_position};
    use starknet::{ContractAddress, get_caller_address, get_block_number};
    use dojo_starter::models::{Vec2, Moves, DirectionsAvailable, TreasurePosition, Grid};

    use dojo::model::{ModelStorage, ModelValueStorage};
    use dojo::event::EventStorage;

    #[derive(Copy, Drop, Serde)]
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

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct Warning__FastWin {
        #[key]
        pub player: ContractAddress,
        pub timestamp: u64,
        pub block_number: u64,
    }

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn spawn(ref self: ContractState) {
            // Get the default world.
            let mut world = self.world_default();

            // Get the address of the current caller, possibly the player's address.
            let player = get_caller_address();
            // Retrieve the player's current position from the world.
            let position: Position = world.read_model(player);

            let new_position_vector = Vec2 { x: position.vec.x + 10, y: position.vec.y + 10 };
            let new_treasure_position_vector = Vec2 { x: 11, y: 11 };

            let new_position = Position { player, vec: new_position_vector };
            let new_treasure_position = TreasurePosition {
                player, vec: new_treasure_position_vector
            };

            let grid_width: u32 = 15;
            let grid_height: u32 = 15;

            let grid = Grid {
                player,
                width: grid_width,
                height: grid_height,
                treasure_position: new_treasure_position_vector,
                player_initial_position: new_position_vector,
                starting_block: starknet::get_block_number(),
            };

            // Write the new position to the world.
            world.write_model(@new_position);
            world.write_model(@new_treasure_position);
            world.write_model(@grid);

            // 2. Set the player's remaining moves to 100.
            let moves = Moves {
                player, remaining: 100, last_direction: Direction::None(()), can_move: true
            };

            // Write the new moves to the world.
            world.write_model(@moves);

            world
                .emit_event(
                    @PlayerSpawned {
                        player, timestamp: starknet::get_block_timestamp(), grid: grid
                    }
                );
        }

        // Implementation of the move function for the ContractState struct.
        fn move(ref self: ContractState, direction: Direction) {
            // Get the address of the current caller, possibly the player's address.

            let mut world = self.world_default();

            let player = get_caller_address();

            // Retrieve the player's current position and moves data from the world.
            let position: Position = world.read_model(player);
            let treasure_position: TreasurePosition = world.read_model(player);
            let mut moves: Moves = world.read_model(player);

            // Deduct one from the player's remaining moves.
            moves.remaining -= 1;

            // Update the last direction the player moved in.
            moves.last_direction = direction;

            // Calculate the player's next position based on the provided direction.
            let next = next_position(position, direction);

            // Write the new position to the world.
            world.write_model(@next);

            // Write the new moves to the world.
            world.write_model(@moves);

            // Emit an event to the world to notify about the player's move.
            world.emit_event(@Moved { player, direction });

            let grid: Grid = world.read_model(player);

            if (next.vec.x == treasure_position.vec.x && next.vec.y == treasure_position.vec.y) {
                let current_block = starknet::get_block_number();

                if (current_block - grid.starting_block < 10_u64) {
                    world
                        .emit_event(
                            @Warning__FastWin {
                                player,
                                timestamp: starknet::get_block_timestamp(),
                                block_number: current_block,
                            }
                        );
                }

                world
                    .emit_event(
                        @TreasureFound {
                            player,
                            treasure_position: treasure_position.vec,
                            timestamp: starknet::get_block_timestamp()
                        }
                    );
            }
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        /// Use the default namespace "dojo_starter". This function is handy since the ByteArray
        /// can't be const.
        fn world_default(self: @ContractState) -> dojo::world::WorldStorage {
            self.world(@"dojo_starter")
        }
    }
}

// Define function like this:
fn next_position(mut position: Position, direction: Direction) -> Position {
    match direction {
        Direction::None => { return position; },
        Direction::Left => { position.vec.x -= 1; },
        Direction::Right => { position.vec.x += 1; },
        Direction::Up => { position.vec.y -= 1; },
        Direction::Down => { position.vec.y += 1; },
    };
    position
}
