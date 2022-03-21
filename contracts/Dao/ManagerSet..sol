pragma solidity >=0.4.22 <0.9.0;
import './MultisFactory.sol';
import './MultiSign.sol';

contract ManagerSet{

    string[]public types=["singleWallet","multi-signWallet","governanceToken"];

    string public managerType;
    address public singleManagerAddress;
    address public multiSignWalletAddress;
    address public governanceTokenAddress;
    address public multisFactory;

    constructor (address _multisFactory){
       multisFactory= _multisFactory;
    }

    function selectManagerType(string memory _type)public {
        require(keccak256(abi.encodePacked(_type))==keccak256(abi.encodePacked("singleWallet"))||keccak256(abi.encodePacked(_type))==keccak256(abi.encodePacked("signWallet"))||keccak256(abi.encodePacked(_type))==keccak256(abi.encodePacked("governanceToken")),"Type error"); 
         managerType=_type;
    }
    function selectManager(address managerAddress,bool ifHaveMulti,uint _minSignCount, address[] memory _managers)public{
        if(keccak256(abi.encodePacked(managerType))==keccak256(abi.encodePacked("singleWallet"))){
            require(managerAddress!=address(0)); 
            singleManagerAddress=managerAddress;
        }
        if(keccak256(abi.encodePacked(managerType))==keccak256(abi.encodePacked("multi-signWallet"))){
            if(ifHaveMulti==true){
                require(managerAddress!=address(0)); 
                multiSignWalletAddress=managerAddress;
            }

            if(ifHaveMulti=false){
                address newAddress =address(new MultiSign(_minSignCount, _managers,address(this)));
                singleManagerAddress=newAddress;
            }    
        }
        if(keccak256(abi.encodePacked(managerType))==keccak256(abi.encodePacked("governanceToken"))){
            require(managerAddress!=address(0)); 
            //require();//当选择这一个选项时，会设计代币持有者DAO投票权限，比如最低20的投票率与50%的通过率，方可行使管理员权限
            governanceTokenAddress=managerAddress;

        }
    }
}