package com.lhauspie.aoc;

public enum Team {
    IMMUNE_SYSTEM,
    INFECTION;

    @Override
    public String toString() {
        if (this == IMMUNE_SYSTEM) return "Immune System";
        if (this == INFECTION) return "Infection";

        return super.toString();
    }
}
