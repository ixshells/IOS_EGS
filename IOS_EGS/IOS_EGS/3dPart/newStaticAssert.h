#ifndef _new_STATICASSERT_H_
#define _new_STATICASSERT_H_

#include <cassert>

#ifndef _new_STATIC_ASSERT_

#define newStaticAssert(value) static_assert(value, "Invalid Parameters!")

#else

#if defined(DEBUG) || defined(_DEBUG)

template<bool K>
struct newStaticAssert_ ;

template<>
struct newStaticAssert_<true> { int dummy; };

template<int n>
struct newStaticAssert {};

#define newStaticAssert(value) do \
{\
	typedef newStaticAssert<\
	sizeof(newStaticAssert_<(bool)(value)>)\
	> newStaticAssert__;\
} while (0)

#else

#define newStaticAssert(...) 

#endif

#endif

#endif //_new_STATICASSERT_H_
