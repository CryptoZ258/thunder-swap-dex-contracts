pragma solidity =0.5.16;

/*
 * ThunderSwapFinance
 * App:             https://thunderswap.finance
 * Medium:          https://medium.com/@thunder_swap
 * Twitter:         https://twitter.com/thunder_swap
 * Telegram:        https://t.me/thunder_swap
 * Announcements:   https://t.me/thunder_swap_news
 * GitHub:          https://github.com/thunder-swap-finance
 */

import './interfaces/IThunderSwapFactory.sol';
import './ThunderSwapPair.sol';

contract ThunderSwapFactory is IThunderSwapFactory {

    bytes32 public constant INIT_CODE_PAIR_HASH = keccak256(abi.encodePacked(type(ThunderSwapPair).creationCode));

    address public feeTo;
    address public feeToSetter;

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, 'ThunderSwap: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'ThunderSwap: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'ThunderSwap: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = type(ThunderSwapPair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IThunderSwapPair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, 'ThunderSwap: FORBIDDEN');
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'ThunderSwap: FORBIDDEN');
        feeToSetter = _feeToSetter;
    }
}
