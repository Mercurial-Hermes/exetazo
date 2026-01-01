# Exetazo

**A laboratory for cross-examining macOS APIs**

---

## What This Is

Exetazo is a pedagogical CLI tool for **empirically exploring the macOS API surface**.

It exists to answer a simple but difficult question:

> *What does this API really mean?*

Documentation is treated as a claim.  
The running system is treated as the authority.

Exetazo provides a structured environment in which APIs can be:
- examined
- stressed
- observed
- and judged  
through disciplined, repeatable experiments.

---

## Core Ethos

Exetazo is built on a few deliberately strict principles:

### 1. Do not trust claims without observation
Apple documentation describes intent, not truth.

APIs are only understood once they are:
- exercised under real conditions
- observed across time
- tested under variation and stress

### 2. Tests are executable beliefs
Each test in Exetazo encodes a belief about an API’s contract.

A passing test does not mean “correct forever” — it means:
> *Under these conditions, on this system, this behavior was observed.*

Failures are not regressions by default.  
They are discoveries.

### 3. Understanding is practiced, not completed
macOS is layered, policy-driven, and context-sensitive.

Exetazo does not aim to “map” the operating system exhaustively.
It exists to support **slow, cumulative understanding**, refined over time as knowledge deepens.

---

## What Exetazo Is Not

- Not a reference manual
- Not a wrapper around documentation
- Not a benchmark suite
- Not an abstraction layer

Exetazo is intentionally minimal and explicit.
It prefers clarity over convenience.

---

## Structure and Approach

Exetazo is a CLI tool that will gradually grow into a menu-driven TUI.

Its structure mirrors the **structural fault lines of macOS**, such as:
- process execution and lifetimes
- memory and address space
- filesystems and persistence
- security and policy
- Mach messaging and rights
- timing, clocks, and scheduling

Within each area:
- individual APIs are examined
- their documented intent is summarized
- configurable experiments are defined
- Zig programs exercise the API directly
- tests encode observed behavior

The tool exists to help the user *ask the system questions* — and listen carefully to the answers.

---

## Test-Driven by Design

Exetazo is developed using a strict test-driven approach.

Tests fall broadly into three categories:

- **Invariant tests**  
  Behavior believed to be a hard contract.

- **Conditional tests**  
  Behavior that holds only under explicit conditions  
  (privileges, entitlements, sandboxing, OS version, architecture).

- **Characterization tests**  
  Observed behavior that is not guaranteed, but worth tracking.

These distinctions matter. They prevent false certainty.

---

## Why Zig

Zig is used deliberately.

- explicit control
- minimal abstraction
- clear error semantics
- predictable binaries

Exetazo aims to remove ambiguity wherever possible. Zig supports that goal.

---

## Intended Audience

Exetazo is for:
- systems programmers
- serious learners of macOS internals
- people willing to observe before believing

It assumes patience, curiosity, and respect for complexity.

---

## Status

This project is intentionally early.

Exetazo is not rushed.
It will grow as understanding grows.

That is the point.

---

## Name

**Exetazo** comes from the Ancient Greek *ἐξετάζω* —  
*to examine thoroughly, to interrogate, to cross-examine.*

It reflects the project’s purpose exactly.

## Acknowledgements

The idea for **Exetazo** grew out of studying the works of *Amit Singh*, *Jonathan Levin*, *Apple Developer* documention and *man pages*. Getting a feel for the surface area of the APIs of macOS is a taxing, but rewarding endevevour.  I acknowledge the heavy use I have made of these works.
