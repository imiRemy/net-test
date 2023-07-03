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

To run the tests, start the server script on the server machine and then invoke the client script on the client machine. Results will be recorded to a log file on the client machine. Note that the scripts take an optional argument which is the IPv4 address that the server is listening on; if no argument is provided, a hardwired IP address is used.

Server side:
```$ ./server_test.sh <server_IP_address>```

Client side:
```$ ./client_test.sh <server_IP_address>```

## Some Results
The following results were obtained from using Ubuntu virtual machines running in a Proxmox environment and using a dedicated 10Gb Ethernet NIC card separate from the main network interface for the system.

### System Configuration
Proxmox Virtual Environment v7.4-3:
* Intel i7-7700 CPU at 3.6GHz with 64GB DDR3 RAM, 1TB M.2 NVMe
* Dedicated 10Gb Ethernet NIC for test: 10Gtek Dual Intel X540 (X540-10G-2T-X8)
* Virtual Machines: Ubuntu 22.04.2 LTS, 2 CPUs, 4GB RAM

#### Note on Tuning
Testing was both with "Out of the Box" and with a "Tuned" set of parameters. The tuning was not exhaustive but was based on setting MTU to jumbo size and some other basic buffer sizes.
| Parameter | Out of the Box | Tuned |
| -------- | --------: | --------: |
| MTU | 1500 | 9000 |
| net.core.rmem_max | 212992 | 1024000 |
| net.core.wmem_max | 212992 | 1024000 |
| net.core.optmem_max | 20480 | 204800 |

### Client / Server Direct Connection via CAT6A Cable
Direct connection between network interfaces of Ubuntu client and server using CAT6A cable. Rate averaged across all bidirectional links. Start VMs, run full test script twice and take the second set of results.

#### Network Speed
| Target Speed | Out of the Box Result* | Tuned Result* |
| --------: | --------: | --------: |
| 1.0 Gbps | 1.0 Gbps | 1.0 Gbps |
| 2.5 Gbps | 2.5 Gbps | 2.5 Gbps |
| 5.0 Gbps | 5.0 Gbps | 5.0 Gbps |
| 10.0 Gbps | 9.39 Gbps | 9.89 Gbps |

*Based on ```iperf3``` reporting across all bidirectional links on a 300 second test.

#### Server CPU Load
| Target Speed | Out of the Box Result* | Tuned Result* |
| --------: | --------: | --------: |
| 1.0 Gbps | 12.3% | 12.7% |
| 2.5 Gbps | 22.3% | 17.6% |
| 5.0 Gbps | 34.0% | 27.5% |
| 10.0 Gbps | 62.1% | 45.2% |

* Based on the average per minute load of the middle three minutes of a five minute test.

### Client / Server Direct Connection via Fiber Link
This is a direct connection and was used to compare the performance of a direct CAT6A cable connection to direct connection using a segment of OM3 fiber cable and transceivers (10Gtek Media Converter, XG0200-SFP). Start VMs, run full test script twice and take the second set of results.
| Target Speed | Out of the Box Result* | Tuned Result* |
| --------: | --------: | --------: |
| 1.0 Gbps | 1.0 Gbps** | 1.0 Gbps** |
| 2.5 Gbps | 2.5 Gbps | 2.5 Gbps |
| 5.0 Gbps | 5.0 Gbps | 5.0 Gbps |
| 10.0 Gbps | 9.38 Gbps | 9.89 Gbps |

*All tests based on ```iperf3``` reporting across all bidirectional links on a 30 second test.
**Technically 999.75 Mbps.

