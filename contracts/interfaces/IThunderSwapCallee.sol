pragma solidity >=0.5.0;

/*
 * ThunderSwapFinance
 * App:             https://thunderswap.finance
 * Medium:          https://medium.com/@thunder_swap
 * Twitter:         https://twitter.com/thunder_swap
 * Telegram:        https://t.me/thunder_swap
 * Announcements:   https://t.me/thunder_swap_news
 * GitHub:          https://github.com/thunder-swap-finance
 */

interface IThunderSwapCallee {
    function thunderSwapCall(address sender, uint amount0, uint amount1, bytes calldata data) external;
}
