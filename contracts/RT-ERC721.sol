// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import '@openzeppelin/contracts/access/AccessControlEnumerable.sol';
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import '@openzeppelin/contracts/access/AccessControl.sol';
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//import "hardhat/console.sol";

/// @title  Extended ERC721Enumerable contract for the Rapid Title system
/// @notice Uses ERC2981 and ERC165 for standard royalty info
/// @notice Uses AccessControl for the minting mechanisms
/// @author Mario Sergio Ayerve Estrella.
contract RT_ERC721 is ERC165, ERC721Enumerable, AccessControlEnumerable {
    using Strings for uint;
    
    address receiverAddr;
    string private _baseURIextended;
    string public baseExtension = ".json";
    uint256 lastTokenId;
    event MintFinished(address to, uint256 _tokenId);

    struct titles {
		uint title_id;
		uint vehicle_id;
		uint buyer_id;
		uint seller_id;
        bool status;
	}

    struct behicles {
		uint vehicle_id;
		string vin;
		uint stockNo;
		string make;
        string vehicleType;
        string trim;
        string color;
        bool is_registered;
        string reg_state;
        bool has_license;
        uint lender_id;
	}

    /**
     * @notice Initializer
     */
    constructor() ERC721("Rapid Title", "RT") {
        __ERC721_init("RT-ERC721", "RT-ERC721");
    }

    /**
     * @notice A method to set baseURI with new one.
     * @param baseURI_ new baseURI.
     */
    function setBaseURI(string memory baseURI_) external onlyOwner {
        _baseURIextended = baseURI_;
    }

    /**
     * @notice An overrride function to get the baseURI.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    }

    /**
     * @notice tokenURI overrride function.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721URIStorage: URI query for nonexistent token"
        );
        string memory __baseURI;
        __baseURI = _baseURI();
        // Concatenate the unrevealBaseURI and tokenId (via abi.encodePacked).
        return
            bytes(__baseURI).length > 0
                ? string(abi.encodePacked(__baseURI, tokenId, baseExtension))
                : "";
    }

    /**
     * @notice _burn internal overrride function.
     */
    function _burn(uint256 tokenId)
        internal
    {
        super._burn(tokenId);
    }

    /**
     * @notice _beforeTokenTransfer internal overrride function.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    /**
     * @notice supportsInterface overrride function.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /**
     * @notice A method to allow for user to mint after pay ABC.
     * @param _to the address of receiver to get minted.
     * @param _tokenAmount the amount of ABC.
     */
    function mintTitle(address _to) public {
        uint256 _id = nextTokenId();
        _safeMint(_to, _id, "");
        incrementTokenId();

        emit MintFinished(_to, _id);
    }

    /**
     * @return The list of all tokens enumerated.
     */
    function getAllTokensList() public view returns (uint256[] memory) {
        uint256[] memory _tokensList = new uint256[](
            ERC721EnumerableUpgradeable.totalSupply()
        );
        uint256 i;

        for (i = 0; i < ERC721EnumerableUpgradeable.totalSupply(); i++) {
            _tokensList[i] = ERC721EnumerableUpgradeable.tokenByIndex(i);
        }
        return (_tokensList);
    }

    /**
     * @notice A method to get the list of all tokens owned by any user.
     * @param _owner the owner address.
     * @return The list of tokens owned by any user.
     */
    function getTokensListOwnedByUser(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256[] memory _tokensOfOwner = new uint256[](
            _onwer.balanceOf(_owner)
        );
        uint256 i;

        for (i = 0; i < _owner.balanceOf(_owner); i++) {
            _tokensOfOwner[i] = _owner.tokenOfOwnerByIndex(
                _owner,
                i
            );
        }
        return (_tokensOfOwner);
    }

    function nextTokenId() public view returns (uint256) {
        return lastTokenId + 1;
    }

    function incrementTokenId() internal {
        lastTokenId++;
    }

    /*
    *  @notice get totalABCAmount 
    */
    function getTotalABCAmount() public view returns (uint256) {
        return totalABCAmount;
    }

    /**
     * @notice get the Last token id.
     */
    function getLastTokenId() public view returns (uint256) {
        return lastTokenId;
    }

    function setReceiverAddr(address _receiverAddr) public {
        receiverAddr = _receiverAddr;
    }

    function getReceiverAddr() public view returns (address) {
        return receiverAddr;
    }
}
