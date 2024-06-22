// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

enum MaritalStatus {
  Single, 
  Married, 
  Divorced,
  MultipleMarried,
  PartnerDead
}

enum Party {
  AAP,
  BJP, 
  Congress
}

enum Time {
  Days,
  Weeks,
  Hours,
  Minutes,
  Seconds
}

enum Sex {
  Male, 
  Female,
  NonBinary,
  ChowmeinWithChilliPotato
}

enum Voter {
  IndividualVoter, 
  ProviderVoter
}
