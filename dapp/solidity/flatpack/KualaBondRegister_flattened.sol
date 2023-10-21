
// File: contracts/interfaces/IOpsRegister.sol


pragma solidity ^0.8.20;

interface IOpsRegister { 

    function getAddress(string memory _name) view external returns (address _address);

    function getName(address _address) view external returns (string memory _name);

}
// File: contracts/interfaces/IVersion.sol


pragma solidity ^0.8.20;

interface IVersion { 
    
    function getVName() view external returns (string memory _name);

    function getVVersion() view external returns (uint256 _version);

}
// File: contracts/interfaces/IKualaBondStructs.sol


pragma solidity ^0.8.20;

struct ERC20 { 
    string name; 
    string symbol; 
    address token;
    uint256 chainId;  
}

enum BondType {NATURAL, SYNTHETIC}
enum BondStatus {ISSUED, TELEPORTED, SETTLED}

struct KualaBond {
    uint256 id; 
    BondType bondType; 
    ERC20 erc20; 
    uint256 sourceChain; 
    uint256 createDate; 
    address bondContract; 
    uint256 amount; // numerical quanity of currency NOT value
    BondStatus status; 
}

struct RegisteredKualaBond { 
    KualaBond bond; 
    uint256 registrationId; 
    uint256 verificationId; 
}

struct BondConfiguration { 
    uint256 chainId; 
    ERC20 erc20; 
    BondType bondType; 
}

enum SettlementType {BOND, COLLATERAL}

struct Settlement {
    uint256 id; 
    SettlementType settlementType; 
    uint256 holdingChain; 
    ERC20 erc20; 
    address beneficiary; 
    uint256 bondId; 
    uint256 amount; 
    uint256 vaultId; 
}

enum TeleportAction {MATERIALIZE, SETTLE}

interface IKualaBondStructs { 

    function getStructCount() view external returns (uint256 _structCount);
}
// File: contracts/interfaces/IKualaBondContract.sol


pragma solidity ^0.8.20;


interface IKualaBondContract { 

    function getBondConfiguration() view external returns (BondConfiguration memory _bondConfiguration);   

    function getKualaBond(uint256 _bondId) view external returns (KualaBond memory _bond);
}
// File: contracts/interfaces/IKualaBondRegister.sol


pragma solidity ^0.8.20;


struct KualaBondVerification { 
    uint256 id; 
    uint256 verificationDate; 
    uint256 bondId; 
    address verifier; 
    uint256 sourceChain; 
    uint256 hostChain; 
    uint256 bondAmount; 
    ERC20 sourceErc20; 
}

struct KualaBondContractRegistration { 
    uint256 id; 
    address kualaBondContract; 
    address registra; 
    uint256 registrationDate; 
}

struct KualaBondContractDeRegistration { 
    uint256 id; 
    address kualaBondContract; 
    address deregistra; 
    uint256 deregistrationDate; 
}

interface IKualaBondRegister { 

    function getKualaBondRegistrationIds() view external returns (uint256 [] memory _registrationIds);

    function getKualaBondRegistration(address _kualaBondContract) view external returns (KualaBondContractRegistration memory _kualaBondRegistration);

    function findBondContracts(address _erc20, uint256 _srcChain) view external returns (address [] memory kualaBondContracts);

    function isRegisteredContract(address _kualaBondContract) view external returns (bool _isRegisteredContract);

    function getBondContract(uint256 _registrationId) view external returns(address kualaBondContract);

    function registerBondContract(address kualaBondContract) external returns (uint256 _registrationId);

    function deregisterBondContract(uint256 _registrationId) external returns (uint256 _deregistrationId);

    
    function getRegisteredBond(uint256 _registrationId) view external returns (RegisteredKualaBond memory _rBond);
    
    function findBond(uint256 _bondId, address bondContract, uint256 _chainId) view external returns (KualaBond memory _bond);

    function isRegistered(RegisteredKualaBond memory _rBond) view external returns (bool _isRegistered);

    function registerBond(KualaBond memory _kualaBond) external returns (RegisteredKualaBond memory _rBond);

    function getVerification(uint256 _verficiationId) view external returns (KualaBondVerification memory _kualaBondVerification);

    function updateStatus(uint256 _registrationId, BondStatus _status) external returns (RegisteredKualaBond memory _kualaBond);

}
// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// File: contracts/core/KualaBondRegister.sol


pragma solidity ^0.8.20;







contract KualaBondRegister is IKualaBondRegister, IVersion { 

    string constant name  = "KUALA_BOND_REGISTER";
    uint256 constant version = 3; 

    string constant KUALA_BOND_TELEPORTER_CA = "KUALA_BOND_TELEPORTER";
    string constant KUALA_BOND_ADMIN_CA = "KUALA_BOND_ADMIN";

    IOpsRegister register; 

    address admin; 
    address self; 
    uint256 chainId; 
    uint256 index; 

    uint256 [] kualaBondRegistrationIds; 
    uint256 [] kualaBondDeregistrationIds; 

    mapping(uint256=>address) kualaBondContractByRegistrationId; 
    mapping(uint256=>bool) isKnownKualaBondRegistrationId;
    mapping(address=>bool) isRegisteredKualaBondContract; 
    mapping(uint256=>mapping(address=>address[])) bondContractsByERC20BySrcChain; 
    mapping(uint256=>RegisteredKualaBond) registeredKualaBondById; 
    mapping(uint256=>mapping(address=>mapping(uint256=>bool))) hasKualaBondByBondContractByChainId;
    mapping(uint256=>mapping(address=>mapping(uint256=>KualaBond))) kualaBondByIdByBondContractByChainId;
    mapping(uint256=>bool) isKnownVerificationId; 
    mapping(uint256=>KualaBondVerification) kualaBondVerificationById; 
    mapping(uint256=>KualaBondContractRegistration) kualaBondContractRegistrationById; 
    mapping(address=>uint256) kualaBondContractRegistrationIdByKualaBondContractAddress; 
    mapping(address=>bool) isDeregisteredKualaBondContract;
    mapping(uint256=>KualaBondContractDeRegistration) kualaBondContractDeregistrationById;


    constructor(address _register, uint256 _chainId) { 
        register = IOpsRegister(_register);
        chainId = _chainId; 
        self    = address(this);
    }
    function getVName() pure external returns (string memory _name){
        return name; 
    }

    function getVVersion() pure external returns (uint256 _version){
        return version; 
    }
    function getKualaBondRegistrationIds() view external returns (uint256 [] memory _registrationIds){
        return kualaBondRegistrationIds; 
    }

    function getKualaBondRegistration(address _kualaBondContract) view external returns (KualaBondContractRegistration memory _kualaBondRegistration){
        return kualaBondContractRegistrationById[kualaBondContractRegistrationIdByKualaBondContractAddress[_kualaBondContract]];
    }

    function getBond(uint256 _registrationId) view external returns (RegisteredKualaBond memory _rBond){
        return registeredKualaBondById[_registrationId];
    }
    
    function findBond(uint256 _bondId, address _bondContract, uint256 _chainId) view external returns (KualaBond memory _bond){
        require(hasKualaBondByBondContractByChainId[_chainId][_bondContract][_bondId], "unknown bond");
        return kualaBondByIdByBondContractByChainId[_chainId][_bondContract][_bondId];
    }

    function isRegistered(RegisteredKualaBond memory _rBond) view external returns (bool _isRegistered){
        RegisteredKualaBond memory rBond_ = registeredKualaBondById[_rBond.registrationId];
        require(rBond_.bond.id == _rBond.bond.id, "bond id mis-match");
        require(rBond_.bond.sourceChain == _rBond.bond.sourceChain, "source chain mis-match");
        require(rBond_.bond.bondType == _rBond.bond.bondType, "bond type mis-match");
        require(rBond_.bond.createDate == rBond_.bond.createDate, "create date mismatch");
        require(rBond_.bond.bondContract == rBond_.bond.bondContract, "bond contract mis-match");
        require(rBond_.bond.amount == rBond_.bond.amount, "bond amount mis-match");
        return true; 
    }

    function registerBond(KualaBond memory _kualaBond) external returns (RegisteredKualaBond memory _rBond){
        require(isRegisteredKualaBondContract[_kualaBond.bondContract], "unregistered bond contract");
        
        KualaBondVerification memory kualaBondVerification_ =  verifyBond(_kualaBond);
        _rBond = RegisteredKualaBond({
                                        bond : _kualaBond, 
                                        registrationId : getIndex(),
                                        verificationId : kualaBondVerification_.id
                                    });
        registeredKualaBondById[_rBond.registrationId] = _rBond; 
        hasKualaBondByBondContractByChainId[_kualaBond.sourceChain][_kualaBond.bondContract][_kualaBond.id] = true; 
        kualaBondByIdByBondContractByChainId[_kualaBond.sourceChain][_kualaBond.bondContract][_kualaBond.id] = _kualaBond; 
        return _rBond; 
    }

    function getVerification(uint256 _verificiationId) view external returns (KualaBondVerification memory _kualaBondVerification){
        require(isKnownVerificationId[_verificiationId], "unknown verification id");
        return kualaBondVerificationById[_verificiationId];
    }

    function getRegisteredBond(uint256 _registrationId) view external returns (RegisteredKualaBond memory _rBond){
        return  registeredKualaBondById[_registrationId]; 
    }
    
    function findBondContracts(address _erc20, uint256 _srcChain) view external returns (address [] memory kualaBondContracts){
        return bondContractsByERC20BySrcChain[_srcChain][_erc20];
    }

    function isRegisteredContract(address _kualaBondContract) view external returns (bool _isRegisteredContract){
        return isDeregisteredKualaBondContract[_kualaBondContract]? false : isRegisteredKualaBondContract[_kualaBondContract];
    }

    function getBondContract(uint256 _registrationId) view external returns(address kualaBondContract){
        return kualaBondContractByRegistrationId[_registrationId];
    }

    function registerBondContract(address _kualaBondContract) external returns (uint256 _registrationId){
        require(!isDeregisteredKualaBondContract[_kualaBondContract],"de-registered bond contract");
        require(!isRegisteredKualaBondContract[_kualaBondContract],"already registered");

        _registrationId = getIndex(); 
        kualaBondContractByRegistrationId[_registrationId] = _kualaBondContract; 
        isKnownKualaBondRegistrationId[_registrationId] = true; 
        isRegisteredKualaBondContract[_kualaBondContract] = true; 

        BondConfiguration memory bondConfiguration_ = IKualaBondContract(_kualaBondContract).getBondConfiguration(); 
        bondContractsByERC20BySrcChain[bondConfiguration_.chainId][bondConfiguration_.erc20.token].push(_kualaBondContract);
        return _registrationId; 
    }

    function deregisterBondContract(uint256 _registrationId) external returns (uint256 _deRegistrationId){
        require(isKnownKualaBondRegistrationId[_registrationId], "unknown registration id");
        KualaBondContractRegistration memory kualaBondContractRegistration_ = kualaBondContractRegistrationById[_registrationId];
        require(kualaBondContractRegistration_.registra == msg.sender || register.getAddress(KUALA_BOND_ADMIN_CA) == msg.sender, "registrar or admin only");
        isDeregisteredKualaBondContract[ kualaBondContractRegistration_.kualaBondContract] = true; 
        _deRegistrationId = getIndex(); 
        kualaBondContractDeregistrationById[_deRegistrationId] = KualaBondContractDeRegistration({ 
                                                                                                    id : _deRegistrationId, 
                                                                                                    kualaBondContract : kualaBondContractRegistration_.kualaBondContract, 
                                                                                                    deregistra : msg.sender,
                                                                                                    deregistrationDate : block.timestamp
                                                                                                });
        return _deRegistrationId; 
    }

    function updateStatus(uint256 _registrationId, BondStatus _status) external returns (RegisteredKualaBond memory _kualaBond){
        require(msg.sender == register.getAddress(KUALA_BOND_TELEPORTER_CA) 
            || register.getAddress(KUALA_BOND_ADMIN_CA) == msg.sender, "authorised only" );
        registeredKualaBondById[_registrationId].bond.status = _status; 

        return  registeredKualaBondById[_registrationId];
    }
    
    // =============================== INTERNAL =================================================

    function verifyBond(KualaBond memory _kualaBond) internal returns (KualaBondVerification memory _kualaBondVerification){
        
        uint256 bondContractHolding_ = 0; 
        if(_kualaBond.sourceChain != chainId) {
            // run cross chain verification 
        }
        else { 
            IERC20 erc20_ = IERC20(_kualaBond.erc20.token);
            bondContractHolding_ = erc20_.balanceOf(_kualaBond.bondContract); 
        }
       
        require(bondContractHolding_ >= _kualaBond.amount, "bond amounts miss match");
        _kualaBondVerification = KualaBondVerification({
                                                            id : getIndex(), 
                                                            verificationDate : block.timestamp,  
                                                            bondId : _kualaBond.id,
                                                            verifier : self, 
                                                            sourceChain : _kualaBond.sourceChain,  
                                                            hostChain : chainId,  
                                                            bondAmount : _kualaBond.amount, 
                                                            sourceErc20 : _kualaBond.erc20 
                                                        });
        kualaBondVerificationById[_kualaBondVerification.id] = _kualaBondVerification; 
        isKnownVerificationId[_kualaBondVerification.id] = true; 
        return _kualaBondVerification; 
    }

    //======================================== INTERNAL =====================================================

    function getIndex() internal returns (uint256 _index) {
        _index = index++; 
        return _index; 
    }
}