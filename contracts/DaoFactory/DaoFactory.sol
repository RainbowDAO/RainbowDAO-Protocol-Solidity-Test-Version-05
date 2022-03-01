pragma solidity >=0.4.22 <0.9.0;
import "../ERC20Factory/ERC20Factory.sol";
contract DaoFactory{
    address public owner;
    address public erc20Factory;
    uint public index;
    
    //userDaoInfo[]public userlist;
    mapping(address=>uint[])public userDaoNumber;
    struct DaoInfo{
        string name;
        string abbr;
        string logo;
        string des;
        string types;
        // address authority;
        // address manage;
        // address vault;
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
    function createDaoAndToken(string memory _name,string memory  _abbr,string memory _logo,string memory _des,string memory _type ,string memory _tokenName,string memory _symble,uint8 _decimals, uint _totalSupply)public{
        require(msg.sender != address(0), "Invalid address"); 
        // for(uint i=0;i<daoType.length;i++){
        //     if(daoType[i]==_type){

        //     }
        // }
        // require(_type="childDao","Create type error");  
        address _erc20 = ERC20Factory(erc20Factory).creatToken(_name,_symble,_decimals,msg.sender,_totalSupply);
        DaoInfo memory info=DaoInfo({
            name:_name,
            abbr:_abbr,
            logo:_logo,
            des:_des,
            types:_type
            // authority:
            // manage:
            // vault:
        });
        list.push(info);
        uint userIndex=userDaoNumber[msg.sender].length+1;
        userDaoNumber[msg.sender].push(userIndex);
        userDaoInfo[msg.sender][userIndex]=DaoInfo(_name,_abbr,_logo,_des,_type);
        index++;

    }

      function createDao(string memory _name,string memory  _abbr,string memory _logo,string memory _des,string memory _type )public{
             
        DaoInfo memory info=DaoInfo({
            name:_name,
            abbr:_abbr,
            logo:_logo,
            des:_des,
            types:_type
            // authority:
            // manage:
            // vault:
        });
        list.push(info);
        uint userIndex=userDaoNumber[msg.sender].length+1;
        userDaoNumber[msg.sender].push(userIndex);
        userDaoInfo[msg.sender][userIndex]=DaoInfo(_name,_abbr,_logo,_des,_type);
        index++;
    }

    function getDaonumber()public view returns(uint){
        return index;
    }

     function getUserDaoNumber()public view returns(uint){
        return userDaoNumber[msg.sender].length;
    }

    function getDaoInfo() public view returns(DaoInfo memory){

        return list[index];
    }

    function getuserDaoInfo() public view returns(DaoInfo memory){
        for(uint i=0;i<userDaoNumber[msg.sender].length;i++){
            return userDaoInfo[msg.sender][i];
            }
    }

}