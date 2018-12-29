package com.lhauspie.aoc;

public enum AttackType {
    FIRE,
    COLD,
    SLASHING,
    RADIATION,
    BLUDGEONING;

    public static AttackType fromValue(String str) {
        AttackType result;
        if ("fire".equals(str)) {
            result = FIRE;
        } else if ("cold".equals(str)) {
            result = COLD;
        } else if ("slashing".equals(str)) {
            result = SLASHING;
        } else if ("radiation".equals(str)) {
            result = RADIATION;
        } else if ("bludgeoning".equals(str)) {
            result = BLUDGEONING;
        } else {
            throw new RuntimeException("PROOOOOOOOBLEEEEEEEEEM");
        }
        return result;
    }
}
