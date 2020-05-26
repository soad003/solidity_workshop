pragma solidity ^0.6.4;
contract cointoss {
    enum stage {invalid, commit, open, done}
    stage cs = stage.commit;

    // Game Setup
   
    function commit(bytes32 _commitment) public atStage(stage.commit) costs(1 ether) payable {
    }

    function open(uint v, uint rand) public atStage(stage.open) {
    
    }

    function claimWin() public atStage(stage.done) {

    }

    // Hilfs Funktionen
    modifier atStage(stage s){
        require(cs == s, "Wrong stage.");
        _;
    }

    modifier costs(uint c){
        require(msg.value == c, "Cost contraint not satisfied.");
        _;
    }

    function nextStage() internal { cs = stage(uint(cs) + 1);}

    // use via call only...
    function generateCommit(uint v, uint rand) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(v, rand));
    }
}
