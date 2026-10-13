# PreTxSim on Monad — Pre-Flight Simulation Firewall

**Monad Metropolis · Track: Trust, Identity & AI Infrastructure**

A local Rust/revm firewall that rehearses every transaction against live
Monad state before signing — plus an onchain policy gate proving the same
thesis on-ledger.

## ⛓️ Live on Monad Testnet (chain ID 10143)

Gate contract
[`0xc62158d762345d0ea2d5b442Ea5c04Abf4D54743`](https://testnet.monadexplorer.com/address/0xc62158d762345d0ea2d5b442Ea5c04Abf4D54743)
(`contracts/AgentSafetyGate.sol`): in-policy execution succeeds onchain,
over-cap and non-allowlisted payments revert onchain. Full proof table with
tx hashes: [README_MONAD.md](README_MONAD.md).

**Narrated demo (2:14):** [`docs/assets/demo-monad.mp4`](docs/assets/demo-monad.mp4)

## Run it

```bash
cargo run -- --chain monad --sim-file examples/monad_tx_batch.json --ai-brief
```

## Docs

| Doc | What |
| --- | --- |
| [README_MONAD.md](README_MONAD.md) | Full guide: benchmarks, bounties, track fit |
| [SUBMISSION_MONAD.md](SUBMISSION_MONAD.md) | Submission summary for judges |
| [demo_runbook.md](demo_runbook.md) | Evaluator setup (docker, CI mode) |
| [contracts/](contracts/) | `AgentSafetyGate.sol` source (deployed, verified above) |

Target bounties: **Perpl** (risk tool) · **MetaMask** (agent wallet plugin) · **Alchemy/Dynamic** (RPC + state inspection).
