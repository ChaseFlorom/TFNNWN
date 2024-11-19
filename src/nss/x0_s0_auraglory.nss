//::///////////////////////////////////////////////
//:: Aura of Glory
//:: x0_s0_auraglory.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 +2 Charisma Bonus
 All allies in medium area of effect: +5 Saves against Fear
 All allies in medium area of effect: 1d4 hitpoints healing
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 24, 2002
//:://////////////////////////////////////////////
//:: Last Update By: Andrew Nobbs May 07, 2003
/*
Patch 1.71

- healing was rolled once for all allies, not once per ally.
*/

#include "70_inc_spells"
#include "x0_i0_spells"
#include "x2_inc_spellhook"

void main()
{
    //1.72: pre-declare some of the spell informations to be able to process them
    spell.DurationType = SPELL_DURATION_TYPE_TURNS;
    spell.Range = RADIUS_SIZE_COLOSSAL;
    spell.TargetType = SPELL_TARGET_ALLALLIES;

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    spellsDeclareMajorVariables();
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);

    effect eChar = EffectAbilityIncrease(ABILITY_CHARISMA, 4);

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eChar, eDur);

    int nDuration = spell.Level; // * Duration 1 turn/level
    if (spell.Meta & METAMAGIC_EXTEND) //Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    //Apply VFX impact and bonus effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, spell.Target);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, spell.Target, DurationToSeconds(nDuration));

    // * now setup benefits for allies
        //Apply Impact
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
    float fDelay = 0.0;
    eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    effect eHeal;
    effect eFear = EffectSavingThrowIncrease(SAVING_THROW_ALL, 5, SAVING_THROW_TYPE_FEAR);
    eLink = EffectLinkEffects(eFear, eDur);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, spell.Loc);

    //Get the first target in the radius around the caster
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, spell.Range, spell.Loc, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, spell.TargetType, spell.Target))
        {
            fDelay = GetRandomDelay(0.4, 1.1);
            eHeal = EffectHeal(MaximizeOrEmpower(4,1, spell.Meta));
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(spell.Target, spell.Id, FALSE));
            //Apply VFX impact and bonus effects
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, DurationToSeconds(nDuration)));
        }
        //Get the next target in the specified area around the caster
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, spell.Range, spell.Loc, TRUE);
    }
}
