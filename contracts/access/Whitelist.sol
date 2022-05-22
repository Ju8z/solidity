/**
 * SPDX-License-Identifier: MIT
 */

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract Whitelist is Ownable {

    mapping(address => bool) internal whitelist;

    event PauseWhiteList();
    event UnPauseWhiteList();
    event AddToWhitelist(address _wallet);

    bool private _isWhitelistPaused;

    /**
     * @dev Initializes the whitelist in unpaused state.
     */
    constructor() {
        _isWhitelistPaused = false;
    }

    /**
     * @dev Returns true if the whitelist is paused, and false otherwise.
     */
    function isWhitelistPaused() public view virtual returns (bool) {
        return _isWhitelistPaused;
    }

    /**
     * @dev Disables the whitelist.
     *
     * Requirements:
     *
     * - Must be contract owner.
     */
    function pauseWhitelist() external onlyOwner {
        _isWhitelistPaused = true;

        emit PauseWhiteList();
    }

    /**
     * @dev Enabled the whitelist.
     *
     * Requirements:
     *
     * - Must be contract owner.
     */
    function unPauseWhitelist() external onlyOwner {
        _isWhitelistPaused = false;

        emit UnPauseWhiteList();
    }

    modifier onlyWhitelisted(address _wallet) {
        if (!_isWhitelistPaused) {
            require(whitelist[_wallet], "Wallet is not whitelisted.");
        }
        _;
    }

    // this wallets can interact with the protocol before release.
    function addWhitelistList(address[] memory _addressList) internal virtual {
        for (uint256 i = 0; i < _addressList.length; i++) {
            whitelist[_addressList[i]] = true;
        }
    }

    function addToWhitelist(address _wallet) external onlyOwner {
        whitelist[_wallet] = true;

        emit AddToWhitelist(_wallet);
    }

    function isWhitelisted(address _wallet) external view returns (bool) {
        return whitelist[_wallet];
    }

}