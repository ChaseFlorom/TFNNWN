//::///////////////////////////////////////////////
//:: Dragon Breath Paralyze
//:: NW_S1_DragParal
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calculates the proper DC Save for the
    breath weapon based on the HD of the dragon.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 9, 2001
//:://////////////////////////////////////////////
/*
Patch 1.72
- fixed casting the spell on self not finding any targets in AoE
- effects made supernatural (not dispellable)
Patch 1.70
- wrong target check (could affect other NPCs)
- wrong duration scaling calculation (cumulative for each target in AoE)
- added scaling of the effect by difficulty
- added saving throw subtype (paralyse)
> breath weapon damage and DC calculation changed in order to allow higher values
for custom content dragons with 40+ HD. DC calculation is now 10+1/2 dragon's HD+
dragon's constitution modifier.
*/

#include "70_inc_dragons"
#include "x0_i0_spells"

void main()
{
    //Declare major variables
    int nAge = GetHitDice(OBJECT_SELF);
    int nDC = GetDragonBreathDC();
    int nDuration = GetDragonBreathNumDice()/2;
    float fDelay;
    effect scaledEffect;
    int scaledDuration;
    effect eBreath = EffectParalyze();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
    effect eParal = EffectVisualEffect(VFX_DUR_PARALYZED);

    effect eLink = EffectLinkEffects(eDur2, eDur);
    eLink = EffectLinkEffects(eLink, eParal);

    location lTargetLocation = GetSpellTargetLocation();
    if(lTargetLocation == GetLocation(OBJECT_SELF))
    {
        vector vFinalPosition = GetPositionFromLocation(lTargetLocation);
        vFinalPosition.x+= cos(GetFacing(OBJECT_SELF));
        vFinalPosition.y+= sin(GetFacing(OBJECT_SELF));
        lTargetLocation = Location(GetAreaFromLocation(lTargetLocation),vFinalPosition,GetFacingFromLocation(lTargetLocation));
    }

    PlayDragonBattleCry();
    //Get first target in spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 14.0, lTargetLocation, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DRAGON_BREATH_PARALYZE));
            //Determine the effect delay time
            fDelay = GetDistanceBetween(oTarget, OBJECT_SELF)/20;
            //Make a saving throw check
            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, /*SAVING_THROW_TYPE_PARALYSE*/20, OBJECT_SELF, fDelay))
            {
                scaledDuration = GetScaledDuration(nDuration, oTarget);
                scaledEffect = GetScaledEffect(eBreath, oTarget);
                scaledEffect = SupernaturalEffect(EffectLinkEffects(eLink, scaledEffect));
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, scaledEffect, oTarget, RoundsToSeconds(scaledDuration)));
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 14.0, lTargetLocation, TRUE);
    }
}