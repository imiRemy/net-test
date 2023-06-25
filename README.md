# net-test
Simple network performance testing using iperf3 on ubuntu.

## Test Configuration
To run tests with ```iperf3``` you will need a server instance and a client instance. These could be actual
hardware machines or virtual machines. You will also need a network connection between the server and the client.

## Installation
For installation on ubuntu, use the ```install.sh``` script which will add ```ifconfig``` and ```iperf3``` if they are not already on your system.

```$ ./install.sh```

## Running Tests
For a basic run of tests without changing any network buffers, MTU, etc., use the ```server_test.sh``` on
the server instance and ```client_test.sh``` on the client instance of ubuntu.

## Some Results
The following results were obtained from using Ubuntu virtual machines running in a Proxmox environment and using a dedicated 10Gb Ethernet NIC card separate from the main network interface for the system.

### System Configuration
Proxmox Virtual Environment v7.4:
* Intel i7-xxxx CPU at x GHz with 64GB DDR3 RAM
* Dedicated 10Gb Ethernet NIC: 10GTek
* Virtual Machines: Ubuntu Desktop v22.04, 2 CPUs, 6GB RAM

### Client / Server Direct Connection via CAT6A Cable
Direct connection between network interfaces of Ubuntu client and server using CAT6A cable.
| Target Speed | Out of the Box Result | Tuned Result |
| --------: | -------- | -------- |
| 1.0 Gbps | xx | yy |
| 2.5 Gbps | xx | yy |
| 5.0 Gbps | xx | yy |
| 10.0 Gbps | xx | yy |

### Client / Server Direct Connection via Fiber Link
This is a direct connection and was used to compare the performance of a direct cable connection to direct connection using a segment of OM3 fiber cable and transceivers (10GTek ....)

