// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./enums.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract EVM is Initializable {

  address owner ;
  address admin ;

  uint votingStartTime ;
  uint votingEndTime ;
  bool electionStatus ;

  struct Voter {
    address voterAddress;
    string aadharId ;
    bool voted ;
  }
  
  struct VotingProviders {
    string name;
    uint number;
    bool isVerified;
  }

  mapping (string => bool) aadharPresent;
  mapping (address => Voter) individualVoters;
  mapping (address => Voter[]) votingProvidersMap;
  mapping (address => VotingProviders) votingProviders;
  mapping (string => Party) voterToParty;
  mapping (Party => uint) totalVotes;

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

  function isVerified(Voter memory voter) public pure returns(bool){
    return bytes(voter.aadharId).length!=0;
  }

  function vote(Voter memory voter, Party _party) public {
       voterToParty[voter.aadharId];
       totalVotes[_party]++;
  }

  function voteByIndividual(Party _party) public {
    Voter memory voter = individualVoters[msg.sender];
    require(isVerified(voter), "voter not verified");
    require(voterToParty[voter.aadharId] == Party(0), "already voted");

    vote(voter, _party);
  }

  function voteByProviders(uint voterId, Party _party)external {
    Voter memory voter = votingProvidersMap[msg.sender][voterId];
    require(isVerified(voter), "voter not verified");
    require(voterToParty[voter.aadharId] == Party(0), "already voted");

    vote(voter, _party);
    voter.voted = true;
  }

  function addVoter(string memory _aadharId) public {
   require(!individualVoters[msg.sender]);

   Voter voter = Voter(msg.sender, _aadharId, false)
   if(votingProviders[msg.sender]){
     votingProvidersMap[msg.sender].push(voter);
   }else{
     individualVoters[msg.sender] = voter;
   }
  }

  function findVoter(string memory _aadharId, )public {
    return aadharPresent[_aadharId];
  }

  function checkVote(string memory _aadharId) public onlyAdmin{
    require(findVoter[_aadharId]);
    return voterToParty[_aadharId];
  }
}
