(async () => {
    try {
   
    const account = '0x5B38Da6a701c568545dCfcB03FcB875f56beddC4'
    const contractName = 'Owner';
    const contractAddress = '0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8';
    console.log('Getting Current Owner address..');

    const artifactsPath = `browser/contracts/artifacts/${contractName}.json`;
    const metadata = JSON.parse(await remix.call('fileManager', 'getFile', artifactsPath));
    const accounts = await web3.eth.getAccounts();

    let contract = new web3.eth.Contract(metadata.abi,contractAddress);

    const result = await  contract.methods.getOwner().call({from:account});

    console.log(`Current Owner's Address`,result);

    }catch(e){
        console.log(e.message);
    }
})()

//Output - 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4