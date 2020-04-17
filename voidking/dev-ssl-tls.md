---
title: "SSL和TLS"
toc: true
date: 2020-03-09 20:00:00
tags:
- tls
- docker
- k8s
categories: 
- [专业,运维,k8s]
---

# SSL和TLS简介
[《Hexo启用https加密连接》](https://www.voidking.com/dev-hexo-https/)和[《CentOS7安装配置GitLab》](https://www.voidking.com/dev-centos7-install-gitlab/)中都涉及到了SSL/TLS，SSL和TLS是啥？

> 传输层安全性协议（英语：Transport Layer Security，缩写：TLS）及其前身安全套接层（英语：Secure Sockets Layer，缩写：SSL）是一种安全协议，目的是为互联网通信提供安全及数据完整性保障。
SSL包含记录层（Record Layer）和传输层，记录层协议确定传输层数据的封装格式。传输层安全协议使用X.509认证，之后利用非对称加密演算来对通信方做身份认证，之后交换对称密钥作为会谈密钥（Session key）。这个会谈密钥是用来将通信两方交换的数据做加密，保证两个应用间通信的保密性和可靠性，使客户与服务器应用之间的通信不被攻击者窃听。

更多内容参考[维基百科-传输层安全性协议](https://zh.wikipedia.org/wiki/%E5%82%B3%E8%BC%B8%E5%B1%A4%E5%AE%89%E5%85%A8%E6%80%A7%E5%8D%94%E5%AE%9A)


<!--more-->

# 相关概念
## PKI
> 公开密钥基础建设（英语：Public Key Infrastructure，缩写：PKI），又称公开密钥基础架构、公钥基础建设、公钥基础设施、公开密码匙基础建设或公钥基础架构，是一组由硬件、软件、参与者、管理政策与流程组成的基础架构，其目的在于创造、管理、分配、使用、存储以及撤销数字证书。
密码学上，公开密钥基础建设借着数字证书认证机构（CA）将用户的个人身份跟公开密钥链接在一起。对每个证书中心用户的身份必须是唯一的。链接关系通过注册和发布过程创建，取决于担保级别，链接关系可能由CA的各种软件或在人为监督下完成。PKI的确定链接关系的这一角色称为注册管理中心（Registration Authority，RA）。RA确保公开密钥和个人身份链接，可以防欺诈。在微软的公开密钥基础建设之下，注册管理中心（RA）又被叫做从属数字证书认证机构（Subordinate CA）。

更多内容参考[维基百科-公开密钥基础架构](https://zh.wikipedia.org/wiki/%E5%85%AC%E9%96%8B%E9%87%91%E9%91%B0%E5%9F%BA%E7%A4%8E%E5%BB%BA%E8%A8%AD)

## CA
> 数字证书认证机构（英语：Certificate Authority，缩写为CA），也称为电子商务认证中心、电子商务认证授权机构，是负责发放和管理数字证书的权威机构，并作为电子商务交易中受信任的第三方，承担公钥体系中公钥的合法性检验的责任。

更多内容参考[维基百科-证书颁发机构](https://zh.wikipedia.org/wiki/%E8%AF%81%E4%B9%A6%E9%A2%81%E5%8F%91%E6%9C%BA%E6%9E%84)

## 数字证书
> 公钥证书（英语：Public key certificate），又称数字证书（digital certificate）或身份证书（identity certificate）。是用于公开密钥基础建设的电子文件，用来证明公开密钥拥有者的身份。此文件包含了公钥信息、拥有者身份信息（主体）、以及数字证书认证机构（发行者）对这份文件的数字签名，以保证这个文件的整体内容正确无误。拥有者凭着此文件，可向电脑系统或其他用户表明身份，从而对方获得信任并授权访问或使用某些敏感的电脑服务。电脑系统或其他用户可以透过一定的程序核实证书上的内容，包括证书有否过期、数字签名是否有效，如果你信任签发的机构，就可以信任证书上的密钥，凭公钥加密与拥有者进行可靠的通信。

> 公钥证书包括自签证书、根证书、中介证书、授权证书、终端实体证书（TLS服务器证书和TLS客户端证书）。

更多内容参考[维基百科-公钥证书](https://zh.wikipedia.org/wiki/%E5%85%AC%E9%96%8B%E9%87%91%E9%91%B0%E8%AA%8D%E8%AD%89)

# 加密原理
TLS/SSL 的功能实现主要依赖于三类基本算法：散列函数 Hash、对称加密和非对称加密。其利用非对称加密实现身份认证和密钥协商，对称加密算法采用协商的密钥对数据加密，基于散列函数验证信息的完整性。
![](http://cdn.voidking.com/@/imgs/ssl-tls/tls.jpg?imageView2/0/w/600)

TLS 的基本工作方式是，客户端使用非对称加密与服务器进行通信，实现身份验证并协商对称加密使用的密钥，然后对称加密算法采用协商密钥对信息以及信息摘要进行加密通信，不同的节点之间采用的对称密钥不同，从而可以保证信息只能通信双方获取。
例如，在 HTTPS 协议中，客户端发出请求，服务端会将公钥发给客户端，客户端验证过后生成一个密钥再用公钥加密后发送给服务端（非对称加密），双方会在 TLS 握手过程中生成一个协商密钥（对称密钥），成功后建立加密连接。通信过程中客户端将请求数据用协商密钥加密后发送，服务端也用协商密钥解密，响应也用相同的协商密钥。后续的通信使用对称加密是因为对称加解密快，而握手过程中非对称加密可以保证加密的有效性，但是过程复杂，计算量相对来说也大。

更多内容参考[SSL/TLS 详解](https://juejin.im/post/5b88a93df265da43231f1451)

# 自建CA并签发证书
[《CentOS7安装配置GitLab》](https://www.voidking.com/dev-centos7-install-gitlab/)一文中，添加SSL一节详细描述了自建CA并签发SSL证书的过程。
更多内容，可以参考[基于OpenSSL自建CA和颁发SSL证书](https://www.yuanjies.com/?p=539)和[使用 OpenSSL 自建 CA 并签发证书](https://zhuanlan.zhihu.com/p/34788439)。

# k8s中证书管理
## 查看证书
1、查看证书位置
```
ps aux | grep kubelet
# find config file
cat /var/lib/kubelet/config.yaml | grep staticPodPath
cd /etc/kubernetes/manifests
cat kube-apiserver.yaml
```

2、查看证书详情
```
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text
```

## 签名
签名，或者签名过期后重新签名
```
openssl x509 -req -in /etc/kubernetes/pki/apiserver-etcd-client.csr -CA /etc/kubernetes/pki/etcd/ca.crt -CAkey /etc/kubernetes/pki/etcd/ca.key -CAcreateserial -out /etc/kubernetes/pki/apiserver-etcd-client.crt
```

## 通过API签名
1、为新用户创建证书
```
openssl genrsa -out jane.key 2048
openssl req -new -key jane.key -subj  "/CN=jane" -out jane.csr
cat jane.csr | base64 | tr -d '\n'
```

2、创建jane-csr.yaml文件
```
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: jane
spec:
  groups:
  - system:authenticated
  usages:
  - digital signature
  - key encipherment
  - server auth
  - client auth
  request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ1ZEQ0NBVHdDQVFBd0R6RU5NQXNHQTFVRUF3d0VhbUZ1WlRDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRApnZ0VQQURDQ0FRb0NnZ0VCQUtxbWFIa3BJeE94dDN2UmxJT1FnSUFxSUFsekhQcTRRVTBDTDVhS04xbmY4NXRzCi9LU3o0eml1a1hEQ1NOSVNIT1pWbTY5NzVJa3RXcGFySmhaTXptc1B2eUFSeXFWbWY2L1h0bmwyeE0xblhaUzAKZGc0b0E1dXFuR0w2dHpaQzF3VFY4RVFIZnRlcWYzbUpTN2JtdlppaXFlak12a2UzVkk5RTNFK0xsUUttNnVXRwprS2RDZ2ZHNUszRGJFczR1VzR6M0lMdTdEa1BlamJodWFtYzlxYVZNRVpLSGZ0bnlBYlFITkZVLzhvWVYvR1VzCnRFVWZMRXBBTmlqUFc5U0pPWHJtNUg1NXhOdExXVHMwenU3YlRSZWE0ZjFVaDFCbkZuUkhWYUJqNysydHpITTgKaklJS01KakdWOS9rUVltRmo3UTJZUW1wYzdXWGpPZEFWcHBSc1kwQ0F3RUFBYUFBTUEwR0NTcUdTSWIzRFFFQgpDd1VBQTRJQkFRQUZ2ZUxrUmYxd0xDQmN6cWdMVkJIUGZBa0MzeU1CTDA3VXl0QUlCcVhkR3h1QWtyL3NQT1dkClNxTkhIRkNzQVNmU0lNVC96djBrQS9yN3Fnd25BMCtZREZJSjNzUlBKZkJmNm1Ic3FrbjlPd1htR1E3d0orNFQKWXVCc1lJSllnNWtzVWJoQVhiQkVZekk2OUY0Uk52U0d0K1ZLOHBBdUQzcXRvejJsd3liV0cvaUo4V3FESTZNegpuMURBeDBkRDZmRWhIKy9DTWdSREY5OExCL1ZqMWZOUUlqZ2k3Rmc1aTByU1NtZUdUMllOblJldERZYWN4aWlzCjNFN1B4STdYWDd2QjRjY3pITlUrTG92N3JnSkVXM3lRMXZRTXRCNTZlbWJaNGVnL01XZEhkeWliVXo2aDQ1ZW8KUGN5b3QxaW1wdFRyK3kwSkt0SmJ1YllQOGd2RG5FeFYKLS0tLS1FTkQgQ0VSVElGSUNBVEUgUkVRVUVTVC0tLS0tCg==
```

3、签名请求并通过
```
kubectl apply -f jane-csr.yaml
kubectl get csr 
kubectl certificate approve jane
kubectl get csr jane -o yaml
kubectl get csr jane -o jsonpath='{.status.certificate}' | base64 --decode > jane.crt
```

或者，直接使用openssl命令进行签名：
```
openssl x509 -req -in /root/jane.csr -CA /etc/kubernetes/pki/etcd/ca.crt -CAkey /etc/kubernetes/pki/etcd/ca.key -CAcreateserial -out /root/jane.crt
```

PS：查看签名用的CA
```
cat /etc/kubernetes/manifests/kube-controller-manager.yaml | grep ca.crt
cat /etc/kubernetes/manifests/kube-controller-manager.yaml | grep ca.key
```

更多内容，参考[Manage TLS Certificates in a Cluster](https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/)。

# 证书格式转换
X.509是一种证书标准，定义了证书中应该包含哪些内容，详情参考RFC5280，SSL使用的就是这种证书标准。
同样的X.509证书，可能有不同的编码格式，目前有以下两种编码格式。
PEM：Privacy Enhanced Mail，BASE64编码，以"-----BEGIN-----"开头，"-----END-----"结尾。
查看PEM格式证书的信息：
`openssl x509 -in cert.pem -text -noout`

DER：Distinguished Encoding Rules，二进制格式，不可读。
查看DER格式证书的信息：
`openssl x509 -in cert.der -inform der -text -noout`

问题来了，k8s中的证书，除了使用pem格式，还有就是crt格式，并没有der格式啊？这是因为，crt只是一个文件后缀，编码格式可能是pem也可能是der。

那么，pem和der怎样互相转换呢？
```
# pem to der
openssl x509 -in cert.crt -outform der -out cert.der
# der to pem
openssl x509 -in cert.crt -inform der -outform pem -out cert.pem
```

# 书签
[OpenSSL 与 SSL 数字证书概念贴](https://segmentfault.com/a/1190000002568019)
[SSL/TLS 原理详解](https://cloud.tencent.com/developer/article/1114555)
