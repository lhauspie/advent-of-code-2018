package com.lhauspie.aoc;

import javax.xml.ws.Holder;
import java.util.*;
import java.util.function.Function;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class Group implements Comparable {
    private static final Pattern pattern = Pattern.compile("^(\\d+) units each with (\\d+) hit points (?:\\((?:(weak|immune) to ([\\w\\s,]*))?(?:; )?(?:(weak|immune) to (.*?))?\\) )?with an attack that does (\\d+) (\\w*) damage at initiative (\\d+)$");

    public Team team;
    public int id;
    public int units;
    public int hitPoints;
    public int attackDamage;
    public AttackType attackType;
    public int initiative;
    public List<AttackType> weaknesses = new ArrayList<>();
    public List<AttackType> immunities = new ArrayList<>();

    public boolean targeted = false;
    public Optional<Group> target = Optional.empty();

    public Group(Team team, String str) {
        this.team = team;
        Matcher matcher = pattern.matcher(str);
        if (matcher.find()) {
            this.units = Integer.valueOf(matcher.group(1));
            this.hitPoints =  Integer.valueOf(matcher.group(2));
            this.attackDamage = Integer.valueOf(matcher.group(7));
            this.attackType = AttackType.fromValue(matcher.group(8));
            this.initiative = Integer.valueOf(matcher.group(9));

            if (matcher.group(3) != null) {
                List<AttackType> group4 = Arrays.stream(matcher.group(4).split(", ")).map(AttackType::fromValue).collect(Collectors.toList());
                if ("weak".equals(matcher.group(3))) {
                    this.weaknesses = group4;
                }
                if ("immune".equals(matcher.group(3))) {
                    this.immunities = group4;
                }
            }
            if (matcher.group(5) != null) {
                List<AttackType> group6 = Arrays.stream(matcher.group(6).split(", ")).map(AttackType::fromValue).collect(Collectors.toList());
                if ("weak".equals(matcher.group(5))) {
                    this.weaknesses = group6;
                }
                if ("immune".equals(matcher.group(5))) {
                    this.immunities = group6;
                }
            }
        }
    }

    public int getEffectivePower() {
        return units * attackDamage;
    }

    @Override
    public int compareTo(Object other) {
        int compare = Integer.compare(((Group)other).getEffectivePower(), this.getEffectivePower());
        return (compare == 0 ? Integer.compare(((Group) other).initiative, this.initiative) : compare);
    }

    public void selectTarget(List<Group> groups) {
//        groups.stream()
//            .filter(g -> this.team != g.team) // select only enemies
//            .filter(g -> g.units > 0) // select only group with alive units
//            .filter(g -> !g.targeted) // select only available groups
//            .filter(g -> this.damageTo(g) > 0) // select only groups that can damage a defending one
//            .sorted(Comparator.comparing(Function.identity(), (a, b) -> {
//                int damageComparison = Integer.compare(this.damageTo(b), this.damageTo(a));
//                return damageComparison == 0 ? a.compareTo(b) : damageComparison;
//            }))
//            .forEach(g -> System.out.println(this.team+" group "+this.id+" would deal defending group "+g.id+" " + this.damageTo(g) + " damage"));

        this.target = groups.stream()
                .filter(g -> this.team != g.team) // select only enemies
                .filter(g -> g.units > 0) // select only group with alive units
                .filter(g -> !g.targeted) // select only available groups
                .filter(g -> this.damageTo(g) > 0) // select only groups that can damage a defending one
                .sorted(Comparator.comparing(Function.identity(), (a, b) -> {
                    int damageComparison = Integer.compare(this.damageTo(b), this.damageTo(a));
                    return damageComparison == 0 ? a.compareTo(b) : damageComparison;
                }))
                .findFirst();
//        System.out.println("selected defending group " + this.target.map(g -> g.id).orElse(null));
        this.target.ifPresent(group -> group.targeted = true);
    }

    public int damageTo(Group target) {
        int damage;
        if (target.immunities.contains(this.attackType)) {
            damage = 0;
        } else if (target.weaknesses.contains(this.attackType)) {
            damage = getEffectivePower() * 2;
        } else {
            damage = getEffectivePower();
        }
        return damage;
    }

    public int attackTarget() {
        Holder<Integer> unitsKilled = new Holder<>(0);
        if (this.units > 0) { // I can attack my target only if I still have units
            this.target.ifPresent(target -> {
                int damage = (this.damageTo(target) / target.hitPoints);
                int units = Math.min(damage, target.units);
                target.units -= units;
                unitsKilled.value = units;
//                System.out.println(this.team + " group " + this.id + " attacks defending group "+target.id + ", killing "+units+" units / remaining "+target.units); // because of "+this.damageTo(target)+ " damage");
            });
        }
        return unitsKilled.value;
    }
}
