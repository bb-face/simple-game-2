/**
 * Interface representing a player's movement capabilities and state.
 */
interface Moves {
  /** Order of fields in the model */
  fieldOrder: string[];
  /** Player identifier */
  player: string;
  /** Number of moves remaining */
  remaining: number;
  /** Last direction moved */
  last_direction: Direction;
  /** Whether the player can currently move */
  can_move: boolean;
}

/**
 * Interface representing available movement directions for a player.
 */
interface DirectionsAvailable {
  /** Order of fields in the model */
  fieldOrder: string[];
  /** Player identifier */
  player: string;
  /** List of available directions */
  directions: Direction[];
}

interface PlayerSpawned {
  fieldOrder: string[];
  player: string;
  timestamp: number;
}

interface TreasureFound {
  fieldOrder: string[];
  player: string;
  timestamp: number;
  treasure_position: Vec2;
}

interface TreasurePosition {
  fieldOrder: string[];
  player: string;
  vec: Vec2;
  example: number;
}

/**
 * Interface representing a player's position in the game world.
 */
interface Position {
  /** Order of fields in the model */
  fieldOrder: string[];
  /** Player identifier */
  player: string;
  /** 2D vector representing position */
  vec: Vec2;
}

/**
 * Enum representing possible movement directions.
 */
enum Direction {
  None = "0",
  Left = "1",
  Right = "2",
  Up = "3",
  Down = "4",
}

/**
 * Interface representing a 2D vector.
 */
interface Vec2 {
  /** X coordinate */
  x: number;
  /** Y coordinate */
  y: number;
}

/**
 * Type representing the complete schema of game models.
 */
type Schema = {
  dojo_starter: {
    Moves: Moves;
    DirectionsAvailable: DirectionsAvailable;
    Position: Position;
    TreasureFound: TreasureFound;
    PlayerSpawned: PlayerSpawned;
    TreasurePosition: TreasurePosition;
  };
};

/**
 * Enum representing model identifiers in the format "namespace-modelName".
 */
enum Models {
  Moves = "dojo_starter-Moves",
  DirectionsAvailable = "dojo_starter-DirectionsAvailable",
  Position = "dojo_starter-Position",
  TreasureFound = "dojo_starter-TreasureFound",
  TreasurePosition = "dojo_starter-TreasurePosition",
  PlayerSpawned = "dojo_starter-PlayerSpawned",
}

const schema: Schema = {
  dojo_starter: {
    Moves: {
      fieldOrder: ["player", "remaining", "last_direction", "can_move"],
      player: "",
      remaining: 0,
      last_direction: Direction.None,
      can_move: false,
    },
    DirectionsAvailable: {
      fieldOrder: ["player", "directions"],
      player: "",
      directions: [],
    },
    Position: {
      fieldOrder: ["player", "vec"],
      player: "",
      vec: { x: 0, y: 0 },
    },
    TreasureFound: {
      fieldOrder: ["player", "timestamp", "treasure_position"],
      player: "",
      timestamp: 0,
      treasure_position: { x: 0, y: 0 },
    },
    TreasurePosition: {
      fieldOrder: ["player", "vec", "example"],
      player: "",
      vec: { x: 0, y: 0 },
      example: 1,
    },
    PlayerSpawned: {
      fieldOrder: ["player", "timestamp"],
      player: "",
      timestamp: 0,
    },
  },
};

export type {
  Schema,
  Moves,
  DirectionsAvailable,
  Position,
  PlayerSpawned,
  TreasureFound,
  TreasurePosition,
  Vec2,
};
export { Direction, schema, Models };
