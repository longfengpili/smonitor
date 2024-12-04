# 监控服务器性能
# 部署prometheus、grafana
```
docker-compose up -d
```
# prometheus配置
```
# 我的全局配置
global:
  scrape_interval: 15s # 设置抓取间隔为每15秒。默认是每1分钟。
  evaluation_interval: 15s # 每15秒评估一次规则。默认是每1分钟。

# Alertmanager 配置
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          # - alertmanager:9093

# 加载规则文件并根据全局 'evaluation_interval' 定期评估它们。
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# 包含一个要抓取端点的抓取配置：
# 这里是 Prometheus 自己。
scrape_configs:
  # 工作名称作为标签 `job=<job_name>` 被添加到从此配置抓取的任何时间序列中。
  - job_name: "prometheus"

    # metrics_path 默认为 '/metrics'
    # scheme 默认为 'http'。

    static_configs:
      - targets: ["localhost:9090"]


```

# 部署node_exporter(监控服务器)
1. 建立容器
```bash
docker-compose -f docker-compose-nodeexporter.yml up -d
```
2. 访问确认
```
curl ip:9100
```
3. prometheus配置中增加
```yaml
  - job_name: 'node2.156'
    static_configs:
      - targets: ['ip:9100']
```

# trino monitor
1. 下载[jmx_prometheus_javaagent](https://github.com/prometheus/jmx_exporter)
```base
mkdir jmx-exporter
wget https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.19.0/jmx_prometheus_javaagent-0.19.0.jar -O jmx-exporter/jmx_prometheus_javaagent-0.19.0.jar
```

2. 创建jmx 配置文件，可以设置采集规则，默认是采集所有指标
```bash
touch jmx-exporter/jmx_config.yaml
```
```yaml
rules:
- pattern: ".*"
```

3. trino修改jvm.config配置(path替换实际路径)
```config
-javaagent:/path/jmx_prometheus_javaagent-0.19.0.jar=3900:/path/jmx_config.yaml
```
4. 访问确认
```
curl localhost:3900
```
5. prometheus配置中增加
```yaml
  - job_name: 'trino'
    static_configs:
      - targets: ['host:3900']
```

# jmx_config
## [authentication](http://prometheus.github.io/jmx_exporter/1.1.0/http-mode/authentication/)
+ 计算方法
```python
import hashlib

salt = "U9i%=N+m]#i9yvUV:bA/3n4X9JdPXf=n"
password = "secret"
hash_input = f"{salt}:{password}".encode('utf-8')
password_hash = hashlib.sha256(hash_input).hexdigest()

print(password_hash)  # 应该是你的散列值
```

+ jmx_exporter增加密码
```yaml
httpServer:
  authentication:
    basic:
      username: Prometheus
      passwordHash: 9bced41860fda74c0d336accefd21535cf336cbff3e3313e9796cb13700b37fd
      algorithm: SHA-256
      salt: s20241203
```

+ prometheus增加密码
```yaml
  - job_name: 'strino'
    metrics_path: '/metrics'
    static_configs:
      - targets: ['192.168.2.154:3900']
        labels:
          env: sandbox

    basic_auth:
      username: Prometheus
      password: secret
```

## grafana中时间窗口的含义
在Grafana中，`$__range`、`$__rate_interval`和`$__interval`是常用的变量，用于在查询中动态适配不同的时间范围或数据采样需求。这些变量帮助Grafana用户在面板中创建灵活且动态的时间序列查询。

### 1. `$__range`

- **定义**：`$__range` 表示当前面板的时间范围（Time Range），这个范围是用户在界面上选择的，例如 "Last 1 hour"（过去1小时）或 "Last 7 days"（过去7天）。
  
- **应用场景**：用于将查询时间范围动态化。例如，一个指标要根据你当前选择的时间范围进行计算时，`$__range` 是非常实用的。

#### 示例：
```sql
SELECT sum(value) FROM metrics WHERE $__timeFilter(timestamp)
```
这里，`$__timeFilter` 使用了`$__range`中的时间范围来限制SQL查询的时间段。

### 2. `$__rate_interval`

- **定义**：`$__rate_interval` 是一个特殊的时间窗口，用于计算时间序列数据的变化速率。通常它比查询的步长（step）更长，确保在速率计算中有足够的历史数据点用于计算。
  
- **应用场景**：主要用于Prometheus或其他支持类似功能的数据源，在进行 `rate()`、`irate()` 等速率计算函数时。

#### 示例：
```prometheus
rate(http_requests_total[$__rate_interval])
```
在这个PromQL查询中，`$__rate_interval` 确保了在计算HTTP请求速率时利用足够的历史数据。

### 3. `$__interval`

- **定义**：`$__interval` 是Grafana自动计算出来的时间间隔，用于控制查询时的颗粒度。基于当前的时间范围和面板宽度，Grafana为每个数据点保留的时间间隔。它确保面板能在既定范围内展现合适数量的数据点。

- **应用场景**：用于调整图表的细粒度展示，不至于在大的时间范围时数据点过于密集。

#### 示例：
```prometheus
avg_over_time(cpu_usage[$__interval])
```
在这个PromQL查询中，`$__interval` 决定了 `avg_over_time` 中使用的数据窗口大小，这确保了图表数据点的清晰度和可读性。
