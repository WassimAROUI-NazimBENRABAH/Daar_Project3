pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";

contract BuildCollective is Ownable {
  struct User {
    string username;
    uint256 balance;
    bool registered;
  }
  struct Entreprise {
    string ENT_name;
    User Owner;
    User [] members;
    uint256 balance;
    bool registered;
  }
  struct Project {
    string name;
    string Owner;
    User [] Contributers;
    uint256 balance;
    bool registered;
  }

  

  mapping(address => User) public users;
  mapping(address => Entreprise) private ents;
  mapping(address => Project) private projects;




  // Create User 
  
  function createUser(address _userAddress, uint256 _balance,string memory _userName) public {
    User storage user = users[_userAddress];
    // Check that the user did not already exist:
    require(!user.registered);
    //Store the user
    users[_userAddress].balance =_balance;
    users[_userAddress].username =_userName;
    //require(keccak256(abi.encodePacked((users[_userAddress].username)))==keccak256(abi.encodePacked((_userName))),"NON");
    users[_userAddress].registered= true; 
    //item++;
    
}

// Create Entreprise
function createEnt(address _userAddress, uint256 _balance,string memory _entName,User[] memory _members,User memory _owner) public {
    Entreprise storage ent = ents[_userAddress];
    // Check that the user did not already exist:
    require(!ent.registered);
    //Store the user
    ents[_userAddress].balance= _balance;
    ents[_userAddress].ENT_name= _entName;
    ents[_userAddress].Owner= _owner;
    uint256 len=_members.length;
    for (uint256 i = 0; i < len; i+=1) {
            ents[_userAddress].members.push(_members[i]);
        }
    ents[_userAddress].registered= true;
    
}

// Create Project
function createProject(address _userAddress, uint256 _balance,string memory _Name,User[] memory _cont,string memory _owner) public {
    Project storage pro = projects[_userAddress];
    // Check that the user did not already exist:
    require(!pro.registered);
    //Store the user
    projects[_userAddress].balance= _balance;
    projects[_userAddress].name= _Name;
    projects[_userAddress].Owner= _owner;
    uint256 len=_cont.length;
    for (uint256 i = 0; i < len; i+=1) {
            projects[_userAddress].Contributers.push(_cont[i]);
        }
    projects[_userAddress].registered= true;
}

// send ether
 function sendEther (address _to) public payable {
   address payable __to = address(uint160(_to));
   (bool sent,bytes memory data)=__to.call.value(msg.value)("");
   require(sent,"Failed to send Ether");

}
// send ether for project
  function sendEther_project (address _to) public {
   bool exist=false;
   uint256 len=projects[address (this)].Contributers.length;
   for (uint256 i=0;i<len;i+=1){
     if (keccak256 (abi.encodePacked(projects[address (this)].Contributers[i].username,projects[address (this)].Contributers[i].balance,projects[address (this)].Contributers[i].registered))==keccak256 (abi.encodePacked(users[_to].username,users[_to].balance,users[_to].registered))){
       exist=true;
       break;
     }
   }
   require(exist,"The account is not a contributer of a project");
   address payable __to = address(uint160(_to));
   sendEther(__to);
}

  event UserSignedUp(address indexed userAddress, User indexed user);

  function user(address userAddress) public view returns (User memory) {
    return users[userAddress];
  }

  function signUp(string memory username) public returns (User memory) {
    require(bytes(username).length > 0);
    users[msg.sender] = User(username, 0, true);
    emit UserSignedUp(msg.sender, users[msg.sender]);
  }

  function addBalance(uint256 amount) public returns (bool) {
    require(users[msg.sender].registered);
    users[msg.sender].balance += amount;
    return true;
  }
}
