const buildcollective = artifacts.require('BuildCollective');

contract('BuildCollective',function(accounts) {
let buildcont=null;
before(async() => { buildcont = await buildcollective.deployed();});

it('Should create exchange ethers', async () => {
   // var ad = await accounts[0];
    //console.log(ad);
   //sconsole.log(accounts[1]);
    await buildcont.sendEther(accounts[1]);
    //console.log(u);
    //assert(u.username === 'Wassim');
} );
});