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
# 创建一个新的sha256哈希对象
sha256_hash = hashlib.sha256()

password = f"{salt}:{secret}"

# 更新哈希对象，使用盐和密码（以字节形式）
sha256_hash.update(password.encode('utf-8'))

# 返回盐和哈希值的十六进制表示
result = sha256_hash.hexdigest()
```
```python
import hashlib

salt = "U9i%=N+m]#i9yvUV:bA/3n4X9JdPXf=n"
password = "secret"
hash_input = f"{salt}:{password}".encode('utf-8')
password_hash = hashlib.sha256(hash_input).hexdigest()

print(password_hash)  # 应该是你的散列值
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
