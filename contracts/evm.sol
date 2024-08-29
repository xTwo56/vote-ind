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

  struct Profile {
    string name ;
    uint8 age ;
    Sex sex ;
    MaritalStatus status;
  }

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
  
  function addVoter(Profile memory _profile, address voterAddress, bool _voted, string memory _aadharId)public returns(uint){
    Voter memory voter = Voter(_profile, voterAddress, _voted, _aadharId);
    if(!votingProviders[msg.sender].isVerified){
      individualVoters[msg.sender] = voter;
      return 0;
    }else{
      votingProvidersMap[msg.sender].push(voter);
      return votingProvidersMap[msg.sender].length -1;
    }
  }
  
  function getTotalVotes()public view returns(uint){
    return totalVotes[Party.AAP]+totalVotes[Party.BJP]+totalVotes[Party.Congress];
  }

  function checkVersion()public pure returns(uint){
    return 1;
  }
}


