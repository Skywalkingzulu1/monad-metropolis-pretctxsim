# Submission — Monad Metropolis (Trust, Identity & AI Infrastructure)

## Project
**PreTxSim** — high-throughput pre-flight simulation firewall for parallel
EVM execution. Repo: `pretxsim_poc` (this repository).

## What it does
A local Rust/revm proxy that rehearses every transaction against live Monad
state before signing: net balance deltas, gas bounds, and structural risk
flags (delegatecalls, selfdestructs, storage blowouts, allowance changes,
EIP-7702 delegations). Batch mode fans checks out concurrently, matching
Monad's parallel-execution thesis on the verification side.

## How to run (judges)
```bash
cargo run -- --chain monad --sim-file tx_payload.json --ai-brief
```
Full guide: [README_MONAD.md](README_MONAD.md). Every run prints per-tx
`elapsed_ms` — quote the tool's own numbers.

## Why it fits the track
- **Trust:** deterministic structural checks + optional local-LLM brief;
  nothing leaves the machine (zero outbound telemetry).
- **AI infrastructure:** the firewall between an autonomous agent wallet's
  intent and irreversible execution; skill-based NFT flows previewed
  pre-broadcast.

## Sponsor bounties targeted
- **Perpl — Best Analytics & Risk Tool:** local pre-execution risk and
  simulation engine for Monad (structural analysis + balance/gas
  accounting, air-gapped).
- **MetaMask — Best Agent Wallet Security Plugin / Middleware:** local
  execution proxy that agentic wallets route payments through.
- **Alchemy / Dynamic:** profile-driven RPC selection with bounded fetch
  timeouts and machine-readable per-tx state inspection.

## Measured benchmarks
See [README_MONAD.md](README_MONAD.md) — steady-state pre-flight check
**~1.5–1.8s per tx** on live Monad RPC (3 concurrent), RPC round trips
dominating; every run prints its own `elapsed_ms` / `sim_micros`.

## Verification
- `cargo check`: clean (warnings pre-existing only).
- `cargo test`: **25 passed, 0 failed** — chain profiles, x402 gate,
  brief verdicts, EIP-7702 parsing.
- Live RPC verified on Monad + Base Sepolia: structured JSON out, correct
  exit codes, RPC timeouts bounded via `RPC_TIMEOUT_SECS`.
