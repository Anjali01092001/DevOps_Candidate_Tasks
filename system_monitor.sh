#!/bin/bash

# Function to display top 10 most used applications
function top_apps {
    echo "Top 10 Applications by CPU and Memory Usage:"
    ps aux --sort=-%cpu,-%mem | awk 'NR<=11{print $0}' | column -t
    echo
}

# Function to monitor network
function network_monitoring {
    echo "Network Monitoring:"
    echo "Number of Concurrent Connections: $(netstat -an | grep ESTABLISHED | wc -l)"
    echo "Packet Drops:"
    netstat -s | grep -i "packet"
    echo "Network Traffic (MB):"
    ifconfig | awk '/RX packets/ {print $2, $3} /TX packets/ {print $2, $3}'
    echo
}

# Function to display disk usage
function disk_usage {
    echo "Disk Usage:"
    df -h | awk '$5 > 80{print $0}' | column -t
    echo
}

# Function to show system load
function system_load {
    echo "System Load:"
    uptime
    echo "CPU Breakdown:"
    mpstat | awk 'NR==4{print $3" user, "$5" system, "$12" idle"}'
    echo
}

# Function to display memory usage
function memory_usage {
    echo "Memory Usage:"
    free -h | column -t
    echo
}

# Function to monitor processes
function process_monitoring {
    echo "Process Monitoring:"
    echo "Active Processes: $(ps aux | wc -l)"
    echo "Top 5 Processes by CPU and Memory Usage:"
    ps aux --sort=-%cpu,-%mem | awk 'NR<=6{print $0}' | column -t
    echo
}

# Function to monitor services
function service_monitoring {
    echo "Service Monitoring:"
    services=("sshd" "nginx" "iptables" "apache2")
    for service in "${services[@]}"; do
        systemctl is-active --quiet $service && status="Running" || status="Not Running"
        echo "$service: $status"
    done
    echo
}

# Function to display custom dashboard based on command-line switches
function custom_dashboard {
    if [[ $1 == "-cpu" ]]; then
        top_apps
        system_load
    elif [[ $1 == "-memory" ]]; then
        memory_usage
    elif [[ $1 == "-network" ]]; then
        network_monitoring
    elif [[ $1 == "-disk" ]]; then
        disk_usage
    elif [[ $1 == "-processes" ]]; then
        process_monitoring
    elif [[ $1 == "-services" ]]; then
        service_monitoring
    else
        top_apps
        network_monitoring
        disk_usage
        system_load
        memory_usage
        process_monitoring
        service_monitoring
    fi
}

# Main script to refresh every few seconds
while true; do
    clear
    custom_dashboard $1
    sleep 5
done
