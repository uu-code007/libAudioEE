//
//  mm_effect_common.hpp
//  effectsEngine
//
//  Created by 孙慕 on 2022/1/26.
//

#ifndef mm_effect_common_hpp
#define mm_effect_common_hpp

#include <stdio.h>

#ifdef _MSC_VER
#    ifdef SDK_EXPORTS
#        define QN_SDK_API_ __declspec(dllexport)
#    else
#        define QN_SDK_API_
#    endif
#else /* _MSC_VER */
#    ifdef SDK_EXPORTS
#        define QN_SDK_API_ __attribute__((visibility ("default")))
#    else
#        define QN_SDK_API_
#    endif
#endif

#ifdef __cplusplus
#    define QN_SDK_API extern "C" QN_SDK_API_
#else
#    define QN_SDK_API QN_SDK_API_
#endif

typedef void *mm_handle_t;

/// 结果声明，常用于表示运行结果，QN_OK正常， 不正常则返回相应的错误码
typedef int   mm_result_t;

#define QN_OK                               0   ///< 正常运行

#define QN_E_INVALIDARG                     -1  ///< 无效参数
#define QN_E_HANDLE                         -2  ///< 句柄错误
#define QN_E_OUTOFMEMORY                    -3  ///< 内存不足
#define QN_E_FAIL                           -4  ///< 内部错误
#define QN_E_DELNOTFOUND                    -5  ///< 定义缺失
///


#endif /* mm_effect_common_hpp */
