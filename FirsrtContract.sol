pragma solidity ^0.5.1;

contract MyContract{
    // string public value= "myValue";
    // string public constant stringValue = "hello";
    // bool public myBool = true;
    // int public myInt = 1;
    // uint public muUnit = 1; // unsigned integer
    // uint8 public myUnit8 = 8; // byte 

    // enum State {Waiting, Ready, Actice}
    // State public state;
    // constructor function
    constructor(address payable _wallet,address _token) public{
        // value = "a";
        // state = State.Waiting;
        // owner = msg.sender;
        wallet = _wallet;
        token = _token;
    }

    // default get value if it's a public variable
    // function get() public view returns(string memory){
    //     return value;
    // }

    // function set(string memory _value) public{
    //     value =_value;
    //     // return type string 
    //     // public scope
    // }
    // function activate() public{
    //     state = State.Actice;
    // }
    // function isActive() public view returns(bool){
    //     return state == State.Actice;
    // }

    // struct Person{
    //     uint id;
    //     string firstName;
    //     string lastName;
    // }

    // // struct
    // Person[] public people; // array of persons
    // uint256 public peopleCount;
    // function addPerson(string memory _firstName, string memory _lastName)public onlyWhileOpen{
    //     people.push(Person(0,_firstName,_lastName));
    //     peopleCount+=1;
    // }

    // // address
    // address owner;

    // modifier onlyOwner(){
    //     // meta data passed in: msg
    //     require(msg.sender == owner);
    //     // if not ownder, throw error
    //     _;
    // }

    // // decide the owner?
    // // set owner

    // // mapping
    // mapping(uint=>Person)public peopleMap;
    // function addPersonMapping(string memory _firstName, string memory _lastName)public onlyOwner{
    //     peopleCount+=1;
    //     peopleMap[peopleCount] = Person(peopleCount,_firstName,_lastName);
        
    // }

    // // private method
    // function incrementCount() internal{
    //     peopleCount+=1;
    // }

    // uint256 openingTime = 1544669573; // in second (epoch time
    // // time
    // modifier onlyWhileOpen(){
    //     require(block.timestamp>=openingTime); // only work if the current time larger than opening time
    //     _;
    // }

    // send etherum
    mapping(address => uint256) public balances;
    address payable wallet;
    address public token;

    // payable 
    function buyToken() public payable{
        // buy a token
        ERC20Token _token = ERC20Token(address(token));
        _token.mint();
        // send ether to the wallet
        //balances[msg.sender]+=1;
        // how much eth 
        // the value we passed in 
        //wallet.transfer(msg.value);
        emit Purchase(msg.sender,1);
    }
    
    // event 
    event Purchase(
        // filter event based on certain buyer
        address indexed _buyer,
        uint256 _amount
    );

    // function() external payable{
    //     buyToken();
    // }
}

// mutiple contracts
contract ERC20Token{
    string public name;
    mapping(address => uint256) public balances;

    constructor(string memory _name) public{
        name = _name;
    }
    function mint() public {
        // msg.sender won't work
        // tx origin gives the orginal msg
        balances[tx.origin]++;
    }
}

contract MyToken is ERC20Token{
    string public symbol;
    address[] public owners;
    uint256 ownerCount;
    constructor(string memory _name,string memory _symbol) 
        ERC20Token(_name) 
    public{
        symbol = _symbol;
    }

    function mint() public {
        super.mint();
        ownerCount ++;
        owners.push(msg.sender);
    }
}