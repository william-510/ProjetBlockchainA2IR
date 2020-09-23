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
    
    function sendEther(address payable receiver) internal {
        receiver.transfer(0.00000001 ether);
    }
    
    function check() private pure returns (bool) {
        bool res;
        return res;
    }
    
    
    function signInToBallot(address adr) public {
        require(voters[adr].adrss != adr);
        require(ballotState,"Vous ne pouvez pas vous inscrire car le scrutin est terminé.");
        voters[adr].adrss = adr;
        voters[adr].vote = 2;
        voters[adr].voted = false;
        voters[adr].delegate = adr;
        setVoter(adr);
        sendEther(address(uint160(adr)));
    }
    
    function ballotCreation(string memory propose) public payable {
       require(owner == msg.sender,"Seul le propriétaire peut créer le scrutin.");
       require(msg.value >= 1 ether,"Cette fonction nécessite une value au moins = à 1 ether.");
       for (uint i=0 ; i>countVoters() ; i++) {
            sendEther(address(uint160(voterAccounts[i])));
        }
        proposal = propose;
        ballotState = true;
    }
    
    function ballotInProgress() public {
        require(msg.sender == owner,"Seul le propriétaire peut changer l'état");
        ballotState = false;
    }
    
    function vote(uint256 vot) public payable {
       require(voters[msg.sender].adrss == msg.sender,"Vous n'êtes pas inscrit au scrutin.");
       require(!voters[msg.sender].voted,"Vous avez déjà voté.");
       require(ballotState,"Le scrutin est terminé.");
       require(msg.value > 0,"Vous devez saisir une value supérieur à 0 pour voter.");
        if (vot == 1) {
            pro++;
            voters[msg.sender].vote = 1;
            voters[msg.sender].voted = true;
            sendEther(address(uint160(owner)));
        } else if (vot == 0) {
            cons++;
            voters[msg.sender].vote = 0;
            voters[msg.sender].voted = true;
            sendEther(address(uint160(owner)));
        } else {
            require(!((vot==1)||(vot==0)),"Erreur : Réponse inconnue.");
        }
    }
    
}
