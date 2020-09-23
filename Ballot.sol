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
    address [] public voterAccounts;
    
    address public owner;
    
    string public proposal;
    uint256 public pro;
    uint256 public cons;
    bool public ballotState;

    
    uint256 public subscribingBegin;
    uint256 private ballotBegin;
    uint256 private ballotEnd;
    
    
    constructor() public {
        owner = msg.sender;
        pro = 0;
        cons = 0;
        subscribingBegin = now;
    }
    
    function setVoter(address adr) private {
        voterAccounts.push(adr);
    }
    
    function getVoters() view public returns(address[] memory) {
        return voterAccounts;
    }
    
    function getVoter(address adr) view public returns (address,bool,uint) {
        return (voters[adr].adrss,voters[adr].voted,voters[adr].vote);
    }
    
    function countVoters() view public returns (uint) {
        return voterAccounts.length;
    }
    
    function sendEther(address payable receiver) private {
        receiver.transfer(1 ether);
    }
    
    
    function signInToBallot(address adr) public {
        require(voters[adr].adrss != adr);
        voters[adr].adrss = adr;
        voters[adr].vote = 2;
        voters[adr].voted = false;
        voters[adr].delegate = adr;
        setVoter(adr);
    }
    
    function ballotCreation(string memory propose) public {
       require(owner == msg.sender);
       for (uint i=0 ; i>countVoters() ; i++) {
            sendEther(address(uint160(voterAccounts[i])));
        }
        proposal = propose;
        ballotState = true;
    }
    
    function ballotInProgress() public {
        require(msg.sender == owner);
        ballotState = false;
    }
    
    function vote(uint256 vot) public {
       require(voters[msg.sender].adrss == msg.sender,"");
       require(!voters[msg.sender].voted,"Vous avez déjà voté.");
       require(ballotState);
        if (vot == 1) {
            pro++;
            voters[msg.sender].vote = 1;
            voters[msg.sender].voted = true;
        } else if (vot == 0) {
            cons++;
            voters[msg.sender].vote = 0;
            voters[msg.sender].voted = true;
        } else {
            require(!((vot==1)||(vot==0)),"Erreur : Réponse inconnue.");
        }
    }
    
    function check() private pure returns (bool) {
        bool res;
        return res;
    }
    
}
