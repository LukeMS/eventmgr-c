#include <stdio.h>

#include "eventmgr.h"
#include "dlist.h"


EventMgr* EventMgr_create(void) {
    EventMgr* new = malloc(sizeof(*new));

    new->callbacks = zcreate_hash_table();
    new->watch = EventMgr_watch;
    new->unwatch = EventMgr_unwatch;
    new->trigger = EventMgr_trigger;

    return new;
}

void EventMgr_destroy(EventMgr* obj) {

    struct ZHashTable *hash_table = obj->callbacks;
    DList *watchers = NULL;
    struct ZHashEntry *next, *p = hash_table->head;
    while(p != NULL) {
        // keep the reference to the next entry before 'p' is deleted
        next = p->lnknext;

        // delete the entry with p's key and assign the value to watchers
        watchers = zhash_delete(hash_table, p->key);

        if (watchers != NULL) {
            dlist_destroy(watchers);
            free(watchers);
        }
        p = next;
    }

    zfree_hash_table(obj->callbacks);

    free(obj);
}

DListElmt* EventMgr_exist(EventMgr* evem, char* id, int (*callback)(void* data)) {
    // check if the event has any watcher
    if (zhash_exists(evem->callbacks, id)) {
        DList* watchers = NULL;
        if((watchers = zhash_get(evem->callbacks, id))) {
            DListElmt* elmt = watchers->head;
            while (elmt != NULL) {
                if ((EventMgr_callback*)(elmt->data) ==
                        (EventMgr_callback*)(callback)) {
                    return elmt;
                }
                elmt = elmt->next;
            }
        }
    }

    return NULL;

}

void EventMgr_unwatch(EventMgr* evem, char* id, int (*callback)(void* data)) {
    // if any callbacks for this id
    if (zhash_exists(evem->callbacks, id)) {
        DList* watchers = NULL;
        if((watchers = zhash_get(evem->callbacks, id))) {
            DListElmt* elmt;
            // if this callbacks for this id
            if ((elmt = EventMgr_exist(evem, id, callback))) {
                void *tmp = NULL;
                // remove it
                dlist_remove(watchers, elmt, &tmp);
            }
        }
    }
    return;
}

void EventMgr_watch(EventMgr* evem, char* id, int (*callback)(void* data)) {
    DList* watchers = NULL;
    void* exist;

    if (zhash_exists(evem->callbacks, id)) {
        watchers = zhash_get(evem->callbacks, id);
    } else {
        watchers = malloc(sizeof(*watchers));
        dlist_init(watchers, NULL);
    }
    if (!(exist = EventMgr_exist(evem, id, callback)))
        zhash_set(evem->callbacks, id, watchers);

    dlist_ins_next(watchers, dlist_tail(watchers), callback);

    return;
}

void EventMgr_trigger(EventMgr* evem, char* id, void* data){
    DList* watchers = NULL;
    if (zhash_exists(evem->callbacks, id)) {
        if((watchers = zhash_get(evem->callbacks, id))) {
            DListElmt* elmt = watchers->head;
            while (elmt != NULL) {
                if (((EventMgr_callback*)(elmt->data))(data) == -1)
                    break;
                elmt = elmt->next;
            }
        }
    } else
        return;
}
