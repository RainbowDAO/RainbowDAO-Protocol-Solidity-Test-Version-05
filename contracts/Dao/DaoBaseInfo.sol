pragma solidity >=0.4.22 <0.9.0;
//
contract DaoBaseInfo{
    address public owner;
    mapping(address=>Info) public daoInfo;
    struct Info{
    address owner;
    string  name;
    string  logo;
    string desc;
    }
    
    Info[]public list;
   
    constructor (address _owner){
        owner=_owner;

    }
    function setInfo(address _owner,string memory _name,string memory _logo,string memory _desc)public{
        require(owner==msg.sender,"do not have permission ");
        Info memory infos=Info({
            owner:_owner,
            name:_name,
            logo:_logo,
            desc:_desc
        });
        list.push(infos);
    }

    function setName(string memory _name,uint index) public{
        require(owner==msg.sender,"do not have permission ");
        list[index].name=_name;
    }

    function setOwner(address _owner,uint index) public{
        require(owner==msg.sender,"do not have permission ");
        list[index].owner=_owner;

    }

    function setLogo(string memory _logo,uint index) public{
        require(owner==msg.sender,"do not have permission ");
        list[index].logo=_logo;
    }

    function setDesc(string memory _desc,uint index) public{
        
        require(owner==msg.sender,"do not have permission ");
        list[index].desc=_desc;
    }

    function getInfo(uint index)public view returns( Info memory){
        return list[index];
    }
}