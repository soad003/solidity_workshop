pragma solidity ^0.6.4;
contract cointoss {
    enum stage {invalid, commit, reveal, done}
    stage cs = stage.commit;

    // Game Setup
    uint8 constant MAX_PLAYER = 2;
    uint constant BUY_IN = 1 ether;

    // Real logic starts here
    struct PlayerCR {
        bytes32 commitment;
        address payable addr;
        uint value;
    }

    mapping(address => uint) addr_to_id;
    PlayerCR[MAX_PLAYER] participants;
    uint8 player_index = 0;

    function commit(bytes32 _commitment) public atStage(stage.commit) payable {
        require(msg.value == BUY_IN, "no no no, give me money");
        require(_commitment != 0, "really zero hash as a commitment?");

        addr_to_id[msg.sender] = player_index;
        PlayerCR storage current = participants[player_index];
        current.commitment = _commitment;
        current.addr = msg.sender;

        if(player_index >= (MAX_PLAYER - 1)) {nextStage();} else {player_index += 1;}
    }

    function open(uint v, uint rand) public atStage(stage.reveal) {
        PlayerCR storage current = participants[addr_to_id[msg.sender]];
        require(generateCommit(v, rand)==current.commitment, "you not know");
        current.value = v;
        if(all_values_revealed()) nextStage();
    }

    function claimWin() public atStage(stage.done) {
        uint parity = sum_values() % MAX_PLAYER;
        participants[parity].addr.transfer(BUY_IN * MAX_PLAYER);
    }

    // Hilfs Funktionen
    modifier atStage(stage s){
        require(cs == s, "wrong stage");
        _;
    }

    function nextStage() internal { cs = stage(uint(cs) + 1); player_index = 0;}

    // use via call only...
    function generateCommit(uint v, uint rand) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(v, rand));
    }


    /*
        We set commitment to 0 once a value is set.
    */
    function all_values_revealed() private view returns(bool){
        bool res = true;
        for(uint i = 0; i < MAX_PLAYER; i++) {
            res = res && (participants[i].commitment == 0);
        }
        return res;
    }

    function sum_values() private view returns(uint){
        uint res = 0;
        for(uint i = 0; i < MAX_PLAYER; i++) {
            res += participants[i].value;
        }
        return res;
    }

}
