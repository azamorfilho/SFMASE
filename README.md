# SFMASE
Smallest Fault Monitoring and Alerting System Ever

For almost 10 years, I've been teaching Network Management. Through these years, I've used a lot of different tools: mrtg, nagios, angel, munin, cacti, zabbix, zenoss and even proprietary software like Paessler PRTG. Most of these tools share a common feature: e-mail notifications. So I've been thinking about all the complexity around the infra-estructure management: SNMP, MIBS, Agents, Managers, Objects, OID's and so on. And I asked myself: why don't keep it simple? What could be the smallest code that can do the job in the simplest way?

To accomplish the job I chose Shell Script!

# Q: Why Shell Script? 
A: Cause we can use the first and simplest management tool ever written: ping. Ping is the first troubleshooting tool you're gonna use in your life. When a host runs a "ping", it sends an icmp packet (called echo-request) to the destination host. The source host waits for an icmp packet carrying an echo-reply answer code.

That's it! You've just test the network layer. This strategy is called divide and conquer and take advantage over Bottom-Up or Top-down strategies because you test the middle/center of the network layer stack. If ping goes OK, check upper layers (Transport and Application). If ping is not OK, look Network layer and below layers (Link layer and Physical layer). 

# Q: So what is the "Smallest Fault Monitoring and Alerting System Ever"? 
A: It's a shell script program to monitor a list of hosts using ICMP. The script sends a ping. If ping is 'OK' log to file. If ping 'fails', log to file and send an e-mail to alert the Network Administrator.

# Q: But how do we automate the job? 
A: Use the CRON! Just schedule your task to run every 1, 5, 10 minutes, you choose.

# Q: But how does the script knows which hosts to monitor? 
A: Remember to keep it simple, no databases are required. Just use a txt file.

