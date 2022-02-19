const ethers = require('ethers')

let convertToBytes = ethers.utils.formatBytes32String("random");

console.log(convertToBytes);
