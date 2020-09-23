pragma solidity >=0.4.22 <0.7.0;

import "./testERC721.sol";

contract Ballot {
    
    struct Voter {
        address adrss;
        bool voted;
        address delegate;
        uint vote;
    }
    
    mapping(address => Voter) public voters;    
    
    address public owner;
    string public proposal;
    uint256 public pro;
    uint256 public cons;
    uint256 public subscribingBegin;
    uint256 private ballotBegin;
    uint256 private ballotEnd;
    bool public ballotState;
    
    
    constructor() public {
        owner = msg.sender;
        pro = 0;
        cons = 0;
        subscribingBegin = now;
    } 
    
    function signInBallot(address adr) public {
        require(voters[adr].adrss != adr);
        voters[adr].adrss = adr;
        voters[adr].voted = false;
        voters[adr].delegate = adr;
    }
    
    function ballotCreation(string memory propose) public {
        require(owner == msg.sender);
        proposal = propose;
    }
    
    function vote(uint256 vot) public {
       require(voters[msg.sender].adrss == msg.sender);
       require(!voters[msg.sender].voted,"Déjà voté.");
        if (vot == 1) {
            pro++;
            voters[msg.sender].voted = true;
        } else if (vot == 0) {
            cons++;
            voters[msg.sender].voted = true;
        } else {
            require(true,"erreur.");
        }
    }
    
}
