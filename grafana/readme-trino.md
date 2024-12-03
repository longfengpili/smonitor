# Trino 日志

## 推荐使用
# 指标： process_start_time_seconds
**中文**： 进程自UNIX纪元开始以来的启动时间，以秒为单位。
**应用**： 记录进程启动时间，用于监控和验证应用重启情况。
**公式示例**：
- `now() - process_start_time_seconds`：计算进程已运行时间，单位为秒。


# 指标： process_cpu_seconds_total
**中文**： 总的用户和系统CPU时间消耗，以秒为单位。
**应用**： 衡量进程使用的CPU时间总量，帮助分析CPU资源利用情况。
**公式示例**： 
- `rate(process_cpu_seconds_total[1m])`：计算每分钟CPU时间增量，即CPU使用速率。

# 指标： process_resident_memory_bytes
**中文**： 常驻内存大小，单位为字节。
**应用**： 显示进程实际占用的物理内存，有助于分析内存使用效率。
**公式示例**：
- `process_resident_memory_bytes`：将常驻内存转换为MB，便于解读。


### 指标： trino_execution_QueryManager_ExternalFailures_TotalCount
**中文**： 外部失败总数。
**应用**： 用于追踪由于外部原因（如网络或第三方服务问题）导致的查询失败总次数。
**公式示例**：
- `increase(trino_execution_QueryManager_ExternalFailures_TotalCount[1h])`：计算过去一小时新增的外部失败次数。

### 指标： trino_execution_QueryManager_FailedQueries_TotalCount
**中文**： 查询失败总数。
**应用**： 表示自系统启动以来所有失败的查询数量，用于评估系统稳定性和故障处理能力。
**公式示例**：
- `rate(trino_execution_QueryManager_FailedQueries_TotalCount[1h])`：计算每小时失败查询的增长速率。

### 指标： trino_execution_QueryManager_AbandonedQueries_TotalCount
**中文**： 被放弃查询总数。
**应用**： 统计被放弃的查询数量，通常由于资源不足或其他系统问题，帮助改善查询资源管理。
**公式示例**：
- `increase(trino_execution_QueryManager_AbandonedQueries_TotalCount[1d])`：计算每日被放弃的查询数。


### 指标： trino_execution_QueryManager_InsufficientResourcesFailures_TotalCount
**中文**： 由于资源不足导致的失败总数。
**应用**： 用于追踪因为资源不足（如内存或CPU不足）而导致的查询失败次数。
**公式示例**：
- `increase(trino_execution_QueryManager_InsufficientResourcesFailures_TotalCount[1h])`：跟踪资源不足失败的新增量。


### 指标： trino_execution_QueryManager_StartedQueries_TotalCount
**中文**： 启动查询总数。
**应用**： 自启动以来运行的查询总数，用于衡量查询流量和使用情况。
**公式示例**：
- `rate(trino_execution_QueryManager_StartedQueries_TotalCount[1h])`：每小时启动查询数速率。

### 指标： trino_execution_QueryManager_CanceledQueries_TotalCount
**中文**： 被取消查询总数。
**应用**： 用于统计被取消的查询数量，通常用于分析用户行为或资源管理策略。
**公式示例**：
- `increase(trino_execution_QueryManager_CanceledQueries_TotalCount[1d])`：追踪每日取消的查询数。

### 指标： trino_execution_QueryManager_SubmittedQueries_TotalCount
**中文**： 提交查询总数。
**应用**： 表示总提交的查询数，以衡量系统的负载和使用频率。
**公式示例**：
- `rate(trino_execution_QueryManager_SubmittedQueries_TotalCount[1h])`：计算每小时提交的查询数速率。

### 指标： trino_execution_QueryManager_InternalFailures_TotalCount
**中文**： 内部失败总数。
**应用**： 追踪由于内部错误（如代码缺陷）导致的失败次数。
**公式示例**：
- `increase(trino_execution_QueryManager_InternalFailures_TotalCount[1h])`：每小时内部失败的新增次数。

### 指标： trino_execution_QueryManager_UserErrorFailures_TotalCount
**中文**： 用户错误导致的失败总数。
**应用**： 用于识别由于用户错误导致的查询失败频率，可以帮助改进用户支持和教育。
**公式示例**：
- `increase(trino_execution_QueryManager_UserErrorFailures_TotalCount[1h])`：计算每小时的用户错误失败增量。

### 指标： trino_execution_QueryManager_CompletedQueries_TotalCount
**中文**： 已完成查询总数。
**应用**： 表示自启动以来成功完成的查询数量，用于评估成功执行率。
**公式示例**：
- `rate(trino_execution_QueryManager_CompletedQueries_TotalCount[1h])`：计算每小时完成查询的速率。

### 指标： jvm_memory_bytes_used
**中文**： JVM内存区域已使用字节数。
**应用**： 显示当前已使用的内存字节数，帮助监控实际的内存消耗情况，确保内存使用在合理范围内，防止内存泄漏。

### 指标： jvm_memory_bytes_committed
**中文**： JVM内存区域已提交字节数。
**应用**： 表示已保证可用的内存量，这部分内存已被JVM申请并可立即使用，用于评估内存使用是否接近已提交限额，以优化内存配置。

### 指标： jvm_memory_pool_bytes_used
**中文**： JVM内存池已使用字节数。
**应用**： 用于监测特定JVM内存池的使用情况，有助于识别特定内存区域的压力点和潜在的内存瓶颈。

**池（Pool）解释**：

1. **CodeHeap 'non-nmethods'**：存储非方法的字节码，例如类加载器中的元数据和辅助数据结构。

2. **Metaspace**：存储类和方法的元数据，使用本机内存。

3. **CodeHeap 'profiled nmethods'**：存储经过分析的方法字节码，这是经过JVM运行时优化的热点方法。

4. **PS Old Gen**：用于保存经过多次年轻代垃圾收集后幸存下来的长生命周期对象。

5. **Compressed Class Space**：用来存储压缩的类指针和元数据结构。

6. **PS Survivor Space**：保存年轻代中对象，在年轻代GC后未被回收的对象会被转移到这里。

7. **PS Eden Space**：年轻代中的对象首次创建的区域，绝大多数对象会在这里被创建和迅速销毁。

8. **CodeHeap 'non-profiled nmethods'**：存储未经过分析的普通方法字节码。

**公式示例**：
- `sum(jvm_memory_pool_bytes_committed{job=~"$job", instance=~"$instance", pool=~"$pool"}) / sum (jvm_memory_bytes_committed{job=~"$job", area="heap", instance=~"$instance"})`: 计算pool合计的占比
- `sum by (pool) (jvm_memory_pool_bytes_committed{job=~"$job", instance=~"$instance", pool=~"$pool"}) / ignoring(pool) group_left sum (jvm_memory_bytes_committed{job=~"$job", area="heap", instance=~"$instance"})`: 计算每个pool的占比


### 指标： java_lang_OperatingSystem_CpuLoad

**中文**： 系统CPU负载。

**应用**： 表示从操作系统级别观察到的整体CPU负载百分比，是系统所有可用CPU的平均负载。可用来监控整个系统的CPU负载情况，以便于性能调优和识别系统级瓶颈。

**公式示例**：
- `avg_over_time(java_lang_OperatingSystem_CpuLoad[5m])`：计算过去5分钟内CPU负载的平均值，以了解系统负载的总体趋势。
- `max_over_time(java_lang_OperatingSystem_CpuLoad[1h])`：找出过去一小时内CPU负载的最高峰值。



### 指标： java_lang_OperatingSystem_ProcessCpuLoad

**中文**： 进程CPU负载。

**应用**： 用于监控当前JVM进程的CPU负载百分比。此负载百分比反映了单个JVM进程的CPU资源使用情况。它有助于识别和优化单个应用程序的性能。

**公式示例**：
- `avg_over_time(java_lang_OperatingSystem_ProcessCpuLoad[5m])`：计算过去5分钟内JVM进程的平均CPU负载，以了解应用程序的CPU使用情况。
- `max_over_time(java_lang_OperatingSystem_ProcessCpuLoad[1h])`：找出过去一小时内进程CPU负载的最高峰值。



### 指标： java_lang_OperatingSystem_SystemCpuLoad

**中文**： 系统CPU负载（特定于当前系统）。

**应用**： 反映了系统用于当前进程之外任务的整体CPU负载。数值为0表示此时系统CPU没有负载。它有助于判断系统当前是否处于轻负载状态，从而提示是否有资源可用于新任务。

**公式示例**：
- `avg_over_time(java_lang_OperatingSystem_SystemCpuLoad[5m])`：计算过去5分钟系统CPU负载的平均值，以评估系统的资源利用情况。
- `min_over_time(java_lang_OperatingSystem_SystemCpuLoad[1h])`：查找过去一小时内系统CPU负载的最低值，以识别潜在的资源空闲时段。

### 指标： jvm_gc_collection_seconds

**中文**： JVM垃圾收集器在垃圾收集上花费的总时间，单位为秒。

**应用**： 此指标跟踪Java虚拟机中垃圾收集器实际执行垃圾收集操作所消耗的时间。通过该指标可以了解垃圾回收对应用程序性能的影响，以及不同垃圾收集器如何影响系统的整体行为。

**指标说明**：
- **jvm_gc_collection_seconds_count**：表示特定垃圾收集器运行的总次数。
  - `gc="PS MarkSweep"`：表明PS MarkSweep（老年代垃圾收集器）。
  - `gc="PS Scavenge"`：表明PS Scavenge（新生代垃圾收集器）。
  
- **jvm_gc_collection_seconds_sum**：表示垃圾收集器在执行垃圾收集过程中花费的总时间（单位：秒）。
  - `gc="PS MarkSweep"`：总共花费了68.994秒。
  - `gc="PS Scavenge"`：总共花费了485.265秒。

**公式示例**：
- `jvm_gc_collection_seconds_sum{gc="PS Scavenge"} / jvm_gc_collection_seconds_count{gc="PS Scavenge"}`：计算PS Scavenge垃圾收集的平均时间，帮助分析其对性能的影响。
- `rate(jvm_gc_collection_seconds_sum[5m])`：在过去5分钟内，垃圾收集在总时间上的变化速度，以预测未来趋势和可能的瓶颈。

- `rate(jvm_gc_collection_seconds_count[1m])`：计算每分钟的垃圾收集次数变化率，以观察系统当前的垃圾回收压力。
- `increase(jvm_gc_collection_seconds_count[1h])`：统计过去一小时内的垃圾收集总次数，这可以用于判断一段时间内的内存使用效率和压力。



## 其他指标

# 指标： process_open_fds
**中文**： 打开的文件描述符数量。
**应用**： 监控打开文件描述符数量，确保不接近系统限制。
**公式示例**：
- `process_open_fds / process_max_fds * 100`：计算当前文件描述符使用率，以百分比表示。

# 指标： process_max_fds
**中文**： 最大可打开的文件描述符数量。
**应用**： 确保知道进程可用的最大文件描述符数量，便于资源规划。
**公式示例**：
- 此指标通常直接使用，用于与`process_open_fds`比较。

# 指标： process_virtual_memory_bytes
**中文**： 虚拟内存大小，单位为字节。
**应用**： 帮助判断进程的内存使用情况和内存管理策略。
**公式示例**：
- `process_virtual_memory_bytes`：将虚拟内存转换为MB，便于直观显示和分析。


### 指标： trino_execution_QueryManager_CpuInputByteRate_AllTime_Count
**中文**： 总体CPU输入字节率。
**应用**： 表示服务运行期间CPU处理的总输入字节数速率，提供对CPU处理负载的一个整体视角。
**公式示例**：
- `rate(trino_execution_QueryManager_CpuInputByteRate_AllTime_Count[1h])`：计算每小时的平均CPU输入字节速率变动。


### 指标： trino_execution_QueryManager_WallInputBytesRate_AllTime_Count
**中文**： 总体输入字节速率。
**应用**： 表现整个查询期间输入数据的传输速率，用于分析数据传输的效率。
**公式示例**：
- `average_over_time(trino_execution_QueryManager_WallInputBytesRate_AllTime_Count[1h])`：计算平均输入速率，帮助评估系统负载趋势。

### 指标： trino_execution_QueryManager_ConsumedCpuTimeSecs_TotalCount
**中文**： 消耗的CPU时间总计（以秒计）。
**应用**： 用于访问服务整体的CPU使用情况，帮助评估性能和可能的瓶颈。
**公式示例**：
- `rate(trino_execution_QueryManager_ConsumedCpuTimeSecs_TotalCount[1h])`：每小时的CPU时间消耗速率。

### 指标： trino_execution_QueryManager_ConsumedInputRows_TotalCount
**中文**： 消耗的输入行总数。
**应用**： 指示到目前为止被处理的输入行数，帮助理解数据处理的规模。
**公式示例**：
- `increase(trino_execution_QueryManager_ConsumedInputRows_TotalCount[1d])`：每天消耗的输入行增量。


### 指标： trino_execution_QueryManager_QueuedTime_AllTime_Count
**中文**： 总排队时间。
**应用**： 统计所有查询在排队中的时间总和，帮助识别排队和等待问题。
**公式示例**：
- `sum_over_time(trino_execution_QueryManager_QueuedTime_AllTime_Count[1h])`：查看各时间段的总排队时间。



### 指标： trino_execution_QueryManager_ConsumedInputBytes_TotalCount
**中文**： 消耗的输入字节总数。
**应用**： 代表所处理数据的总量，帮助评估数据流和带宽使用。
**公式示例**：
- `rate(trino_execution_QueryManager_ConsumedInputBytes_TotalCount[1h])`：每小时的输入字节处理速率。

### 指标： trino_execution_QueryManager_ExecutionTime_AllTime_Count
**中文**： 总执行时间。
**应用**： 表示所有查询的累计执行时间，用于评估查询效率。
**公式示例**：
- `sum_over_time(trino_execution_QueryManager_ExecutionTime_AllTime_Count[1h])`：查看各时间段的总执行时间。



### 指标： jvm_memory_bytes_max
**中文**： JVM内存区域最大字节数。
**应用**： 指定内存区域可用的最大字节数，帮助了解内存的上限配置，从而提前调整以避免`OutOfMemoryError`。

### 指标： jvm_memory_bytes_init
**中文**： JVM内存区域初始字节数。
**应用**： JVM启动时为内存区域分配的初始字节数，帮助理解初始内存配置，以评估初始设置是否合适。



### 指标： trino_execution_RemoteTaskFactory_Executor_QueuedTaskCount
**中文**： Trino执行环境中的远程任务工厂执行器当前排队的任务数量。
**应用**：此指标用于监控在Trino调度和执行查询的过程中，有多少任务正在等待被处理。高的排队任务数量可能表明系统负载过重，资源不足，或者任务处理速度较慢。
- **公式示例**：
  ```prometheus
  rate(trino_execution_RemoteTaskFactory_Executor_QueuedTaskCount[1m])
  ```


### 指标： java_lang_OperatingSystem_ProcessCpuTime

**中文**： 操作系统进程CPU时间。

**应用**： 用于监控JVM进程自启动以来在操作系统上的累计CPU时间，以纳秒为单位。此指标可帮助评估应用程序的CPU使用量，分析性能开销并识别潜在的性能瓶颈。

**公式示例**：
- `rate(java_lang_OperatingSystem_ProcessCpuTime[1m])`：计算每分钟进程CPU时间的增长率，以监控近期CPU利用的变化。
- `increase(java_lang_OperatingSystem_ProcessCpuTime[5m])`：计算过去5分钟进程累计的CPU使用时间增量，以分析短时间内的CPU使用趋势。



### 指标： trino_execution_SqlTaskManager_FailedTasks_TotalCount

**中文**： SQL任务管理器失败任务总数。

**应用**： 此指标用于监控Trino SQL任务管理器（SqlTaskManager）中失败任务的累计总数。通过追踪失败任务数量，可以识别系统或查询执行中的故障，并采取措施来提高查询的可靠性和系统的稳定性。这对于快速响应故障和优化系统运行至关重要。

**公式示例**：
- `increase(trino_execution_SqlTaskManager_FailedTasks_TotalCount[1h])`：计算过去一小时内新增的失败任务总数，以监控近期的任务失败情况。
- `rate(trino_execution_SqlTaskManager_FailedTasks_TotalCount[5m])`：计算每5分钟失败任务计数的变化率，以帮助分析失败趋势和波动。


