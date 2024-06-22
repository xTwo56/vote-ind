// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./enums.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract EVMv2 is Initializable {

  address owner ;
  address admin ;

  uint votingStartTime ;
  uint votingEndTime ;
  bool electionStatus ;

  //depricated
  struct Profile {
    string name ;
    uint8 age ;
    Sex sex ;
    MaritalStatus status;
  }
  //depricated
  struct Voter {
    Profile person;
    address voterAddress;
    bool voted ;
    string aadharId ;
  }

  struct VotingProviders {
    string name;
    uint number;
    bool isVerified;
  }

  mapping (address => Voter) individualVoters; //depricated
  mapping (address => Voter[]) votingProvidersMap; //depricated
  mapping (address => VotingProviders) votingProviders;
  mapping (string => Party) voterToParty;
  mapping (Party => uint) totalVotes;
  mapping (string => bool) aadharPresent;

  struct Voter2 {
    address voterAddress;
    string aadharId ;
    bool voted ;
  }
  
  mapping (address => Voter2) individualVoters2; 
  mapping (address => Voter2[]) votingProvidersMap2;

  modifier onlyOwner(){
    require(msg.sender == owner, "onlyOwnerCallable");
    _;
  }

  modifier onlyAdmin(){
    require(msg.sender == admin || msg.sender == owner, "onlyAdminCallable");
    _;
  }

  function initialize() public initializer {
    admin = owner = msg.sender;
    electionStatus = false;
    totalVotes[Party.AAP] = 0;
    totalVotes[Party.BJP] = 0;
    totalVotes[Party.Congress] = 0;
  } 

  function setAdmin(address _admin) external {
    admin = _admin;
  }
  
  function startVoting(Time unit, uint magnitude) external onlyAdmin {
    require(electionStatus == false, "Election already active");

    votingStartTime = block.timestamp;
    if(unit == Time.Days) votingEndTime = block.timestamp + magnitude*1 days;
    else if(unit == Time.Weeks) votingEndTime = block.timestamp + magnitude*1 weeks;
    else if(unit == Time.Hours) votingEndTime = block.timestamp + magnitude*1 hours;
    else if(unit == Time.Minutes) votingEndTime = block.timestamp + magnitude*1 minutes;
    else if(unit == Time.Seconds) votingEndTime = block.timestamp + magnitude*1 seconds;
    
    electionStatus = true;
  }

  function endVoting() external onlyAdmin {
    electionStatus = false;
  }

  function isVerified(Voter2 memory voter) public pure returns(bool){
    return bytes(voter.aadharId).length!=0;
  }

  function vote(Voter2 memory voter, Party _party) public {
       voterToParty[voter.aadharId];
       totalVotes[_party]++;
  }

  function voteByIndividual(Party _party) public {
    Voter2 memory voter = individualVoters2[msg.sender];
    require(isVerified(voter), "voter not verified");
    require(voterToParty[voter.aadharId] == Party(0), "already voted");

    vote(voter, _party);
  }
  function voteByProviders(uint voterId, Party _party)external {
    Voter2 memory voter = votingProvidersMap2[msg.sender][voterId];
    require(isVerified(voter), "voter not verified");
    require(voterToParty[voter.aadharId] == Party(0), "already voted");

    vote(voter, _party);
    voter.voted = true;
  }

  function addVoter(string memory _aadharId) public {
   require(individualVoters2[msg.sender].voterAddress != address(0));

   Voter2 memory voter = Voter2(msg.sender, _aadharId, false);
   if(votingProviders[msg.sender].isVerified){
     votingProvidersMap2[msg.sender].push(voter);
   }else{
     individualVoters2[msg.sender] = voter;
   }
  }

  function checkVote(string memory _aadharId) public view onlyAdmin returns(Party){
    require(aadharPresent[_aadharId]);
    return voterToParty[_aadharId];
  }
  
  function getTotalVotes()public view returns(uint){
    return totalVotes[Party.AAP]+totalVotes[Party.BJP]+totalVotes[Party.Congress];
  }

}
