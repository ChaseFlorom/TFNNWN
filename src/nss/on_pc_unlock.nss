#include "nwnx_events"
#include "inc_horse"

void main()
{
    if (GetIsMounted(OBJECT_SELF))
    {
        SendMessageToPC(OBJECT_SELF, "You cannot open locks while mounted.");
        NWNX_Events_SkipEvent();
    }
}
