// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Voting {
  mapping(string => uint256) public votes;
  mapping(address=> bool) private hasVoted;
  string[] public candidates; 

  bool electionOpen;
  address committee;

  modifier OnlyCommitee {
    committee = msg.sender;
    _;
  }

  constructor() {
    committee = msg.sender;
  }

  function addCandidate(string memory _candidateName) public {
    require(electionOpen = true, "election is over")
    candidates.push(_candidateName);
  }

  function castVote(string memory _candidate) public {
    require(electionOpen == true, "election is over")
    require(hasVoted[msg.sender] == false, "Can't vote twice bitch");
    votes[_candidate]++;
    hasVoted[msg.sender] = true;
  }

  function endElection() public {
    require(electionOpen = true, "election is over")
    electionOpen = False;
  }
}