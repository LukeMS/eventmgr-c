#ifndef EVENTMGR
#define EVENTMGR_H

#include <stdlib.h>

#include "zhash.h"

typedef struct EventMgr_ EventMgr;

typedef struct EventMgr_ {
    struct ZHashTable* callbacks;
    void (*watch) (EventMgr* evtmgr, char* id, int (*callback)(void* data));
    void (*unwatch) (EventMgr* evtmgr, char* id, int (*callback)(void* data));
    void (*trigger) (EventMgr* evtmgr, char* id, void* data);
} EventMgr;

typedef int EventMgr_callback(void*);

EventMgr* EventMgr_create(void);

void EventMgr_destroy(EventMgr* obj);

void EventMgr_watch(EventMgr* evem, char* id, int (*callback)(void* data));

void EventMgr_unwatch(EventMgr* evem, char* id, int (*callback)(void* data));

void EventMgr_trigger(EventMgr* evem, char* id, void* data);

#endif
