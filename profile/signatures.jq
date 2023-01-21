.[] |  
select( .eventName == "sched_process_exec" or .eventName == "net_packet_dns" | not )
