// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/utils/Counters.sol";

contract OxNFT is ERC721("0xSupper", "RICHgang") {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    function mintNFT() public {
        _tokenIds.increment();
        _mint(msg.sender, _tokenIds.current());
    }

    function tokenURI(uint _Id) public view override returns (string memory) {
        require(_exists(_Id));
        return string(abi.encodePacked(
            'data:application/json;base64,',
            base64(bytes(abi.encodePacked('{',
                '"name": "The First 0xSupper",'
                '"external_url": "https://par.tf/XgFK",'
                '"description": "You have made this far... now how do you RSVP?",'
                '"image": "ipfs://QmfYMc8z5yfUPp6uubwDS1r3xnCeEvPsJCpLDsdttcS1LX"',
            '}')))
        )); 
    }

    string public constant TABLE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

    function base64(bytes memory data) public pure returns (string memory) {
        if (data.length == 0) return '';
        
        // load the table into memory
        string memory table = TABLE;

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((data.length + 2) / 3);

        // add some extra buffer at the end required for the writing
        string memory result = new string(encodedLen + 32);

        assembly {
        // set the actual output length
        mstore(result, encodedLen)
        
        // prepare the lookup table
        let tablePtr := add(table, 1)
        
        // input ptr
        let dataPtr := data
        let endPtr := add(dataPtr, mload(data))
        
        // result ptr, jump over length
        let resultPtr := add(result, 32)
        
        // run over the input, 3 bytes at a time
        for {} lt(dataPtr, endPtr) {}
        {
            dataPtr := add(dataPtr, 3)
            
            // read 3 bytes
            let input := mload(dataPtr)
            
            // write 4 characters
            mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F)))))
            resultPtr := add(resultPtr, 1)
            mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F)))))
            resultPtr := add(resultPtr, 1)
            mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr( 6, input), 0x3F)))))
            resultPtr := add(resultPtr, 1)
            mstore(resultPtr, shl(248, mload(add(tablePtr, and(        input,  0x3F)))))
            resultPtr := add(resultPtr, 1)
        }
        
        // padding with '='
        switch mod(mload(data), 3)
        case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
        case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
        }
        
        return result;
    }
}
