#include "/var/lib/gems/2.7.0/gems/ceedling-0.31.1/vendor/unity/src/unity.h"
#include "include/dummy/dummy.h"


void setUp(void) {}

void tearDown(void) {}



void test_dummy(void) { UnityAssertEqualNumber((UNITY_INT)((4U)), (UNITY_INT)((dummy_random())), (

                       ((void *)0)

                       ), (UNITY_UINT)(7), UNITY_DISPLAY_STYLE_INT); }
