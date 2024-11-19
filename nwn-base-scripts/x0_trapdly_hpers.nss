
//::///////////////////////////////////////////////////
//:: X0_TRAPDLY_HPRES
//:: OnTriggered script for a projectile trap
//:: Spell fired: SPELL_HOLD_PERSON
//:: Spell caster level: 12
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/17/2002
//::///////////////////////////////////////////////////

#include "x0_i0_projtrap"

void main()
{
    TriggerProjectileTrap(SPELL_HOLD_PERSON, GetEnteringObject(), 12);
}

