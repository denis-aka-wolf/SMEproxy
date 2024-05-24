// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

/**
* @dev FREE function для работы с версиями библиотек, модулей, функций
*/

/// @dev Encode a feature version as a `uint256`.
/// @param major The major version number of the feature.
/// @param minor The minor version number of the feature.
/// @param revision The revision number of the feature.
/// @return encodedVersion The encoded version number.
function _encodeVersion(uint32 major, uint32 minor, uint32 revision) pure returns (uint256 encodedVersion){
    return (uint256(major) << 64) | (uint256(minor) << 32) | uint256(revision);
}