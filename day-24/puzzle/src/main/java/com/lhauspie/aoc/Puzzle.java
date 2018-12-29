package com.lhauspie.aoc;

import javax.xml.ws.Holder;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Puzzle {

    public static int step1() {
        List<Group> groups = new ArrayList<>();
        final Holder<Team> currentTeam = new Holder<>();
        final Holder<Integer> id = new Holder<>();

        try (Stream<String> stream = Files.lines(Paths.get("input.txt"))) {
            List<String> lines = stream.collect(Collectors.toList());
            for (String line : lines) {
                if ("Immune System:".equals(line)) {
                    currentTeam.value = Team.IMMUNE_SYSTEM;
                    id.value = 1;
                } else if ("Infection:".equals(line)) {
                    currentTeam.value = Team.INFECTION;
                    id.value = 1;
                } else if (!"".equals(line)) {
                    Group group = new Group(currentTeam.value, line);
                    group.id = id.value;
                    groups.add(group);
                    id.value++;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }


        int count = 0;
        while (groups.stream().map(g -> g.team).distinct().count() > 1) {
//            System.out.println("====================== ONE MORE FIGHT !! ==============");
            count++;
            final List<Group> groupssss = groups; // vieille gruge de sioux !!
            Collections.sort(groups);
            groups.forEach(g -> g.targeted = false);
            groups.forEach(g -> g.selectTarget(groupssss));
//            System.out.println("");
            groups.sort(Comparator.comparingInt(g -> -g.initiative));
            groups.forEach(g -> g.attackTarget());
            groups = groups.stream().filter(g -> g.units > 0).collect(Collectors.toList());
        }
        return groups.stream().mapToInt(g -> g.units).sum();
    }

    public static int step2() {
        int boost = 0;
        while (true) {
            List<Group> groups = new ArrayList<>();
            final Holder<Team> currentTeam = new Holder<>();
            final Holder<Integer> id = new Holder<>();

            try (Stream<String> stream = Files.lines(Paths.get("input.txt"))) {
                List<String> lines = stream.collect(Collectors.toList());
                for (String line : lines) {
                    if ("Immune System:".equals(line)) {
                        currentTeam.value = Team.IMMUNE_SYSTEM;
                        id.value = 1;
                    } else if ("Infection:".equals(line)) {
                        currentTeam.value = Team.INFECTION;
                        id.value = 1;
                    } else if (!"".equals(line)) {
                        Group group = new Group(currentTeam.value, line);
                        group.id = id.value;
                        if (group.team == Team.IMMUNE_SYSTEM) {
                            group.attackDamage += boost;
                        }
                        groups.add(group);
                        id.value++;
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            }

            int unitsKilled = -1;
            while (groups.stream().map(g -> g.team).distinct().count() > 1 && unitsKilled != 0) {
//                System.out.println("====================== ONE MORE FIGHT !! ==============");
                final List<Group> groupssss = groups; // vieille gruge de sioux !!
                Collections.sort(groups);
                groups.forEach(g -> g.targeted = false);
                groups.forEach(g -> g.selectTarget(groupssss));
//                System.out.println("");
                groups.sort(Comparator.comparingInt(g -> -g.initiative));
                unitsKilled = groups.stream().mapToInt(g -> g.attackTarget()).sum();
                groups = groups.stream().filter(g -> g.units > 0).collect(Collectors.toList());
            }

            if (unitsKilled > 0 && groups.stream().map(g -> g.team).distinct().findFirst().get() == Team.IMMUNE_SYSTEM) {
                return groups.stream().mapToInt(g -> g.units).sum();
            }
            boost++;
        }
    }

    public static void main(String[] args) {
        System.out.println("step 1 : " + step1());
        System.out.println("step 2 : " + step2());
    }
}
