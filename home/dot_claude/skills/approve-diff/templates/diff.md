# Diff template

Use this format for each code or test diff. Order the diffs by the path the data
takes; the heading's N of M gives the user the full sequence.

## Format, in this order

1. **Heading.** `**Diff N of M: <file>, <enclosing function>, lines <a>–<b>**`
2. **The diff.** A diff code block. Include the enclosing function's signature and
   the surrounding code, with `...` for any body that isn't relevant.
3. **What it does.** What the change does, naming the variables and functions it
   touches. If the code can't run until a later diff, say so here.
4. **Where we are in the flow.** Follow one concrete input through the code. Say
   which function holds it, what happened just before this change, and what
   happens just after.

## Example

**Diff 2 of 3: `garden.py`, `next_watering`, lines 12–20**

```diff
 def next_watering(plant, season):
     ...
-    interval = DEFAULT_DAYS
+    interval = days_between_waterings(season)
     return plant.last_watered + timedelta(days=interval)
```

**What it does.** `next_watering` takes its interval from
`days_between_waterings(season)` instead of the constant `DEFAULT_DAYS`, so the
same plant gets a different date in winter than in summer.
`days_between_waterings` doesn't exist until diff 3, so this code can't run yet.

**Where we are in the flow.** A fern was last watered on June 1, and the season is
`"summer"`. Diff 1 made `reminder_job` pass `"summer"` into `next_watering`. This
diff turns the season into a day count and adds it to June 1. Diff 3 defines the
lookup.
