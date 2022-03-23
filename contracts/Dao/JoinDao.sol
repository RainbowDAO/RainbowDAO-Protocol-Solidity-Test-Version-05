pragma solidity >=0.4.22 <0.9.0;
import '../interface/IERC20.sol';
import "./DaoFactory.sol";
import "../lib/Set.sol";
import "./DaoFactory.sol";

contract JoinDao{
    using Set for Set.IdSet;//set库
    address daoFactory;
    ///string[]public typeInfo;
    string[]public users;
    address token;
    uint public index;
    mapping(address => Set.IdSet) userid;
    uint public uid;
    address public DaoAddress;
    mapping(address=>uint)public startTime;
    mapping(address=>uint)public endTime;
    //address[]public member;
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
    DaoInfo[]public lists;
    mapping(uint=>DaoInfo)public info;
    constructor(address _daoFactory,address _token,address _daoAddress){
        daoFactory=_daoFactory;
        token=_token;
        DaoAddress=_daoAddress;
    }

    function joinsDao(uint whichDao,uint _fees,address _token) public {
        uid=uid+1;
        uint32 blockTime=uint32(block.timestamp % 2 ** 32);
        startTime[msg.sender]=blockTime;
        endTime[msg.sender]=blockTime+86400*7;
        if(DaoFactory(daoFactory).getDaoInfo(whichDao).sillWay==1){
            userid[address(this)].add(uid);
            index=index+1;
        }
        if(DaoFactory(daoFactory).getDaoInfo(whichDao).sillWay==2){
            require(DaoFactory(daoFactory).getDaoInfo(whichDao).fee==_fees,"Such as tour fee error");
            userid[address(this)].add(uid);
            index=index+1;
        }
        if(DaoFactory(daoFactory).getDaoInfo(whichDao).sillWay==3){
            require(_token==DaoFactory(daoFactory).getDaoInfo(whichDao).tokenAddress,"It's not a designated token"); 
            uint balanceofs= IERC20(_token).balanceOf(msg.sender);
            require(balanceofs>=100,"Your account balance is insufficient");
            userid[address(this)].add(uid);
            index=index+1;
            
        }
        if(DaoFactory(daoFactory).getDaoInfo(whichDao).sillWay==4){
            require(DaoFactory(daoFactory).getDaoInfo(whichDao).fee==_fees,"Such as tour fee error");
            require(_token==DaoFactory(daoFactory).getDaoInfo(whichDao).tokenAddress,"It's not a designated token"); 
            uint balanceofs= IERC20(_token).balanceOf(msg.sender);
            require(balanceofs>=100,"Your account balance is insufficient");
            userid[address(this)].add(uid);
            index=index+1;
            
        }
        
    }
    function checkTime(uint number)public {
        uint32 blockTime=uint32(block.timestamp % 2 ** 32);
        if(blockTime<endTime[msg.sender]){
            userid[address(this)].remove(number);
        }
    }

    function getDaoMemberNumber()internal view returns(uint256 number){
        DaoFactory(daoFactory).getDaoInfo(number);
        return userid[address(this)].length();
    }
 
    // function getDaoMember()internal view returns(string[] memory){
    //     return userid[address(this)];
    // }

    // function  getDaoInfo(uint number)public view returns(DaoInfo memory){
    //     return DaoFactory(daoFactory).list[number];
    // }

}