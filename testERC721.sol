pragma solidity >=0.4.22 <0.7.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract testERC721 is ERC721 {
    constructor() ERC721("tokenVote", "tV") public {}
    
    
    mapping (address => uint) public coin;
    uint [] test;
    
    function mint(address voter) public {
        coin[voter] += now;
        test.push(now);
      
    }
    
    function getTest(uint id) public view returns (uint) {
        return test[id];
    }
}
