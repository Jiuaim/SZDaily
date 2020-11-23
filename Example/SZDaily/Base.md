// BaseViewController --- 取消请求方案(NSPointArray)
1.子类通过cancelRequestIfNeed控制是否实施取消请求方案
2.子类通过appendRequestForPointArray:添加请求
3.dealloc中遍历allRequest进行请求取消
/*注意点：block强弱引用，dispatch_group_leave判空，weak使用*/

