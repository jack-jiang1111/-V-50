pragma solidity ^0.5.1;
import "./Date.sol";

contract Vme50{
    address payable myAdress;
    address payable [] public reciever ;
    int recieverCount = 0;
    int public today;

    modifier onlyThursday(){
        // meta data passed in: msg
        today = ThursdayChecker.isThursday(block.timestamp);
        require(ThursdayChecker.isThursday(block.timestamp)==4);
        // must be Thursday
        _;
    }
    event LogMessage(string message);

    function booleanToString(bool value) public pure returns (string memory) {
        if (value) {
            return "true";
        } else {
            return "false";
        }
    }   
    // V me 50 
    function V50toMe() public onlyThursday{
        // add your address to the address array, waiting for the rich guy
        reciever.push(msg.sender);
        recieverCount++;
    }

    function V50toOthers() public payable onlyThursday{
        if(recieverCount!=0){
            // transfer 50 to the first reciever
            //require(address(this).balance >= 50 ether, "Insufficient balance");
            reciever[0].transfer(msg.value);

            // remove the first reciever
            for (uint i = 0; i < reciever.length - 1; i++) {
                reciever[i] = reciever[i + 1];
            }
            //reciever.pop();
        }
        
    }
}


