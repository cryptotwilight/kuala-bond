// SPDX-License-Identifier: MIT
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
// File: contracts/interfaces/IKBVault.sol


pragma solidity ^0.8.20;


interface IKBVault {

    function getIssuedVaultIds() view external returns (uint256 [] memory _ids);

    function getKualaBond(uint256 _bondId) view external returns (RegisteredKualaBond memory _kualaBond);

    function commitBond(RegisteredKualaBond memory _kualaBond) external payable returns (uint256 _vaultId);

    function releaseBond(uint256 _vaultId) external returns (RegisteredKualaBond memory _kualaBond);

}
// File: contracts/interfaces/IVersion.sol


pragma solidity ^0.8.20;

interface IVersion { 
    
    function getVName() view external returns (string memory _name);

    function getVVersion() view external returns (uint256 _version);

}
// File: contracts/interfaces/IOpsRegister.sol


pragma solidity ^0.8.20;

interface IOpsRegister { 

    function getAddress(string memory _name) view external returns (address _address);

    function getName(address _address) view external returns (string memory _name);

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

// File: contracts/core/KualaBondVault.sol


pragma solidity ^0.8.20;





struct VaultStats {
    uint256 bondCount;
    uint256 totalValue; 
}


contract KualaBondVault is IKBVault, IVersion {

    string constant name = "KB_VAULT";
    uint256 constant version = 1; 

    IOpsRegister register; 
    uint256 index; 
    address self; 

    string constant KUALA_BOND_ADMIN_CA = "KUALA_BOND_ADMIN";
    string constant KUALA_BOND_TELEPORTER_CA = "KUALA_BOND_TELEPORTER";
    string constant KUALA_BOND_RECIEVER_CA = "KUALA_BOND_RECIEVER";
    
    uint256 [] ids;
    mapping(uint256=>RegisteredKualaBond) kualaBondByVaultId;

    constructor(address _opsRegistry) {
        register = IOpsRegister(_opsRegistry);
        self = address(this);
    }

   function getVName() pure  external returns (string memory _name){
        return name; 
    }

    function getVVersion() pure external returns (uint256 _version){
        return version; 
    }

    function getVaultStats() view external returns (VaultStats memory  _vaultStats){
        uint256 totalValue_ = 0;
        for(uint256 x = 0; x < ids.length; x++) {
            totalValue_ += kualaBondByVaultId[x].bond.amount; 
        }
        _vaultStats = VaultStats({
                                    bondCount : ids.length,
                                    totalValue : totalValue_
                                });
        return _vaultStats;
    }

    function getIssuedVaultIds() view external returns (uint256 [] memory _ids){
        return ids; 
    }

    function getKualaBond(uint256 _bondId) view external returns (RegisteredKualaBond memory _kualaBond){
        return kualaBondByVaultId[_bondId];
    }

    function commitBond(RegisteredKualaBond memory _kualaBond) external payable returns (uint256 _vaultId){
        require(msg.sender == register.getAddress(KUALA_BOND_TELEPORTER_CA)
        || msg.sender == register.getAddress(KUALA_BOND_ADMIN_CA),"authorised only");
        IERC721 bondContract_ = IERC721(_kualaBond.bond.bondContract);
        bondContract_.transferFrom(msg.sender, self, _kualaBond.bond.id);
        _vaultId = getIndex(); 
        ids.push(_vaultId);
        kualaBondByVaultId[_vaultId] = _kualaBond;
        return _vaultId; 
    }

    function releaseBond(uint256 _vaultId) external returns (RegisteredKualaBond memory _kualaBond){
         require(msg.sender == register.getAddress(KUALA_BOND_RECIEVER_CA)
         || msg.sender == register.getAddress(KUALA_BOND_ADMIN_CA),"authorised only");
        RegisteredKualaBond memory kualaBond_ = kualaBondByVaultId[_vaultId];
        IERC721 bondContract_ = IERC721(kualaBond_.bond.bondContract);
        bondContract_.transferFrom(self, msg.sender, kualaBond_.bond.id);
        return kualaBond_;
    }

    //=============================================== INTERNAL =============================================================

    function getIndex() internal returns (uint256 _index) {
        _index = index++;
        return _index; 
    }
}