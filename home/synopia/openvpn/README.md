# OpenVPN profile

The `.ovpn` profile is managed by Home Manager and installed under
`~/.config/openvpn`.

The client private key and certificates are intentionally not stored in this
repository or the Nix store. Before the first Home Manager activation, place
these files under `~/OpenVPN`:

- `ca-cert.pem`
- `client-name-cert.pem`
- `client-name-key.pem`

Home Manager copies them to `~/.config/openvpn` with mode `0600`.

If the NetworkManager profile does not exist yet, import it once:

```sh
nmcli connection import type openvpn \
  file ~/.config/openvpn/localdomain.ovpn
```

NetworkManager will request and retain the VPN password through its secret
agent.
