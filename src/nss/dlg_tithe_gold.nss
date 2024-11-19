void main()
{
    object oPC = GetPCSpeaker();
    int nGold = StringToInt(GetScriptParam("gold"));
    int nAdjust = StringToInt(GetScriptParam("adjust"));

    if (nGold > 0 && nAdjust > 0 && GetGold(oPC) >= nGold)
    {
        TakeGoldFromCreature(nGold, oPC, TRUE);
        AdjustAlignment(oPC, ALIGNMENT_GOOD, nAdjust, FALSE);
    }
}
