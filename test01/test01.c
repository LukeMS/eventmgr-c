#include <stdio.h>

#include "eventmgr.h"

int fake_input_handler(void* data) {
    printf("fake_input_handler called (skip it)\n");

    return 0;
}

int real1_input_handler(void* data) {
    printf("real1_input_handler called (data=\"%s\")\n", (char *) data);

    // propagation stops
    return -1;
}

int real2_input_handler(void* data) {
    printf("real2_input_handler called (data=\"%s\")\n", (char *) data);

    // propagation continues
    return 1;
}

int main(void)
{
    puts("al_test0001_event_watcher!!!");
    EventMgr* evtmgr = EventMgr_create();

    puts("\nfake should warn, only real1 should catch");
    evtmgr->watch(evtmgr, "input", fake_input_handler);
    evtmgr->watch(evtmgr, "input", real1_input_handler);
    evtmgr->watch(evtmgr, "input", real2_input_handler);
    evtmgr->trigger(evtmgr, "input", (void*) "test_input");

    puts("\nfake should warn, real1 + real2 should catch");
    evtmgr->unwatch(evtmgr, "input", real1_input_handler);
    evtmgr->watch(evtmgr, "input",   real1_input_handler);
    evtmgr->trigger(evtmgr, "input", (void*) "test_input");

    puts("\nonly real1 should catch");
    evtmgr->unwatch(evtmgr, "input", fake_input_handler);
    evtmgr->unwatch(evtmgr, "input", real2_input_handler);
    evtmgr->unwatch(evtmgr, "foo", fake_input_handler);
    evtmgr->trigger(evtmgr, "input", (void*) "test_input");

    EventMgr_destroy(evtmgr);

    return 0;
}