pragma solidity >=0.4.22 <0.9.0;
import './MultiSign.sol';


contract DepartmentFactory{

    string[]public types=["multi-signWallet","governanceToken"];
    string public managerType;
    address public multiSignWalletAddress;
    address public governanceTokenAddress;
    uint public index;
    
   struct departmentInfo{
        string name;
        string  introduction;
        bool  authority;
   }

    mapping(address=>departmentInfo)public userDepartmentList;

    departmentInfo[] public allDepartmentlist;


    function createDpartment(string memory _name,string memory _introduction,bool _authority )public{
        index=index+1;
        departmentInfo memory info=departmentInfo({
            name:_name,
            introduction:_introduction,
            authority:_authority
        });
        allDepartmentlist.push(info);
        userDepartmentList[msg.sender].name=_name;
        userDepartmentList[msg.sender].introduction=_introduction;
        userDepartmentList[msg.sender].authority=_authority;
    }

    function selectManagerType(string memory _type)public {
        require(keccak256(abi.encodePacked(_type))==keccak256(abi.encodePacked("signWallet"))||keccak256(abi.encodePacked(_type))==keccak256(abi.encodePacked("governanceToken")),"Type error"); 
         managerType=_type;
    }

    function permissionSet(address managerAddress,bool ifHaveMulti,uint _minSignCount, address[] memory _managers)public {
        
            if(ifHaveMulti==true){
                require(managerAddress!=address(0)); 
                multiSignWalletAddress=managerAddress;
            }

            if(ifHaveMulti=false){
                address newAddress =address(new MultiSign(_minSignCount, _managers,address(this)));
                multiSignWalletAddress=newAddress;
            } 
    }
    function getAllDepartmentlist(uint number)public view returns(departmentInfo memory){

        return allDepartmentlist[number];
    }

    function getUserDepartmentlist()public view returns(departmentInfo memory ){

        return userDepartmentList[msg.sender];
    }

}