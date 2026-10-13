// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title AgentSafetyGate
/// @notice Onchain policy gate for autonomous agent payments on Monad.
/// @dev MVP: 0-value intent + cap/allowlist enforcement. The owner sets a
/// per-payment cap and an allowlist; agents propose intents, and execute()
/// enforces both or reverts. Mirrors the offchain PreTxSim firewall thesis.
contract AgentSafetyGate {
    address public owner;
    uint256 public maxPayment;
    mapping(address => bool) public allowlisted;
    uint256 public proposalCount;

    struct Proposal {
        address payer;
        address payee;
        uint256 amount;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;

    event Proposed(uint256 indexed id, address indexed payer, address indexed payee, uint256 amount);
    event Executed(uint256 indexed id, address indexed payee, uint256 amount);
    event Rejected(uint256 indexed id, string reason);

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor(address _owner, uint256 _maxPayment) {
        owner = _owner;
        maxPayment = _maxPayment;
    }

    function allow(address p, bool v) external onlyOwner {
        allowlisted[p] = v;
    }

    function setCap(uint256 c) external onlyOwner {
        maxPayment = c;
    }

    function propose(address payee, uint256 amount) external returns (uint256 id) {
        id = proposalCount++;
        proposals[id] = Proposal(msg.sender, payee, amount, false);
        emit Proposed(id, msg.sender, payee, amount);
    }

    function execute(uint256 id) external payable {
        Proposal storage p = proposals[id];
        require(!p.executed, "settled");
        if (p.amount > maxPayment) {
            emit Rejected(id, "over cap");
            revert("over cap");
        }
        if (!allowlisted[p.payee]) {
            emit Rejected(id, "payee not allowlisted");
            revert("not allowlisted");
        }
        p.executed = true;
        (bool ok, ) = p.payee.call{value: p.amount}("");
        require(ok, "transfer failed");
        emit Executed(id, p.payee, p.amount);
    }
}
