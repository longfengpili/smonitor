# process exporter
[process exporter](https://github.com/ncabatoff/process-exporter)

# 启动
## bash
```bash
process-exporter -config.path filename.yml --web.listen-address=:9256
```

## service
+ 启动服务
```bash
~/procs/startup.sh
```


## docker
```bash
docker-compose up -d
```

# process exporter功能
如果想要对主机的进程进行监控，例如chronyd，sshd等服务进程以及自定义脚本程序运行状态监控。我们使用node exporter就不能实现需求了，此时就需要使用process exporter来做进程状态的监控。
项目地址：https://github.com/ncabatoff/process-exporter

# process exporter配置
process exporter的配置文件为yaml格式，需要在配置文件中指明需要监控的进程，并将进程分组，一个进程只能属于一个组。

## 基本格式
```yaml
process_names:
  - name: "{{.Matches}}"
    cmdline:
    - 'docker'
 
  - name: "{{.Matches}}"
    cmdline:
    - 'postgres'

  - name: "{{.Comm}}"
    cmdline:
    - '.+'
```

## 匹配模板
+ `{{.Comm}}`: 包含原始可执行文件的名称，即/proc/<pid>/stat
+ `{{.ExeBase}}`: 包含可执行文件的名称(默认)
+ `{{.ExeFull}}`: 包含可执行文件的路径
+ `{{.Username}}`: 包含的用户名
+ `{{.Matches}}`: 包含所有正则表达式而产生的匹配项（建议使用）
+ `{{.PID}}`: 包含进程的PID，一个PID仅包含一个进程（不建议使用）
+ `{{.StartTime}}`: 包含进程的开始时间（不建议使用）

## process exporter常用指标
|namedprocess_namegroup_num_procs|运行的进程数|
|---|---|
|namedprocess_namegroup_states|Running/Sleeping/Other/Zombie状态的进程数|
|namedprocess_namegroup_cpu_seconds_total|获取/proc/[pid]/stat 进程CPU utime、stime状态时间|
|namedprocess_namegroup_read_bytes_total|获取/proc/[pid]/io 进程读取字节数|
|namedprocess_namegroup_write_bytes_total|获取/proc/[pid]/io 进程写入字节数|
|namedprocess_namegroup_memory_bytes|获取进程使用的内存字节数|
|namedprocess_namegroup_open_filedesc|获取进程使用的文件描述符数量|
|namedprocess_namegroup_thread_count|运行的线程数|
|namedprocess_namegroup_thread_cpu_seconds_total|获取线程CPU状态时间|
|namedprocess_namegroup_thread_io_bytes_total|获取线程IO字节数|

