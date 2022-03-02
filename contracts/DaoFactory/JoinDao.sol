pragma solidity >=0.4.22 <0.9.0;
import '../interface/IERC20.sol';
import "./DaoFactory.sol";

contract JoinDao{
    address daoFactory;
    ///string[]public typeInfo;
    string[]public users;
    address token;
    uint public index;
   
    mapping(address=>uint)public startTime;
    mapping(address=>uint)public endTime;
    address[]public member;
    
     struct DaoInfo{
        string name;
        string abbr;
        string logo;
        string des;
        string types;
        address tokenAddress;
    }
    DaoInfo[]public list;
    mapping(uint=>DaoInfo)public info;
    constructor(address _daoFactory,address _token){
        daoFactory=_daoFactory;
        token=_token;
    }

    function joinsDao(uint whichDao,uint _fees,address _token) public {
        if(DaoFactory(daoFactory).getDaoInfo(whichDao).sillWay==1){
            member.push(msg.sender);
        }
        if(DaoFactory(daoFactory).getDaoInfo(whichDao).sillWay==2){
            require(DaoFactory(daoFactory).getDaoInfo(whichDao).fee==_fees,"Such as tour fee error");
            member.push(msg.sender);
        }
        if(DaoFactory(daoFactory).getDaoInfo(whichDao).sillWay==3){
            require(_token==DaoFactory(daoFactory).getDaoInfo(whichDao).tokenAddress,"It's not a designated token"); 
            
        }
        if(DaoFactory(daoFactory).getDaoInfo(whichDao).sillWay==4){
            require(_token==DaoFactory(daoFactory).getDaoInfo(whichDao).tokenAddress,"It's not a designated token"); 
            
        }
        
        uint32 blockTime=uint32(block.timestamp % 2 ** 32);
        startTime[msg.sender]=blockTime;

        
    }
    // function setJoinDaoSill(uint fees,uint validityDay,uint number,uint ways)public{
    //         require(ways==1||ways==2||ways==3||ways==4,"Select the correct conditions for joining");
    //         fee=fees;
    //         require(IERC20(token).balanceOf(msg.sender)>100,"There are not enough tokens  ");
    
    //         uint32 blockTime=uint32(block.timestamp % 2 ** 32);
    //         endTime[msg.sender]=startTime+86400*validityDay;
    //         list.push(DaoFactory(daoFactory).getDaoInfo[number]);

    // }
}