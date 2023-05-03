cargo fmt --all
RUSTFLAGS='-C link-arg=-s' cargo build --release --lib --target wasm32-unknown-unknown
for WASM in ./target/wasm32-unknown-unknown/release/*.wasm; do
    NAME=$(basename "$WASM" .wasm)${SUFFIX}.wasm
    echo "Creating intermediate hash for $NAME ..."
    sha256sum -- "$WASM" | tee -a artifacts/checksums_intermediate.txt
    echo "Optimizing $NAME ..."
    wasm-opt -Os "$WASM"   -o "artifacts/$NAME"
  done
cosmwasm-check artifacts/cw_ibc_core.wasm
cosmwasm-check artifacts/cw_icon_light_client.wasm
cosmwasm-check artifacts/cw_mock_dapp.wasm
cosmwasm-check artifacts/cw_xcall.wasm