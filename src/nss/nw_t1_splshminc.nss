//::///////////////////////////////////////////////
//:: Minor Acid Splash Trap
//:: NW_T1_SplshMinC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Strikes the entering object with a blast of
    cold for 2d8 damage. Reflex save to take
    1/2 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 16th , 2001
//:://////////////////////////////////////////////
#include "nw_i0_spells"
#include "inc_trap"

void main()
{
    //1.72: fix for bug where traps are being triggered where they really aren't
    if(GetObjectType(OBJECT_SELF) == OBJECT_TYPE_TRIGGER && !GetIsInSubArea(GetEnteringObject()))
    {
        return;
    }
    //Declare major variables
    object oTarget = GetEnteringObject();
    int nDamage = d8(2);
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S, FALSE, TRAP_VFX_SIZE_MINOR);

    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, 12, SAVING_THROW_TYPE_TRAP);

    eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    SetTrapTriggeredOnCreature(oTarget, "minor acid splash trap");
}

