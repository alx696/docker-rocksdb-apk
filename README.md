## 说明

Alpine的已经提供rocksdb安装包，但是[不支持老CPU](https://tracker.ceph.com/issues/20529#note-14)（SSE4.2）。此镜像使用RocksDB官方源码，通过编译时设置`PORTABLE=1`来关闭SSE4.2。另外一个优势apk包形式的rocksdb体积非常小，是共享库（so）的百分之一。

RocksDB的apk安装包路径为：

* `/rocksdb-dev.apk`
* `/rocksdb.apk`

> [RocksDB的APK构建脚本来源](https://git.alpinelinux.org/aports/tree/testing/rocksdb?h=master)，[RocksDB编译说明](https://github.com/facebook/rocksdb/blob/master/INSTALL.md#compilation)，执行`$ lscpu`查看标记中是否有`sse4_2`以确认CPU是否支持SSE4.2。

---

### 构建镜像

```
$ docker build -t registry.cn-shanghai.aliyuncs.com/xm69/alpine-rocksdb-apk .
```

### 使用apk

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
