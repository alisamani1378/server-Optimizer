#!/bin/bash
# =========================================================================
# Interactive Sysctl Optimizer for VPN/Tunnel Servers
# Asks the user to choose between TCP-focused or UDP-focused optimizations.
# Can be hosted on GitHub and run with a single command.
# =========================================================================

# --- Check for root privileges ---
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Please use sudo." >&2
  exit 1
fi

# --- Function to write TCP-optimized settings ---
apply_tcp_settings() {
    echo "Writing TCP-optimized settings (for VLESS, Trojan, etc.)..."
    cat > /etc/sysctl.conf <<EOF
#
# =======================================================
# == Aggressive Kernel Settings for TCP Proxy/Gateway ===
# =======================================================
#

# --- Memory and Cache Management ---
vm.swappiness = 1
vm.min_free_kbytes = 65536
vm.dirty_ratio = 5
vm.dirty_background_ratio = 2
vm.vfs_cache_pressure = 50

# --- Network Core & General Buffer Optimization ---
net.core.somaxconn = 65536
net.core.netdev_max_backlog = 65536
net.core.rmem_max = 33554432
net.core.wmem_max = 33554432

# --- TCP Specific Optimizations (CRUCIAL) ---
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_rmem = 4096 87380 33554432
net.ipv4.tcp_wmem = 4096 65536 33554432
net.ipv4.tcp_max_syn_backlog = 65536
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_window_scaling = 1

# --- Tunnel & IP Forwarding Settings ---
net.ipv4.ip_forward = 1
net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.default.rp_filter = 0

# --- Security Hardening ---
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0

# --- Optional: Disable IPv6 if not used ---
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF
}

# --- Function to write UDP-optimized settings ---
apply_udp_settings() {
    echo "Writing UDP-optimized settings (for Gaming, WireGuard, etc.)..."
    cat > /etc/sysctl.conf <<EOF
#
# =======================================================
# == Aggressive Kernel Settings for VPN/Gaming Gateway ==
# =======================================================
#

# --- Memory and Cache Management ---
vm.swappiness = 1
vm.min_free_kbytes = 65536
vm.dirty_ratio = 5
vm.dirty_background_ratio = 2
vm.vfs_cache_pressure = 50

# --- Network Core & Buffer Optimization (CRUCIAL for UDP) ---
net.core.somaxconn = 65536
net.core.netdev_max_backlog = 65536
net.core.rmem_default = 2097152
net.core.wmem_default = 2097152
net.core.rmem_max = 33554432
net.core.wmem_max = 33554432
net.ipv4.udp_mem = 2097152 4194304 8388608

# --- TCP Specific Optimizations (Still important) ---
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_max_syn_backlog = 65536
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_mtu_probing = 1

# --- Tunnel & IP Forwarding Settings ---
net.ipv4.ip_forward = 1
net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.default.rp_filter = 0

# --- Security Hardening ---
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0

# --- Optional: Disable IPv6 if not used ---
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF
}

# --- Main Script Logic ---
clear
echo "================================================="
echo "     Universal VPN/Tunnel Optimizer Script     "
echo "================================================="
echo
echo "Please select the optimization profile for your server:"
echo "  1) TCP Profile (Best for VLESS, Trojan, Shadowsocks, etc.)"
echo "  2) UDP Profile (Best for Gaming, WireGuard, UDP-based Tunnels)"
echo

# Loop until a valid choice is made
while true; do
    read -p "Enter your choice [1 or 2]: " choice
    case $choice in
        1|2)
            break
            ;;
        *)
            echo "Invalid input. Please enter 1 or 2."
            ;;
    esac
done

# Create a backup of the original sysctl.conf
echo "Backing up original /etc/sysctl.conf to /etc/sysctl.conf.bak..."
cp /etc/sysctl.conf /etc/sysctl.conf.bak.$(date +%F)

# Call the appropriate function based on user choice
if [ "$choice" -eq 1 ]; then
    apply_tcp_settings
else
    apply_udp_settings
fi

# Apply the new sysctl settings immediately
echo "Applying new sysctl settings..."
sysctl -p

echo "-------------------------------------------------"
echo "Optimization complete!"
echo "A reboot is recommended to ensure all changes, especially BBR, take effect."
echo "-------------------------------------------------"
