pragma solidity ^0.6.4;
contract cointoss_simple {

    enum stage { invalid, commit1, commit2, reveal1, reveal2}

    modifier atStage(stage s){
        require(currentStage == s, "Stage is not what it is supposed to be");
        _;
    }

    function nextStage() internal {
        currentStage = stage(uint(currentStage) + 1);
    }

    modifier costs(uint cost) {
        require(msg.value == cost, "Insufficient funds");
        _;
    }

    // Real logic starts here
    stage currentStage = stage.commit1;

    address payable player1;
    bytes32 commitment1;
    address payable player2;
    bytes32 commitment2;
    uint value1;
    event Stage(stage s);


    // use via call only...
    function generateCommit(uint v, uint rand) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(v, rand));
    }

    function commit1(bytes32 _commit) public payable atStage(stage.commit1) costs(1 ether)   {
        commitment1 = _commit;
        player1 = msg.sender;
        nextStage();
    }

    function commit2(bytes32 _commit) public payable atStage(stage.commit2) costs(1 ether)  {
        commitment2 = _commit;
        player2 = msg.sender;
        nextStage();
    }

    function reveal1(uint v, uint rand) public atStage(stage.reveal1)  {
        require(keccak256(abi.encodePacked(v, rand))==commitment1, "there was an error");
        value1 = v;
        nextStage();
    }

    function reveal2(uint v, uint rand) public atStage(stage.reveal2) returns (uint) {
        require(keccak256(abi.encodePacked(v, rand))==commitment2, "there was an error");
        return rewardWinner(value1, v);
    }

    function rewardWinner(uint _v1, uint _v2) internal returns (uint) {
        uint parity = (_v1 + _v2) % 2;
        if(parity == 1){
            player2.transfer(2 ether);
        } else if (parity == 0) {
            player1.transfer(2 ether);
        }
        return 1+parity;
    }
}