# Signatures

[Tracee](https://github.com/aquasecurity/tracee) has a library of built-in behavioral signatures. From this library, the following signatures are used by tracee-action:

- stdio_over_socket
- aslr_inspection
- proc_mem_code_injection
- docker_abuse
- scheduled_task_mod
- ld_preload
- cgroup_notify_on_release
- default_loader_mod
- sudoers_modification
- sched_debug_recon
- system_request_key_mod
- cgroup_release_agent
- rcd_modification
- core_pattern_modification
- proc_kcore_read
- proc_mem_access
- hidden_file_created
- anti_debugging
- ptrace_code_injection
- process_vm_write_inject
- disk_mount
- dynamic_code_loading
- fileless_execution
- illegitimate_shell
- kernel_module_loading
- proc_fops_hooking
- syscall_hooking
- dropped_executable

For more information about those signatures, please refer to [Tracee's signatures documentation](https://aquasecurity.github.io/tracee/latest/docs/detecting/rules/)

In addition, tracee-action adds the following signatures:

- miner_domain - detects the use of a known cryptocurrency miner domain
