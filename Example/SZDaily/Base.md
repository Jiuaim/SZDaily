// BaseViewController --- 取消请求方案(NSPointArray)
1.子类通过cancelRequestIfNeed控制是否实施取消请求方案
2.子类通过appendRequestForPointArray:添加请求
3.dealloc中遍历allRequest进行请求取消
/*注意点：block强弱引用，dispatch_group_leave判空，weak使用*/

// 资源清空方案
1.页面切换或者前后台切换清空可以清理的资源
2.页面滑出可视区清空资源
3.标记资源优先级，在内存吃紧的时候清空低优先级资源
4.用户行为检测，服务端分发动态配置资源优先级以及清空资源方案

// Timer停止方案
