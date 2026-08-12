# UBiMAX 亿帆适配器接入说明

## 1. 说明

`UBiMAXYiFanAdapter` 用于在 **UBiMAX 聚合体系** 中接入 **亿帆广告 SDK**。

当前支持：
- 开屏：`UMTYFSplashAdapter`
- 插屏：`UMTYFInterstitialAdapter`

---

## 2. 版本信息

- 适配器：`UBiMAXYiFanAdapter`
- 当前版本：`6.1.4.0`
- 最低支持 iOS：`11.0`

---

## 3. Pod 接入

### 3.1 基础依赖

```ruby
pod 'UBiddingAdSDK', '4.0.1'
pod 'UBiddingUBiXAdapter', '2.11.0.1'
```

### 3.2 亿帆适配器及依赖

亿帆SDK对接文档：[亿帆SDK技术对接文档](https://qx4iltcdihd.feishu.cn/wiki/CXMqwZzHXiBecikGlhPcYe34nQd)

```ruby
# 亿帆SDK【必须】
pod 'YFAdsOLSDK', '6.1.4.0'
#  百度【必须】
pod 'BaiduMobAdSDK','10.050'
# 优量汇【必须】
pod 'GDTMobSDK' ,'4.16.00'
# 京东【必须】
pod 'JADYun', '2.6.8'
pod 'JADYunMotion', '2.6.8'  #京东摇一摇组件
# 穿山甲【必须】⚠️注意：旧版本有 按照2.3-1方式集成 的，需要去掉 TTSDKFramework
pod 'Ads-CN', '7.7.0.5', :subspecs => ['BUAdSDK','CSJMediation','BUAdLive-Framework']
# Gromore-Adn适配器
pod 'GMBaiduAdapter', '10.050.1'
pod 'GMGdtAdapter', '4.15.80.2'
pod 'GMKsAdapter', '5.3.20.1.2'
# 快手【必须】
pod 'KSAdSDK','5.6.10.1'
# 微信OpenSDK【必须】，如App内已通过其他方式集成OpenSDK，无需再次集成
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

