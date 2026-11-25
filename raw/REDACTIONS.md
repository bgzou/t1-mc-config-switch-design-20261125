# Redactions

- `raw/roboparty/README_CN.md`: the upstream default AP password (`PASSPHRASE`) is replaced with `<REDACTED_DEFAULT_AP_PASSWORD>`. The upstream file is public, but this bundle is also public; do not reproduce a working credential.
- No account tokens, SSH keys, or private keys were found in the included text files at bundle build time.
- T1 internal IPs / site URLs remain in the evidence documents; they are lab addresses, not credentials. Treat the repo as lab-internal.
