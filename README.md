## 说明

包含RocksDB的apk安装包的镜像：

* `/rocksdb-dev.apk`
* `/rocksdb.apk`

### 构建

```
$ docker build -t registry.cn-shanghai.aliyuncs.com/xm69/alpine-rocksdb-apk .
```

### 使用

在Dockerfile前面增加构建阶段：
```
FROM registry.cn-shanghai.aliyuncs.com/xm69/alpine-rocksdb-apk AS rocksdb
```

在Dockerfile打包镜像时复制并安装：
```
# 安装RocksDB
COPY --from=rocksdb /rocksdb.apk .
RUN set -eux && \
  apk add --update --no-cache --allow-untrusted rocksdb.apk && \
  rm rocksdb.apk
```
> 如果是编译Golang应用，应该复制安装rocksdb-dev.apk。
