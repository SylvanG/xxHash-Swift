//
//  xxHash_module.h
//  
//
//  Created by Shuaihu Wang on 2022/10/18.
//

#ifndef xxHash_module_h
#define xxHash_module_h

#include "../xxHash/xxhash.h"

/* see https://github.com/Cyan4973/xxHash/blob/v0.8.1/xxh_x86dispatch.c */
#if defined(__x86_64__) || defined(__i386__) || defined(_M_IX86) || defined(_M_X64)
#  include "../xxHash/xxh_x86dispatch.h"
#endif

#endif /* xxHash_module_h */
