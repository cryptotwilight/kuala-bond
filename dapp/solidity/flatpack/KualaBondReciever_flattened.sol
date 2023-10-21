// SPDX-License-Identifier: MIT
// File: contracts/interfaces/IKBRoutingRegistry.sol


pragma solidity ^0.8.20;

struct Locus { 
    address location; 
    uint256 chainId; 
    string name; 
}   

interface IKBRoutingRegistry { 

    function getLoci() view external returns (Locus [] memory _loci);

    function isKnownRemoteAddress(address _address) view external returns (bool _isKnown);

    function getSrcChain(address _address) view external returns (uint256 _chainId);

    function getAddress(uint256 _chainId, string memory _name) view external returns (address _address);

    function getAxelarChainName(uint256 _chainId) view external returns (string memory _chainName);

    function isSupportedAxelarChainName(string memory _chain) view external returns (bool _isSupported);

}
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
// File: contracts/interfaces/IKBSyntheticFactory.sol


pragma solidity ^0.8.20;


interface IKBSyntheticFactory { 

    function getKualaBondSyntheticContract(string memory _name, string memory _symbol, BondConfiguration memory _bondConfiguration) external returns (address _kualaBondSyntheticContract);

}
// File: contracts/interfaces/IKualaBondTeleportReciever.sol


pragma solidity ^0.8.20;


struct ManifestDescriptor { 
    uint256 id; 
    CompressedTeleportDescriptor descriptor; 
    uint256 reBondId; 
    address bondContract; 
}

struct SettlementConfirmation { 
    uint256 id; 
    Settlement settlement; 
    uint256 completionDate; 
}

struct CompressedTeleportDescriptor { 
        uint256 teleportId;
        KualaBond bond; 
        uint256 srcChainRegistrationId; 
        address owner; 
        uint256 vaultId; 
}

interface IKualaBondTeleportReciever { 
        
    function getRecievedBonds() view external returns (RegisteredKualaBond [] memory _rBonds);

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
// File: contracts/interfaces/IKualaBondContract.sol


pragma solidity ^0.8.20;


interface IKualaBondContract { 

    function getBondConfiguration() view external returns (BondConfiguration memory _bondConfiguration);   

    function getKualaBond(uint256 _bondId) view external returns (KualaBond memory _bond);
}
// File: contracts/interfaces/IKualaBondSyntheticContract.sol


pragma solidity ^0.8.20;




interface IKualaBondSyntheticContract is IKualaBondContract {

    function getSourceBond(uint256 _srcBondId)  view external returns (KualaBond memory _bond);

    function isVerifiedSettlement(Settlement memory _settlement) view external returns (bool _isVerified);

    function reIssueKualaBond(KualaBond memory _srcBond, uint256 _vaultId) external returns (KualaBond memory _reBond);
     
    function settleKualaBond(uint256 _reBondId) external returns (Settlement memory settlement);

}
// File: @openzeppelin/contracts/utils/introspection/IERC165.sol


// OpenZeppelin Contracts (last updated v5.0.0) (utils/introspection/IERC165.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: @openzeppelin/contracts/token/ERC721/IERC721.sol


// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.20;


/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
     *   a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or
     *   {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
     *   a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the address zero.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

// File: @axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IContractIdentifier.sol



pragma solidity ^0.8.0;

// General interface for upgradable contracts
interface IContractIdentifier {
    /**
     * @notice Returns the contract ID. It can be used as a check during upgrades.
     * @dev Meant to be overridden in derived contracts.
     * @return bytes32 The contract ID
     */
    function contractId() external pure returns (bytes32);
}

// File: @axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IOwnable.sol



pragma solidity ^0.8.0;

/**
 * @title IOwnable Interface
 * @notice IOwnable is an interface that abstracts the implementation of a
 * contract with ownership control features. It's commonly used in upgradable
 * contracts and includes the functionality to get current owner, transfer
 * ownership, and propose and accept ownership.
 */
interface IOwnable {
    error NotOwner();
    error InvalidOwner();
    error InvalidOwnerAddress();

    event OwnershipTransferStarted(address indexed newOwner);
    event OwnershipTransferred(address indexed newOwner);

    /**
     * @notice Returns the current owner of the contract.
     * @return address The address of the current owner
     */
    function owner() external view returns (address);

    /**
     * @notice Returns the address of the pending owner of the contract.
     * @return address The address of the pending owner
     */
    function pendingOwner() external view returns (address);

    /**
     * @notice Transfers ownership of the contract to a new address
     * @param newOwner The address to transfer ownership to
     */
    function transferOwnership(address newOwner) external;

    /**
     * @notice Proposes to transfer the contract's ownership to a new address.
     * The new owner needs to accept the ownership explicitly.
     * @param newOwner The address to transfer ownership to
     */
    function proposeOwnership(address newOwner) external;

    /**
     * @notice Transfers ownership to the pending owner.
     * @dev Can only be called by the pending owner
     */
    function acceptOwnership() external;
}

// File: @axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IUpgradable.sol



pragma solidity ^0.8.0;



// General interface for upgradable contracts
interface IUpgradable is IOwnable, IContractIdentifier {
    error InvalidCodeHash();
    error InvalidImplementation();
    error SetupFailed();
    error NotProxy();

    event Upgraded(address indexed newImplementation);

    function implementation() external view returns (address);

    function upgrade(
        address newImplementation,
        bytes32 newImplementationCodeHash,
        bytes calldata params
    ) external;

    function setup(bytes calldata data) external;
}

// File: @axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol



pragma solidity ^0.8.0;


/**
 * @title IAxelarGasService Interface
 * @notice This is an interface for the AxelarGasService contract which manages gas payments
 * and refunds for cross-chain communication on the Axelar network.
 * @dev This interface inherits IUpgradable
 */
interface IAxelarGasService is IUpgradable {
    error NothingReceived();
    error InvalidAddress();
    error NotCollector();
    error InvalidAmounts();

    event GasPaidForContractCall(
        address indexed sourceAddress,
        string destinationChain,
        string destinationAddress,
        bytes32 indexed payloadHash,
        address gasToken,
        uint256 gasFeeAmount,
        address refundAddress
    );

    event GasPaidForContractCallWithToken(
        address indexed sourceAddress,
        string destinationChain,
        string destinationAddress,
        bytes32 indexed payloadHash,
        string symbol,
        uint256 amount,
        address gasToken,
        uint256 gasFeeAmount,
        address refundAddress
    );

    event NativeGasPaidForContractCall(
        address indexed sourceAddress,
        string destinationChain,
        string destinationAddress,
        bytes32 indexed payloadHash,
        uint256 gasFeeAmount,
        address refundAddress
    );

    event NativeGasPaidForContractCallWithToken(
        address indexed sourceAddress,
        string destinationChain,
        string destinationAddress,
        bytes32 indexed payloadHash,
        string symbol,
        uint256 amount,
        uint256 gasFeeAmount,
        address refundAddress
    );

    event GasPaidForExpressCall(
        address indexed sourceAddress,
        string destinationChain,
        string destinationAddress,
        bytes32 indexed payloadHash,
        address gasToken,
        uint256 gasFeeAmount,
        address refundAddress
    );

    event GasPaidForExpressCallWithToken(
        address indexed sourceAddress,
        string destinationChain,
        string destinationAddress,
        bytes32 indexed payloadHash,
        string symbol,
        uint256 amount,
        address gasToken,
        uint256 gasFeeAmount,
        address refundAddress
    );

    event NativeGasPaidForExpressCall(
        address indexed sourceAddress,
        string destinationChain,
        string destinationAddress,
        bytes32 indexed payloadHash,
        uint256 gasFeeAmount,
        address refundAddress
    );

    event NativeGasPaidForExpressCallWithToken(
        address indexed sourceAddress,
        string destinationChain,
        string destinationAddress,
        bytes32 indexed payloadHash,
        string symbol,
        uint256 amount,
        uint256 gasFeeAmount,
        address refundAddress
    );

    event GasAdded(
        bytes32 indexed txHash,
        uint256 indexed logIndex,
        address gasToken,
        uint256 gasFeeAmount,
        address refundAddress
    );

    event NativeGasAdded(bytes32 indexed txHash, uint256 indexed logIndex, uint256 gasFeeAmount, address refundAddress);

    event ExpressGasAdded(
        bytes32 indexed txHash,
        uint256 indexed logIndex,
        address gasToken,
        uint256 gasFeeAmount,
        address refundAddress
    );

    event NativeExpressGasAdded(
        bytes32 indexed txHash,
        uint256 indexed logIndex,
        uint256 gasFeeAmount,
        address refundAddress
    );

    event Refunded(
        bytes32 indexed txHash,
        uint256 indexed logIndex,
        address payable receiver,
        address token,
        uint256 amount
    );

    /**
     * @notice Pay for gas using ERC20 tokens for a contract call on a destination chain.
     * @dev This function is called on the source chain before calling the gateway to execute a remote contract.
     * @param sender The address making the payment
     * @param destinationChain The target chain where the contract call will be made
     * @param destinationAddress The target address on the destination chain
     * @param payload Data payload for the contract call
     * @param gasToken The address of the ERC20 token used to pay for gas
     * @param gasFeeAmount The amount of tokens to pay for gas
     * @param refundAddress The address where refunds, if any, should be sent
     */
    function payGasForContractCall(
        address sender,
        string calldata destinationChain,
        string calldata destinationAddress,
        bytes calldata payload,
        address gasToken,
        uint256 gasFeeAmount,
        address refundAddress
    ) external;

    /**
     * @notice Pay for gas using ERC20 tokens for a contract call with tokens on a destination chain.
     * @dev This function is called on the source chain before calling the gateway to execute a remote contract.
     * @param sender The address making the payment
     * @param destinationChain The target chain where the contract call with tokens will be made
     * @param destinationAddress The target address on the destination chain
     * @param payload Data payload for the contract call with tokens
     * @param symbol The symbol of the token to be sent with the call
     * @param amount The amount of tokens to be sent with the call
     * @param gasToken The address of the ERC20 token used to pay for gas
     * @param gasFeeAmount The amount of tokens to pay for gas
     * @param refundAddress The address where refunds, if any, should be sent
     */
    function payGasForContractCallWithToken(
        address sender,
        string calldata destinationChain,
        string calldata destinationAddress,
        bytes calldata payload,
        string calldata symbol,
        uint256 amount,
        address gasToken,
        uint256 gasFeeAmount,
        address refundAddress
    ) external;

    /**
     * @notice Pay for gas using native currency for a contract call on a destination chain.
     * @dev This function is called on the source chain before calling the gateway to execute a remote contract.
     * @param sender The address making the payment
     * @param destinationChain The target chain where the contract call will be made
     * @param destinationAddress The target address on the destination chain
     * @param payload Data payload for the contract call
     * @param refundAddress The address where refunds, if any, should be sent
     */
    function payNativeGasForContractCall(
        address sender,
        string calldata destinationChain,
        string calldata destinationAddress,
        bytes calldata payload,
        address refundAddress
    ) external payable;

    /**
     * @notice Pay for gas using native currency for a contract call with tokens on a destination chain.
     * @dev This function is called on the source chain before calling the gateway to execute a remote contract.
     * @param sender The address making the payment
     * @param destinationChain The target chain where the contract call with tokens will be made
     * @param destinationAddress The target address on the destination chain
     * @param payload Data payload for the contract call with tokens
     * @param symbol The symbol of the token to be sent with the call
     * @param amount The amount of tokens to be sent with the call
     * @param refundAddress The address where refunds, if any, should be sent
     */
    function payNativeGasForContractCallWithToken(
        address sender,
        string calldata destinationChain,
        string calldata destinationAddress,
        bytes calldata payload,
        string calldata symbol,
        uint256 amount,
        address refundAddress
    ) external payable;

    /**
     * @notice Pay for gas using ERC20 tokens for an express contract call on a destination chain.
     * @dev This function is called on the source chain before calling the gateway to express execute a remote contract.
     * @param sender The address making the payment
     * @param destinationChain The target chain where the contract call will be made
     * @param destinationAddress The target address on the destination chain
     * @param payload Data payload for the contract call
     * @param gasToken The address of the ERC20 token used to pay for gas
     * @param gasFeeAmount The amount of tokens to pay for gas
     * @param refundAddress The address where refunds, if any, should be sent
     */
    function payGasForExpressCall(
        address sender,
        string calldata destinationChain,
        string calldata destinationAddress,
        bytes calldata payload,
        address gasToken,
        uint256 gasFeeAmount,
        address refundAddress
    ) external;

    /**
     * @notice Pay for gas using ERC20 tokens for an express contract call with tokens on a destination chain.
     * @dev This function is called on the source chain before calling the gateway to express execute a remote contract.
     * @param sender The address making the payment
     * @param destinationChain The target chain where the contract call with tokens will be made
     * @param destinationAddress The target address on the destination chain
     * @param payload Data payload for the contract call with tokens
     * @param symbol The symbol of the token to be sent with the call
     * @param amount The amount of tokens to be sent with the call
     * @param gasToken The address of the ERC20 token used to pay for gas
     * @param gasFeeAmount The amount of tokens to pay for gas
     * @param refundAddress The address where refunds, if any, should be sent
     */
    function payGasForExpressCallWithToken(
        address sender,
        string calldata destinationChain,
        string calldata destinationAddress,
        bytes calldata payload,
        string calldata symbol,
        uint256 amount,
        address gasToken,
        uint256 gasFeeAmount,
        address refundAddress
    ) external;

    /**
     * @notice Pay for gas using native currency for an express contract call on a destination chain.
     * @dev This function is called on the source chain before calling the gateway to express execute a remote contract.
     * @param sender The address making the payment
     * @param destinationChain The target chain where the contract call will be made
     * @param destinationAddress The target address on the destination chain
     * @param payload Data payload for the contract call
     * @param refundAddress The address where refunds, if any, should be sent
     */
    function payNativeGasForExpressCall(
        address sender,
        string calldata destinationChain,
        string calldata destinationAddress,
        bytes calldata payload,
        address refundAddress
    ) external payable;

    /**
     * @notice Pay for gas using native currency for an express contract call with tokens on a destination chain.
     * @dev This function is called on the source chain before calling the gateway to express execute a remote contract.
     * @param sender The address making the payment
     * @param destinationChain The target chain where the contract call with tokens will be made
     * @param destinationAddress The target address on the destination chain
     * @param payload Data payload for the contract call with tokens
     * @param symbol The symbol of the token to be sent with the call
     * @param amount The amount of tokens to be sent with the call
     * @param refundAddress The address where refunds, if any, should be sent
     */
    function payNativeGasForExpressCallWithToken(
        address sender,
        string calldata destinationChain,
        string calldata destinationAddress,
        bytes calldata payload,
        string calldata symbol,
        uint256 amount,
        address refundAddress
    ) external payable;

    /**
     * @notice Add additional gas payment using ERC20 tokens after initiating a cross-chain call.
     * @dev This function can be called on the source chain after calling the gateway to execute a remote contract.
     * @param txHash The transaction hash of the cross-chain call
     * @param logIndex The log index for the cross-chain call
     * @param gasToken The ERC20 token address used to add gas
     * @param gasFeeAmount The amount of tokens to add as gas
     * @param refundAddress The address where refunds, if any, should be sent
     */
    function addGas(
        bytes32 txHash,
        uint256 logIndex,
        address gasToken,
        uint256 gasFeeAmount,
        address refundAddress
    ) external;

    /**
     * @notice Add additional gas payment using native currency after initiating a cross-chain call.
     * @dev This function can be called on the source chain after calling the gateway to execute a remote contract.
     * @param txHash The transaction hash of the cross-chain call
     * @param logIndex The log index for the cross-chain call
     * @param refundAddress The address where refunds, if any, should be sent
     */
    function addNativeGas(
        bytes32 txHash,
        uint256 logIndex,
        address refundAddress
    ) external payable;

    /**
     * @notice Add additional gas payment using ERC20 tokens after initiating an express cross-chain call.
     * @dev This function can be called on the source chain after calling the gateway to express execute a remote contract.
     * @param txHash The transaction hash of the cross-chain call
     * @param logIndex The log index for the cross-chain call
     * @param gasToken The ERC20 token address used to add gas
     * @param gasFeeAmount The amount of tokens to add as gas
     * @param refundAddress The address where refunds, if any, should be sent
     */
    function addExpressGas(
        bytes32 txHash,
        uint256 logIndex,
        address gasToken,
        uint256 gasFeeAmount,
        address refundAddress
    ) external;

    /**
     * @notice Add additional gas payment using native currency after initiating an express cross-chain call.
     * @dev This function can be called on the source chain after calling the gateway to express execute a remote contract.
     * @param txHash The transaction hash of the cross-chain call
     * @param logIndex The log index for the cross-chain call
     * @param refundAddress The address where refunds, if any, should be sent
     */
    function addNativeExpressGas(
        bytes32 txHash,
        uint256 logIndex,
        address refundAddress
    ) external payable;

    /**
     * @notice Allows the gasCollector to collect accumulated fees from the contract.
     * @dev Use address(0) as the token address for native currency.
     * @param receiver The address to receive the collected fees
     * @param tokens Array of token addresses to be collected
     * @param amounts Array of amounts to be collected for each respective token address
     */
    function collectFees(
        address payable receiver,
        address[] calldata tokens,
        uint256[] calldata amounts
    ) external;

    /**
     * @notice Refunds gas payment to the receiver in relation to a specific cross-chain transaction.
     * @dev Only callable by the gasCollector.
     * @dev Use address(0) as the token address to refund native currency.
     * @param txHash The transaction hash of the cross-chain call
     * @param logIndex The log index for the cross-chain call
     * @param receiver The address to receive the refund
     * @param token The token address to be refunded
     * @param amount The amount to refund
     */
    function refund(
        bytes32 txHash,
        uint256 logIndex,
        address payable receiver,
        address token,
        uint256 amount
    ) external;

    /**
     * @notice Returns the address of the designated gas collector.
     * @return address of the gas collector
     */
    function gasCollector() external returns (address);
}

// File: @axelar-network/axelar-gmp-sdk-solidity/contracts/libs/AddressString.sol



pragma solidity ^0.8.0;

library StringToAddress {
    error InvalidAddressString();

    function toAddress(string memory addressString) internal pure returns (address) {
        bytes memory stringBytes = bytes(addressString);
        uint160 addressNumber = 0;
        uint8 stringByte;

        if (stringBytes.length != 42 || stringBytes[0] != '0' || stringBytes[1] != 'x') revert InvalidAddressString();

        for (uint256 i = 2; i < 42; ++i) {
            stringByte = uint8(stringBytes[i]);

            if ((stringByte >= 97) && (stringByte <= 102)) stringByte -= 87;
            else if ((stringByte >= 65) && (stringByte <= 70)) stringByte -= 55;
            else if ((stringByte >= 48) && (stringByte <= 57)) stringByte -= 48;
            else revert InvalidAddressString();

            addressNumber |= uint160(uint256(stringByte) << ((41 - i) << 2));
        }

        return address(addressNumber);
    }
}

library AddressToString {
    function toString(address address_) internal pure returns (string memory) {
        bytes memory addressBytes = abi.encodePacked(address_);
        bytes memory characters = '0123456789abcdef';
        bytes memory stringBytes = new bytes(42);

        stringBytes[0] = '0';
        stringBytes[1] = 'x';

        for (uint256 i; i < 20; ++i) {
            stringBytes[2 + i * 2] = characters[uint8(addressBytes[i] >> 4)];
            stringBytes[3 + i * 2] = characters[uint8(addressBytes[i] & 0x0f)];
        }

        return string(stringBytes);
    }
}

// File: @axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IGovernable.sol



pragma solidity ^0.8.0;

/**
 * @title IGovernable Interface
 * @notice This is an interface used by the AxelarGateway contract to manage governance and mint limiter roles.
 */
interface IGovernable {
    error NotGovernance();
    error NotMintLimiter();
    error InvalidGovernance();
    error InvalidMintLimiter();

    event GovernanceTransferred(address indexed previousGovernance, address indexed newGovernance);
    event MintLimiterTransferred(address indexed previousGovernance, address indexed newGovernance);

    /**
     * @notice Returns the governance address.
     * @return address of the governance
     */
    function governance() external view returns (address);

    /**
     * @notice Returns the mint limiter address.
     * @return address of the mint limiter
     */
    function mintLimiter() external view returns (address);

    /**
     * @notice Transfer the governance role to another address.
     * @param newGovernance The new governance address
     */
    function transferGovernance(address newGovernance) external;

    /**
     * @notice Transfer the mint limiter role to another address.
     * @param newGovernance The new mint limiter address
     */
    function transferMintLimiter(address newGovernance) external;
}

// File: @axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol



pragma solidity ^0.8.0;


interface IAxelarGateway is IGovernable {
    /**********\
    |* Errors *|
    \**********/

    error NotSelf();
    error NotProxy();
    error InvalidCodeHash();
    error SetupFailed();
    error InvalidAuthModule();
    error InvalidTokenDeployer();
    error InvalidAmount();
    error InvalidChainId();
    error InvalidCommands();
    error TokenDoesNotExist(string symbol);
    error TokenAlreadyExists(string symbol);
    error TokenDeployFailed(string symbol);
    error TokenContractDoesNotExist(address token);
    error BurnFailed(string symbol);
    error MintFailed(string symbol);
    error InvalidSetMintLimitsParams();
    error ExceedMintLimit(string symbol);

    /**********\
    |* Events *|
    \**********/

    event TokenSent(
        address indexed sender,
        string destinationChain,
        string destinationAddress,
        string symbol,
        uint256 amount
    );

    event ContractCall(
        address indexed sender,
        string destinationChain,
        string destinationContractAddress,
        bytes32 indexed payloadHash,
        bytes payload
    );

    event ContractCallWithToken(
        address indexed sender,
        string destinationChain,
        string destinationContractAddress,
        bytes32 indexed payloadHash,
        bytes payload,
        string symbol,
        uint256 amount
    );

    event Executed(bytes32 indexed commandId);

    event TokenDeployed(string symbol, address tokenAddresses);

    event ContractCallApproved(
        bytes32 indexed commandId,
        string sourceChain,
        string sourceAddress,
        address indexed contractAddress,
        bytes32 indexed payloadHash,
        bytes32 sourceTxHash,
        uint256 sourceEventIndex
    );

    event ContractCallApprovedWithMint(
        bytes32 indexed commandId,
        string sourceChain,
        string sourceAddress,
        address indexed contractAddress,
        bytes32 indexed payloadHash,
        string symbol,
        uint256 amount,
        bytes32 sourceTxHash,
        uint256 sourceEventIndex
    );

    event TokenMintLimitUpdated(string symbol, uint256 limit);

    event OperatorshipTransferred(bytes newOperatorsData);

    event Upgraded(address indexed implementation);

    /********************\
    |* Public Functions *|
    \********************/

    function sendToken(
        string calldata destinationChain,
        string calldata destinationAddress,
        string calldata symbol,
        uint256 amount
    ) external;

    function callContract(
        string calldata destinationChain,
        string calldata contractAddress,
        bytes calldata payload
    ) external;

    function callContractWithToken(
        string calldata destinationChain,
        string calldata contractAddress,
        bytes calldata payload,
        string calldata symbol,
        uint256 amount
    ) external;

    function isContractCallApproved(
        bytes32 commandId,
        string calldata sourceChain,
        string calldata sourceAddress,
        address contractAddress,
        bytes32 payloadHash
    ) external view returns (bool);

    function isContractCallAndMintApproved(
        bytes32 commandId,
        string calldata sourceChain,
        string calldata sourceAddress,
        address contractAddress,
        bytes32 payloadHash,
        string calldata symbol,
        uint256 amount
    ) external view returns (bool);

    function validateContractCall(
        bytes32 commandId,
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes32 payloadHash
    ) external returns (bool);

    function validateContractCallAndMint(
        bytes32 commandId,
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes32 payloadHash,
        string calldata symbol,
        uint256 amount
    ) external returns (bool);

    /***********\
    |* Getters *|
    \***********/

    function authModule() external view returns (address);

    function tokenDeployer() external view returns (address);

    function tokenMintLimit(string memory symbol) external view returns (uint256);

    function tokenMintAmount(string memory symbol) external view returns (uint256);

    function allTokensFrozen() external view returns (bool);

    function implementation() external view returns (address);

    function tokenAddresses(string memory symbol) external view returns (address);

    function tokenFrozen(string memory symbol) external view returns (bool);

    function isCommandExecuted(bytes32 commandId) external view returns (bool);

    function adminEpoch() external view returns (uint256);

    function adminThreshold(uint256 epoch) external view returns (uint256);

    function admins(uint256 epoch) external view returns (address[] memory);

    /*******************\
    |* Admin Functions *|
    \*******************/

    function setTokenMintLimits(string[] calldata symbols, uint256[] calldata limits) external;

    function upgrade(
        address newImplementation,
        bytes32 newImplementationCodeHash,
        bytes calldata setupParams
    ) external;

    /**********************\
    |* External Functions *|
    \**********************/

    function setup(bytes calldata params) external;

    function execute(bytes calldata input) external;
}

// File: @axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarExecutable.sol



pragma solidity ^0.8.0;


interface IAxelarExecutable {
    error InvalidAddress();
    error NotApprovedByGateway();

    function gateway() external view returns (IAxelarGateway);

    function execute(
        bytes32 commandId,
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload
    ) external;

    function executeWithToken(
        bytes32 commandId,
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload,
        string calldata tokenSymbol,
        uint256 amount
    ) external;
}

// File: @axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol



pragma solidity ^0.8.0;



contract AxelarExecutable is IAxelarExecutable {
    IAxelarGateway public immutable gateway;

    constructor(address gateway_) {
        if (gateway_ == address(0)) revert InvalidAddress();

        gateway = IAxelarGateway(gateway_);
    }

    function execute(
        bytes32 commandId,
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload
    ) external {
        bytes32 payloadHash = keccak256(payload);

        if (!gateway.validateContractCall(commandId, sourceChain, sourceAddress, payloadHash))
            revert NotApprovedByGateway();

        _execute(sourceChain, sourceAddress, payload);
    }

    function executeWithToken(
        bytes32 commandId,
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload,
        string calldata tokenSymbol,
        uint256 amount
    ) external {
        bytes32 payloadHash = keccak256(payload);

        if (
            !gateway.validateContractCallAndMint(
                commandId,
                sourceChain,
                sourceAddress,
                payloadHash,
                tokenSymbol,
                amount
            )
        ) revert NotApprovedByGateway();

        _executeWithToken(sourceChain, sourceAddress, payload, tokenSymbol, amount);
    }

    function _execute(
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload
    ) internal virtual {}

    function _executeWithToken(
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload,
        string calldata tokenSymbol,
        uint256 amount
    ) internal virtual {}
}

// File: contracts/core/KualaBondReciever.sol


pragma solidity ^0.8.20;














contract KualaBondReciever is AxelarExecutable, IKualaBondTeleportReciever, IVersion  { 

    string constant vname = "KUALA_BOND_RECIEVER"; 
    uint256 constant version = 3;  


    string constant KUALA_BOND_ADMIN_CA = "KUALA_BOND_ADMIN";
    string constant KUALA_BOND_REGISTER_CA = "KUALA_BOND_REGISTER";
    string constant KUALA_BOND_CONTRACT_ADMIN_CA = "KUALA_BOND_ADMIN"; 
    string constant AXELAR_GAS_SERVICE_CA = "AXELAR_GAS_SERVICE";
    string constant KB_SYNTHETIC_FACTORY_CA = "KB_SYNTHETIC_FACTORY";
    string constant KB_ROUTING_REGISTRY_CA = "KB_ROUTING_REGISTRY";

    using StringToAddress for string;
    using AddressToString for address;

    address self; 
    uint256 index; 

    uint256 chainId; 
    IOpsRegister register;
    IKualaBondRegister iKBRegister; 
    IKBSyntheticFactory syntheticBondContractFactory; 
    IKBRoutingRegistry routingRegistry; 

    IAxelarGasService public immutable gasService;


    uint256 [] registeredKualaBondIds; 
    mapping(uint256=>RegisteredKualaBond) registeredKualaBondById; 
    mapping(uint256=>CompressedTeleportDescriptor) compressedTeleportById; 

    constructor(address _register, uint256 _chainId, address _gateway) AxelarExecutable(_gateway) {
        register = IOpsRegister(_register);
        gasService = IAxelarGasService(register.getAddress(AXELAR_GAS_SERVICE_CA));
        initialize();
        chainId = _chainId; 
        self = address(this);
    } 

    function getVName() pure  external returns (string memory _name){
        return vname; 
    }

    function getVVersion() pure external returns (uint256 _version){
        return version; 
    }

    function getRecievedBonds() view external returns (RegisteredKualaBond [] memory _rBonds) {
        _rBonds = new RegisteredKualaBond[](registeredKualaBondIds.length);
        for(uint256 x = 0; x < registeredKualaBondIds.length; x++) {
            _rBonds[x] = registeredKualaBondById[registeredKualaBondIds[x]];
        }
        return _rBonds; 
    }

    function notifyChangeOfAddress() external returns (bool _recieved) {
        require(msg.sender == register.getAddress(KUALA_BOND_ADMIN_CA),"admin only");
        initialize(); 
        return true; 
    }

    //=============================================== INTERNAL ==========================================================================

    function initialize() internal {
        iKBRegister = IKualaBondRegister(register.getAddress(KUALA_BOND_REGISTER_CA));
        
        syntheticBondContractFactory = IKBSyntheticFactory(register.getAddress(KB_SYNTHETIC_FACTORY_CA));
        routingRegistry = IKBRoutingRegistry(register.getAddress(KB_ROUTING_REGISTRY_CA));
    }

    function _execute( string calldata _srcChain, /*sourceChain*/  string calldata sourceAddress, bytes calldata payload) internal override {
        require(routingRegistry.isSupportedAxelarChainName(_srcChain), string.concat("un-supported chain",_srcChain));
        require(routingRegistry.isKnownRemoteAddress(sourceAddress.toAddress()), string.concat("unknown remote address",sourceAddress));

        (
        uint256 originChain_, 
        address bondContract_, 
        uint256[5] memory a, 
        string memory token_, 
        string memory symbol_, 
        address tokenContract_,
        address owner_, 
        uint256 action_) = abi.decode(payload, (uint256, address, uint256[5] , string, string, address, address, uint256));

        uint256 teleportId_ = getIndex();
        ERC20 memory erc20_ = ERC20({
                                        name : token_, 
                                        symbol : symbol_,
                                        token : tokenContract_, 
                                        chainId : originChain_  
                                    });
        KualaBond memory bond_ = KualaBond({
                                                id : a[0], 
                                                bondType : BondType.NATURAL,  
                                                erc20  : erc20_,
                                                sourceChain : originChain_, 
                                                createDate : a[1],
                                                bondContract : bondContract_,  
                                                amount : a[3],
                                                status : BondStatus.ISSUED
                                            });                                                                                              
        compressedTeleportById[teleportId_] = CompressedTeleportDescriptor({
                                                                    teleportId : teleportId_,
                                                                    bond : bond_, 
                                                                    srcChainRegistrationId : a[2],
                                                                    owner : owner_,
                                                                    vaultId : a[4]
                                                                });
        if(action_ == uint256(TeleportAction.MATERIALIZE)) {
            materialise(compressedTeleportById[teleportId_]);
        }
        if(action_ == uint256(TeleportAction.SETTLE)) {
            settle(compressedTeleportById[teleportId_]);
        }
    }

    function settle(CompressedTeleportDescriptor memory _tDescriptor) internal { 
        // return funds 
        require(_tDescriptor.bond.sourceChain == chainId, "chain id mis-match");
    }


    function materialise(CompressedTeleportDescriptor memory _tDescriptor) internal {
        require(_tDescriptor.bond.sourceChain != chainId, "cannot materialise on home chain");
        address [] memory localChainBondContracts = iKBRegister.findBondContracts(_tDescriptor.bond.erc20.token, _tDescriptor.bond.erc20.chainId);
        IKualaBondSyntheticContract sBondContract;
        if(localChainBondContracts.length > 0){
            sBondContract = IKualaBondSyntheticContract(localChainBondContracts[0]);
            
        }
        else { 
            string memory name_ = string.concat("KUALA BOND SYNTHETIC FOR ", _tDescriptor.bond.erc20.name); 
            string memory symbol_ = string.concat("KB", _tDescriptor.bond.erc20.symbol);
            BondConfiguration memory bc_ = BondConfiguration({
                                                                            chainId  : _tDescriptor.bond.sourceChain,
                                                                            erc20 : _tDescriptor.bond.erc20,  
                                                                            bondType : BondType.SYNTHETIC 
            });
            sBondContract = IKualaBondSyntheticContract(syntheticBondContractFactory.getKualaBondSyntheticContract(name_, symbol_, bc_));
        }
        KualaBond memory reBond_ = sBondContract.reIssueKualaBond(_tDescriptor.bond, _tDescriptor.vaultId);
        RegisteredKualaBond memory rBond_ = iKBRegister.registerBond(reBond_);
        registeredKualaBondIds.push(rBond_.registrationId); 
        registeredKualaBondById[rBond_.registrationId] = rBond_; 
        IERC721 erc721 = IERC721(address(sBondContract)); 
        erc721.transferFrom(self, _tDescriptor.owner, reBond_.id);
    }


    function getIndex() internal returns (uint256 _index) {
        _index = index++; 
        return _index; 
    }


}