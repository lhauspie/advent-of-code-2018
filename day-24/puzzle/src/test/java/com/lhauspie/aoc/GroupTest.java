package com.lhauspie.aoc;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Unit test for simple Puzzle.
 */
public class GroupTest extends TestCase {
    /**
     * Create the test case
     *
     * @param testName name of the test case
     */
    public GroupTest(String testName) {
        super(testName);
    }

    /**
     * @return the suite of tests being tested
     */
    public static Test suite() {
        return new TestSuite(GroupTest.class);
    }

    /**
     * Rigourous Test :-)
     */
    public void testApp() {
        Group group1 = new Group(Team.IMMUNE_SYSTEM, "18 units each with 729 hit points (weak to fire; immune to cold, slashing) with an attack that does 8 radiation damage at initiative 10");
        assertEquals(Team.IMMUNE_SYSTEM, group1.team);
        assertEquals(18, group1.units);
        assertEquals(729, group1.hitPoints);
        assertTrue(Arrays.asList(AttackType.FIRE).containsAll(group1.weaknesses) && group1.weaknesses.containsAll(Arrays.asList(AttackType.FIRE)));
        assertTrue(Arrays.asList(AttackType.COLD, AttackType.SLASHING).containsAll(group1.immunities) && group1.immunities.containsAll(Arrays.asList(AttackType.COLD, AttackType.SLASHING)));
        assertEquals(8, group1.attackDamage);
        assertEquals(AttackType.RADIATION, group1.attackType);
        assertEquals(10, group1.initiative);

        Group group2 = new Group(Team.INFECTION, "801 units each with 4706 hit points (weak to radiation) with an attack that does 116 bludgeoning damage at initiative 1");
        assertEquals(Team.INFECTION, group2.team);
        assertEquals(801, group2.units);
        assertEquals(4706, group2.hitPoints);
        assertTrue(Arrays.asList(AttackType.RADIATION).containsAll(group2.weaknesses) && group2.weaknesses.containsAll(Arrays.asList(AttackType.RADIATION)));
        assertEquals(0, group2.immunities.size());
        assertEquals(116, group2.attackDamage);
        assertEquals(AttackType.BLUDGEONING, group2.attackType);
        assertEquals(1, group2.initiative);
    }

    public void testTargetSelection() {
        Group group;
        List<Group> groups = new ArrayList<>();
        groups.add(new Group(Team.IMMUNE_SYSTEM, "17 units each with 5390 hit points (weak to radiation, bludgeoning) with an attack that does 4507 fire damage at initiative 2"));
        groups.add(new Group(Team.IMMUNE_SYSTEM, "989 units each with 1274 hit points (immune to fire; weak to bludgeoning, slashing) with an attack that does 25 slashing damage at initiative 3"));
        groups.add(new Group(Team.INFECTION, "801 units each with 4706 hit points (weak to radiation) with an attack that does 116 bludgeoning damage at initiative 1"));
        groups.add(new Group(Team.INFECTION, "4485 units each with 2961 hit points (immune to radiation; weak to fire, cold) with an attack that does 12 slashing damage at initiative 4"));

        groups.get(0).id = 1;
        groups.get(1).id = 2;
        groups.get(2).id = 1;
        groups.get(3).id = 2;

        Collections.sort(groups);
        groups.forEach(System.out::println);

        group = groups.get(0);
        assertEquals(801, group.units);
        group.selectTarget(groups);
        assertEquals(17, group.target.get().units);

        group = groups.get(1);
        assertEquals(17, group.units);
        group.selectTarget(groups);
        assertEquals(4485, group.target.get().units);

        group = groups.get(2);
        assertEquals(4485, group.units);
        group.selectTarget(groups);
        assertEquals(989, group.target.get().units);

        group = groups.get(3);
        assertEquals(989, group.units);
        group.selectTarget(groups);
        assertEquals(801, group.target.get().units);

        groups.sort(Comparator.comparingInt(g -> -g.initiative));

        groups.get(0).attackTarget();
        groups.get(1).attackTarget();
        groups.get(2).attackTarget();
        groups.get(3).attackTarget();

        groups.forEach(System.out::println);

        // ================================================================================================

        groups = groups.stream().filter(g -> g.units > 0).collect(Collectors.toList());
        Collections.sort(groups);
        groups.forEach(g -> g.targeted = false);

        group = groups.get(0);
        assertEquals(797, group.units);
        group.selectTarget(groups);
        assertEquals(905, group.target.get().units);

        group = groups.get(1);
        assertEquals(4434, group.units);
        group.selectTarget(groups);
        assertEquals(Optional.empty(), group.target);

        group = groups.get(2);
        assertEquals(905, group.units);
        group.selectTarget(groups);
        assertEquals(797, group.target.get().units);

        groups.sort(Comparator.comparingInt(g -> -g.initiative));

        groups.get(0).attackTarget();
        groups.get(1).attackTarget();
        groups.get(2).attackTarget();

        groups.forEach(System.out::println);
    }
}
