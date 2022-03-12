pragma solidity >=0.4.22 <0.9.0;
import "../ERC20Factory/ERC20Factory.sol";
import '../interface/IERC20.sol';
contract DaoFactory{
    address public owner;
    address public erc20Factory;
    address public token;
    uint public index;
    bool public tokenStatus;
    uint public validityDay;
    //uint public sillWay;
    mapping(address=>uint[])public userDaoNumber;
    struct DaoInfo{
        address owner;
        string name;
        string abbr;
        string logo;
        string des;
        string types;
        address tokenAddress;
        uint fee;
        uint sillWay;
    }
    DaoInfo[]public list;
    DaoInfo[]public list2;
    mapping(address=>DaoInfo[]) public  userDaoInfo;
    string[] public daoType=["childDao","independentDao","allianceDao"];
    constructor (address _owner,address _erc20Factory){
        owner=_owner;
        erc20Factory=_erc20Factory;
    }
    modifier onlyOwner()  {
        require(owner== msg.sender, "Ownable: caller is not the owner");
        _;
    }
    function  ifHaveToken(bool tokenStatus)public view returns(bool){
       return tokenStatus;
    }
    function createDaoAndToken(string memory _name,string memory  _abbr,string memory _logo,string memory _des,string memory _type ,string memory _tokenName,string memory _symble,uint8 _decimals, uint _totalSupply)public {
        require(msg.sender != address(0), "Invalid address");  
        //string memory a=daoType[1];
        require(keccak256(abi.encodePacked(_type))==keccak256(abi.encodePacked("childDao"))||keccak256(abi.encodePacked(_type))==keccak256(abi.encodePacked("independentDao"))||keccak256(abi.encodePacked(_type))==keccak256(abi.encodePacked("allianceDao")),"Type error"); 
        token = ERC20Factory(erc20Factory).creatToken(_name,_symble,_decimals,msg.sender,_totalSupply); 
        DaoInfo memory info=DaoInfo({
            owner:msg.sender,
            name:_name,
            abbr:_abbr,
            logo:_logo,
            des:_des,
            types:_type,
            tokenAddress:token,
            fee:0,
            sillWay:0
        });
        list.push(info);
        uint userIndex=userDaoNumber[msg.sender].length+1;
        userDaoNumber[msg.sender].push(userIndex);
        userDaoInfo[msg.sender][userIndex]=DaoInfo(msg.sender,_name,_abbr,_logo,_des,_type,token,0,0);
        list2.push(userDaoInfo[msg.sender][userIndex]);
        index++;

    }

      function createDao(string memory _name,string memory  _abbr,string memory _logo,string memory _des,string memory _type ,address _erc20)public{
        require(msg.sender != address(0), "Invalid address");  
        require(keccak256(abi.encodePacked(_type))==keccak256(abi.encodePacked("childDao"))||keccak256(abi.encodePacked(_type))==keccak256(abi.encodePacked("independentDao"))||keccak256(abi.encodePacked(_type))==keccak256(abi.encodePacked("allianceDao")),"Type error"); 
        DaoInfo memory info=DaoInfo({
            owner:msg.sender,
            name:_name,
            abbr:_abbr,
            logo:_logo,
            des:_des,
            types:_type,
            tokenAddress:_erc20,
            fee:0,
            sillWay:0
        });
        list.push(info);
        uint userIndex=userDaoNumber[msg.sender].length+1;
        userDaoNumber[msg.sender].push(userIndex);
        userDaoInfo[msg.sender][userIndex]=DaoInfo(msg.sender,_name,_abbr,_logo,_des,_type,_erc20,0,0);
        list2.push(userDaoInfo[msg.sender][userIndex]);
        index++;
    }

       function setJoinDaoSill(uint fees,uint _validityDay,uint number,uint ways)public{
           // require(condition);
            require(ways==1||ways==2||ways==3||ways==4,"Select the correct conditions for joining");
            getuserDaoInfo(number).sillWay=ways;
            getuserDaoInfo(number).fee=fees;
            //require(IERC20(getuserDaoInfo(number).tokenAddress).balanceOf(msg.sender)>100,"There are not enough tokens ");
            validityDay=_validityDay;

    }

    function getDaonumber()public view returns(uint){
        return index;
    }

     function getUserDaoNumber()public view returns(uint){
        return userDaoNumber[msg.sender].length;
    }

    function getDaoInfo(uint number) public view returns(DaoInfo memory){
        require(number<=index,"Exceeds the number of DAOs built");
        return list[number];
    }

    function getuserDaoInfo(uint number) public view returns(DaoInfo memory){
        require(number<=userDaoNumber[msg.sender].length,"Exceeds the number of DAOs built");
        return list2[number];

    }
    function getDaoType(uint number)public view returns(string memory){
        return list[number].types;
    }
}