-- notion-research Schema Templates
-- Adapt these schemas to your project.
-- Property names and select options are examples — replace with your domain.
-- Copy the pattern that matches your use case.

-- Pattern: Time-Series Log
-- Use for: date-indexed activity entries with category tagging, effort tracking,
--           and status (e.g., research diary, lab notebook, daily log)
CREATE TABLE "Daily Log" (
  "Title"         TITLE,        -- activity name e.g. "Team Meeting", "Data Analysis"
  "Timestamp"     DATE,         -- ISO-8601, supports datetime
  "Category"      MULTI_SELECT, -- e.g. Meeting, Coding, Writing, Reading, Analysis, Review
  "Project"       SELECT,       -- e.g. Project A, Project B, General
  "Status"        SELECT,       -- e.g. Not Started, In Progress, Done, On Hold
  "Hours"         NUMBER,
  "Notes"         RICH_TEXT,
  "Keywords"      MULTI_SELECT, -- domain-specific tags
  "Complete"      CHECKBOX      -- __YES__ / __NO__
);

-- Pattern: Status-Tracked Items
-- Use for: work items with lifecycle statuses, due dates, and category tracking
--           (e.g., milestones, sprints, deliverables, feature backlog)
CREATE TABLE "Work Items" (  -- rename to match your domain
  "Title"                     TITLE,
  "Status"                    SELECT,    -- e.g. Upcoming | In Progress | At Risk | Complete | Deferred
  "Category"                  SELECT,    -- e.g. Science | Infrastructure | Bug Fix | Integration
  "date:Due Date:start"       DATE,
  "date:Due Date:is_datetime" INT,       -- 0 for date-only
  "Notes"                     RICH_TEXT
);

-- Pattern: Experiment Registry
-- Use for: structured experiments with phase workflow, findings tracking, and blocker management
--           (e.g., experiments, clinical trials, simulations, A/B tests)
CREATE TABLE "Trial Registry" (  -- rename to match your domain
  "Title"         TITLE,
  "Status"        SELECT,    -- e.g. Designed | Setup | Running | Analyzing | Complete | Blocked
  "Phase"         SELECT,    -- e.g. Protocol | Implementation | Execution | Analysis | Writing
  "Description"   RICH_TEXT,
  "Key Findings"  RICH_TEXT,
  "Blocker"       RICH_TEXT
);

-- Pattern: Literature Catalog
-- Use for: tracking reading materials with citation metadata, reading status, and relevance
--           (e.g., papers, books, reports, datasets, preprints)
CREATE TABLE "Literature" (  -- rename to match your domain
  "Title"     TITLE,        -- convention: "Author et al. (Year) — Short Title"
  "Authors"   RICH_TEXT,
  "Year"      NUMBER,
  "Type"      SELECT,       -- e.g. Paper | Book | Report | Preprint | Dataset
  "Status"    SELECT,       -- e.g. To Read | Reading | Done | Key Reference
  "DOI"       RICH_TEXT,
  "Relevance" SELECT,       -- e.g. Core | Methods | Background | Related
  "Notes"     RICH_TEXT
);

-- Pattern: Note Archive
-- Use for: category-tagged, date-stamped free-form notes
--           (e.g., research notes, field notes, design decisions, meeting minutes)
CREATE TABLE "Notes" (  -- rename to match your domain
  "Title"                   TITLE,
  "Category"                SELECT,       -- e.g. Bug Fix | Design Decision | Observation | Configuration | Result
  "date:Date:start"         DATE,
  "date:Date:is_datetime"   INT,
  "Tags"                    MULTI_SELECT  -- JSON array string: "[\"tag1\", \"tag2\"]"
);

-- Note: Writing Pipeline is covered by the Status-Tracked Items pattern.
