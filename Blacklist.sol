pragma solidity ^0.5.13;

contract Blacklist {

    uint256 public totalBlacklisted;
    mapping(address => bool) internal blacklisted;

    event Blacklisted(address indexed _wallet);
    event UnBlacklisted(address indexed _wallet);

    modifier notBlacklisted(address _wallet) {
        require(!blacklisted[_wallet], "Wallet is blacklisted");
        _;
    }

    function isBlacklisted(address _wallet) external view returns (bool) {
        return blacklisted[_wallet];
    }

    function addBlacklist(address _wallet) external onlyOwner {
        require(!blacklisted[_wallet], "Wallet is already blacklisted");

        blacklisted[_wallet] = true;
        totalBlacklisted++;
        
        emit Blacklisted(_wallet);
    }

    function delBlacklist(address _wallet) external onlyOwner {
        require(blacklisted[_wallet], "Wallet is not blacklisted");

        blacklisted[_wallet] = false;
        totalBlacklisted--;
        
        emit UnBlacklisted(_wallet);
    }

}
