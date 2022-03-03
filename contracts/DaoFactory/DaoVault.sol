pragma solidity >=0.4.22 <0.9.0;
import '../interface/IERC20.sol';
//import '../TransferHelper.sol';

contract vault {
    address public owner;
    string public name;
    string public intro;
    string public logo;
    address public rbd;
    uint public index;
    uint public index2;
    uint public vaultAmount;

    struct userInfo{
        address valutAddress;
        address owner;
        uint depositAmount;
        uint depositTime;
        uint withdrawalTime;
        uint withdrawalAmount;
    }
    mapping(address=> userInfo) info;
    userInfo[] public allDepositInfo;
    userInfo[]public allWithdrawalInfo;
    //mapping(address=>withdrawalInfo)public withdrawalList;

    constructor(address _rbd) public {
        rbd = _rbd;
    }

    function deposit(address _rbd, uint amount ) public {
        uint32 blockTime=uint32(block.timestamp % 2 ** 32);
        uint userBalance=IERC20(rbd).balanceOf(msg.sender);
        require(rbd==_rbd,"The token address is incorrect  ");
        require (amount<=userBalance,"There aren't enough tokens");
        index=index+1; 
        IERC20(rbd).transferFrom(msg.sender,address(this),amount);
        info[msg.sender].depositTime=blockTime;
        info[msg.sender].valutAddress=address(this);
        info[msg.sender].depositAmount=amount;
        info[msg.sender].owner=msg.sender;

        userInfo memory depositInfos=userInfo({
            valutAddress:address(this),
            owner:msg.sender,
            depositAmount:info[msg.sender].depositAmount,
            depositTime: info[msg.sender].depositTime,
            withdrawalTime:blockTime,
            withdrawalAmount:amount
        });
        allDepositInfo.push(depositInfos);
        vaultAmount=vaultAmount+amount;
    }
     function withdraw(address _rbd,address to ,uint amount,uint number)public{

        require(rbd==_rbd,"The token address is incorrect ");
        index2=index2+1;
        uint32 blockTime = uint32(block.timestamp % 2 ** 32);
        require(amount<=info[msg.sender].depositAmount,"The amount withdrawn exceeds the total amount");
        IERC20(rbd).transferFrom(address(this),msg.sender,amount);
        info[msg.sender].withdrawalTime=blockTime;
        info[msg.sender].withdrawalAmount=amount;
        info[msg.sender].depositAmount=info[msg.sender].depositAmount-amount;     
        userInfo memory withdrawInfos=userInfo({
            valutAddress:address(this),
            owner:msg.sender,
            depositAmount:info[msg.sender].depositAmount,
            depositTime: info[msg.sender].depositTime,
            withdrawalTime:blockTime,
            withdrawalAmount:amount
        });

        allWithdrawalInfo.push(withdrawInfos);
        vaultAmount=vaultAmount-amount;
    }

    function getAllWithdrawInfo(uint _index)public view returns(userInfo memory){
        return allWithdrawalInfo[_index];

    }

    function getAllDepositInfo(uint _index)public view returns(userInfo memory){

        return allDepositInfo[_index];

    }

    function getUserWithdrawInfo()public view returns(userInfo memory){
        return info[msg.sender];

    }

    function getUserDepositInfo(uint _index)public view returns(userInfo memory){

        //return info[msg.sender];

    }

    function getUserBanlance()public view returns(uint){
        return info[msg.sender].depositAmount;
    }

    
}