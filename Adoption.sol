pragma solidity ^0.4.24;

/// @title  宠物领养合约
/// @author lzb
/// @notice 项目仅一份合约，完成所有功能
/// @dev    该代码不会持久保存数据，重新部署后会清空全局变量所存的值，
///         该版为使用用户序号作为查询接口
contract Adoption {
    // 用户序号
    uint8 userIndex = 0;
    // 用户序号映射表
    mapping(address => uint8) userMapping;
    // 保存领养者的地址
    address[8] private adopters;
    // 初始化用户序号
    constructor() public {
        userIndex = 0;
    }
    // 判断用户是否存在
    modifier userExist(address userAddress){
        require(userMapping[msg.sender] != 0, "user not register");
        _;
    }

    /// @notice 注册
    /// @param  user => 用户地址
    /// @return userMapping[user] => 用户序号
    /// @dev    判断用户是否已注册，若无注册，则序号增加并存入
    function register(address user) public returns(uint8) {
        require(userMapping[user] == 0,"user is registered");
        userMapping[user] = ++userIndex;
        return userMapping[user];
    }
    
    /// @notice 登录
    /// @param  user => 用户地址
    /// @return userMapping[user] => 用户序号
    /// @dev    判断用户是否可以登录（>0）
    function login(address user) public view userExist(user) returns(uint8) {
        return userMapping[user];
    }
    
    /// @notice 领养宠物
    /// @param  petId => 宠物编号
    /// @return petId => 宠物编号
    /// @dev    判断宠物是否存在，以及宠物是否有被领养，若否则存入组里
    function adopt(uint8 petId) public userExist(msg.sender) returns (uint8) {
        // 确保 id 在数组长度内
        require(petId >= 0 && petId <= 7, "pet does not exist");
        require(adopters[petId] == address(0x0), "address not null,pet is adopted");
        // 保存调用这地址
        adopters[petId] = msg.sender; 
        return petId;
    }
    /// @notice 获取所有领养者
    /// @return adopters => 所有领养者的地址
    function getAdopters() public view returns (address[8]) { 
        return adopters;
    }
}