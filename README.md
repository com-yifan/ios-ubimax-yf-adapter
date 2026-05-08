# UBiMAX 亿帆适配器接入说明

## 1. 说明

`UBiMAXYiFanAdapter` 用于在 **UBiMAX 聚合体系** 中接入 **亿帆广告 SDK**。

当前支持：
- 开屏：`UMTYFSplashAdapter`
- 插屏：`UMTYFInterstitialAdapter`

---

## 2. 版本信息

- 适配器：`UBiMAXYiFanAdapter`
- 当前版本：`6.1.1.0`
- 最低支持 iOS：`11.0`

---

## 3. Pod 接入

### 3.1 基础依赖

```ruby
pod 'UBiMAXAdSDK', '1.5.0'
pod 'UBiMAXSplash', '1.1.0'
pod 'UBiMAXInterstitial', '1.2.0'
```

### 3.2 亿帆适配器及依赖

亿帆SDK对接文档：[亿帆SDK技术对接文档](https://qx4iltcdihd.feishu.cn/wiki/CXMqwZzHXiBecikGlhPcYe34nQd)

```ruby
# 亿帆 SDK
pod 'YFAdsSDK', '6.1.1.0'
# 亿帆适配器
pod 'UBiMAXYiFanAdapter', '6.1.1.0'
# 百度
pod 'BaiduMobAdSDK', '10.050'
# 优量汇
pod 'GDTMobSDK', '4.15.80'
# 京东
pod 'JADYun', '2.6.8'
pod 'JADYunMotion', '2.6.8'
# 穿山甲
pod 'Ads-CN', '7.5.0.7', :subspecs => ['BUAdSDK', 'CSJMediation', 'BUAdLive-Framework']
# Gromore Adn 适配器
pod 'GMBaiduAdapter', '10.032.1'
pod 'GMGdtAdapter', '4.15.75.0'
pod 'GMKsAdapter', '4.12.20.1.0'
# 快手
pod 'KSAdSDK', '5.3.20.1'
# 微信 OpenSDK
pod 'WechatOpenSDK-XCFramework'
```

安装命令：

```bash
pod install
```



---

## 4. 类名映射

| 功能 | 类名 |
|---|---|
| 初始化配置 | `UMTYFConfigAdapter` |
| 开屏广告 | `UMTYFSplashAdapter` |
| 插屏广告 | `UMTYFInterstitialAdapter` |

