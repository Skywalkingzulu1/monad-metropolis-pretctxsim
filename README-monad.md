# PreTxSim - Monad Metropolis

## Pitch
Pre-tx simulation with balance deltas, gas, and slippage visibility before execution

## Core Features
- **Air-gapped simulation** via evm — runs locally, no keys broadcast until accepted
- **RiskInspector**: delegatecalls, selfdestructs, storage writes, allowances, EIP-7702 delegations
- **Local LLM auditor** (Ollama smollm2): advisory PASS/WARN, zero telemetry
- **Proxy gate** at http://127.0.0.1:8545 (drop-in for wallets/bots)

## Quick Start
\\\ash
docker compose up -d
\\\

See [demo_runbook.md](demo_runbook.md) for full details.
