# PreTxSim on Monad — High-Throughput Pre-Flight Simulation Firewall

**Track:** Trust, Identity & AI Infrastructure (Monad Metropolis)

Monad executes in parallel at 10K TPS with ~300ms blocks. PreTxSim matches
that posture on the safety side: concurrent pre-flight simulation for
autonomous agent wallets and skill-based NFTs, one shared revm core, and
per-tx wall-clock timings printed with every run so judges can verify —
not take our word for — the speed story.

## Run it

```bash
cargo run -- --chain monad --sim-file tx_payload.json --ai-brief
```

- `--chain monad` selects the Monad profile (chain id 143, high block gas
  limit, parallel batch checks ON).
- `--sim-file` accepts a single tx object or an array; every entry is
  simulated concurrently via `--monad-parallel-check` (implied by the
  profile, or pass the flag explicitly on any chain).
- `--ai-brief` attaches a local-Ollama structured brief per tx.
- Override the endpoint any time: `--rpc-url <url>` or `RPC_URL` env.
- `RPC_TIMEOUT_SECS` bounds every upstream call (default 25s) so a stalled
  RPC fails the gate fast instead of hanging it.

`tx_payload.json` example (array of two agent-wallet transfers):

```json
[
  {"from":"0x...","to":"0x...","value":"0x1000","gas":"0x5208","data":"0x"},
  {"from":"0x...","to":"0x...","value":"0x2000","gas":"0x5208","data":"0x"}
]
```

Output is a JSON array; each entry carries `analysis`, `execution_success`,
`gas_used`, `elapsed_ms`, `sim_micros`, `blocked`, and (with `--ai-brief`) a
`brief` verdict. Exit code is 1 if any tx is blocked. The `elapsed_ms` field
is measured wall-clock per tx — quote it, don't trust our adjectives.

## Measured benchmarks (real runs, Oct 2026)

Command: `cargo run -- --chain monad --sim-file examples/monad_tx_batch.json`
(3 zero-value transfers, concurrent batch, live Monad mainnet RPC, dev
profile binary, West Africa region). Raw outputs: re-run the command —
every run prints its own timings.

| Run | tx0 sim | tx1 sim | tx2 sim | Batch wall |
| --- | --- | --- | --- | --- |
| 1 (cold) | 3.47s | — (unfunded-value error, since fixed in payload) | — | — |
| 2 | 1.84s | 1.84s | 1.84s | ~27s incl. local-LLM briefs |
| 3 | 1.48s | 1.46s | 1.47s | ~27s incl. local-LLM briefs |

- **Steady-state pre-flight check: ~1.5–1.8s per tx** (`sim_micros` field),
  all 3 concurrent in one batch.
- **Where the time goes:** public-RPC state-fetch round trips dominate;
  revm-side execution is microseconds-scale. Against a local/low-latency
  node the same check drops proportionally — verify with
  `--rpc-url <your-node>`.
- **LLM briefs cost extra:** `elapsed_ms` includes the optional local
  Ollama brief (~8–25s on `smollm2:135m` here); the deterministic verdict
  never waits on it to gate.

## Sponsor bounties targeted

- **Perpl — Best Analytics & Risk Tool.** PreTxSim is the zero-trust,
  local pre-execution risk and simulation engine for Monad: deterministic
  structural analysis (delegatecalls, selfdestructs, allowance blowouts,
  EIP-7702 delegations) plus balance-delta/gas accounting, all air-gapped.
- **MetaMask — Best Agent Wallet Security Plugin / Middleware.** PreTxSim
  runs as the local execution proxy agentic wallets route through: every
  proposed payment is rehearsed and briefed before signing, keys never
  leave the box.
- **Alchemy / Dynamic — High-throughput RPC fallback & agent state
  inspection.** Profile-driven RPC selection (`--rpc-url` / `RPC_URL`),
  bounded fetch timeouts (`RPC_TIMEOUT_SECS`), and per-tx state
  inspection (balances, code, storage) that agents can consume as JSON.

## Why this fits Monad

- **Parallel by default:** batch simulation fans out across tokio tasks,
  mirroring Monad's parallel-execution thesis on the verification side.
- **Agent wallets:** every autonomous payment is rehearsed against live
  state (balance deltas, gas bounds) before signing — the firewall between
  an agent's intent and irreversible execution.
- **Skill-based NFTs:** mint/transfer flows preview state changes and
  approvals pre-broadcast; drainer patterns (delegatecall, EIP-7702
  delegations, allowance blowouts) hard-block.
- **Honest numbers:** timings are printed per run on real RPC state. No
  benchmark claims are made in this repo that the tool itself doesn't emit.
