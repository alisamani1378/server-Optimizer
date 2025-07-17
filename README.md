<h1 align="center">⚡ Universal VPN / Tunnel Optimizer ⚡</h1>
<p align="center">
  <em>An interactive script for squeezing every last drop of performance out of your Linux gateway—whether you’re proxying TCP traffic or running latency-critical UDP tunnels.</em>
</p>

<div align="center">
  
|  🚀 One-liner | <code>bash &lt;(curl -sSL https://raw.githubusercontent.com/alisamani1378/server-Optimizer/refs/heads/main/optimize.sh)</code> |
|--------------|------------------------------------------------------------------------------------------------------------------------------------|
|  ✅ Tested on | Ubuntu 20.04 + • Debian 11 + • Alma 9 + • Most modern x86_64 & arm64 kernels (5.4 +) |
|  🔑 Requires | <strong>root</strong> or <strong>sudo</strong> privileges |
  
</div>

---

## Why do I need this?

VPN and tunnel servers have a very different network profile from a typical web-server.  
They juggle thousands of long-lived connections or millions of tiny UDP packets, and the vanilla kernel defaults just aren’t tuned for that workload.  

This script:

1. **Backs up** your current `sysctl.conf` (timestamped).  
2. Lets you **pick an optimization profile**—TCP or UDP—via a friendly menu.  
3. Applies **aggressive but sensible sysctl tweaks** (buffer sizes, congestion control, queue lengths, etc.).  
4. **Enables BBR** congestion control automatically.  
5. Reminds you to reboot so the changes are 100 % active.

All in under 30 seconds.

---

## ✨ Features at a Glance

| Feature | TCP Profile | UDP Profile |
|---------|-------------|-------------|
| Massive send/receive buffers (`tcp_rmem`, `tcp_wmem`) | ✅ | — |
| Aggressive `somaxconn`, `net.core.*backlog` | ✅ | ✅ |
| TCP Fast Open, SACK, ECN tuning | ✅ | — |
| Enlarged global queues & packet scheduler | ✅ | ✅ |
| Enlarged `udp_mem` / `rmem_default` / `rmem_max` | — | ✅ |
| Fair Queuing + BBR congestion control | ✅ | ✅ |
| `netdev_max_backlog` & IRQ affinity hints | ✅ | ✅ |

*The settings assume your VPS has **enough RAM** (>512 MiB) and **stable kernels**.*

---

## 🛠 How to Use

```bash
bash <(curl -sSL https://raw.githubusercontent.com/alisamani1378/server-Optimizer/refs/heads/main/optimize.sh)
