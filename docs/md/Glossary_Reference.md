![Glossary Reference](/docs/branding/Glossary_Reference.png)

#### Version: v1.0.0

This glossary defines generally used terms in the documentation and
terms often used in the testing domain. It is a companion document to
the Documentation Guide.

#### Copyright (c) 2026 Paul Sinclair

<details>
<summary><strong>License</strong></summary>

### License

SPDX-License-Identifier: MIT

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
</details>

<details>
<summary><strong>Preface</strong></summary>

## Preface

This document is for users and contributors who need quick access to the
definitions of terms or to browse through the terms.

For a list of other documents and the repository layout, see
the Documentation Guide.

A printer-friendly PDF file for this document is available.

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;Document Version History</summary>

### Document Version History

| Version | Date | Comment | Author/Editor |
|----------|------|---------|---------------|
| v1.0.0 | 2026-06-11 | Initial version. | Paul Sinclair |
</details>
</details>

<details>
<summary><strong>Table of Contents</strong></summary>

## Table of Contents

1. [Introduction](#1-introduction)

2. [Glossary](#2-glossary)
</details>

<details>
<summary><strong>1. Introduction</strong></summary>

## 1. Introduction

The glossary defines generally used terms in the documentation and terms
often used in the testing domain.

Note: '*' indicates the definition of a term that has a specific meaning
in the documention which may differ from the meaning of the term in the
testing domain or other contexts.

Note: For specific API macros and functions not included in the glossary,
refer to the Runner or Test API Reference document for information.
</details>

<details>
<summary><strong>2. Glossary</strong></summary>

## 2. Glossary

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--A--</summary>

### --A--

- **API**: Application Programming Interface: public typedefs,
  structs, enums, macros, and functions that provide a well-defined
  service. For example, the Runner API and the Test
  API.
- **approver***: A person listed in `<repo>/config/contributors.md` as an approver.
  Note that an approver is also a contributor and a reviewer.
  An approver may review and approve changes. An approver
  must follow the guidelines in `<repo>/docs/Contributor_Guide.md`.
- **artifact**: A file or bundle of files produced by a GitHub Actions
  workflow and stored for later download (e.g., build outputs, logs,
  reports). See also test artifact.
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--B--</summary>

### --B--
- **Bash glob pattern**: A shell wildcard pattern used for filename
  and path matching in Bash. In `lsbranch`, this is used for
  branch name filtering with `PATTERN` and `-x PATTERN`.
  Default matching rules: `*` and `**` match any characters (including
  `/`), `?` matches one character (including `/`), `[abc]` matches one
  character from a set or range, and any other character matches
  itself. This differs from common path-segment glob expectations where
  `*` does not match `/`.
  With the `-g` option, `genpdf` uses segment-style matching: `*` and
  `?` do not match `/`, while `**` matches across `/`.
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--C--</summary>

### --C--

- **category***: A named set of `RA_GROUP` and `RA_TEST`
  macros whose combined results are written by `RA_WRITE_RESULT` to
  the report with a specified category name.
- **CD (Continuous Delivery/Deployment)**: Automated practices that
  extend CI (Continuous Integration) by packaging, releasing, or
  deploying software after it has passed all required tests.
  Continuous Delivery prepares release artifacts for manual approval,
  while Continuous Deployment automatically deploys every passing
  change to a target environment. Use continuous-delivery,
  continuous-deployment, or CI when used as an adjective.
- **CI (Continuous Integration)**: An automated practice where every
  change to a codebase is built and tested in a shared environment. A
  CI system runs workflows that compile the project, execute tests,
  validate formatting or static analysis rules, and produce artifacts
  such as logs or reports. CI helps detect errors early, ensures
  consistent build quality, and provides rapid feedback to developers.
  Use continuous-integration or CI when used as an adjective.
- **command line**: A line of text entered into a shell that specifies
  an executable and optional arguments or flags (options). Use
  command-line when used as an adjective.
- **concurrent block***: A set of tests bracketed by
  `RA_BEGIN_CONCURRENT` and `RA_END_CONCURRENT` macros.
- **contributor***: A person listed in `<repo>/config/contributors.md`.
  Note that a reviewer or approver, is also a contrubutor.
  A contributor may provide changes that are subject
  to review and approval before includding in a release. A contributor
  must follow the guidelines in `<repo>/docs/Contributor_Guide.md`.
- **control file**: See golden file.
- **customization function***: A Runner API function that
  can be used to help customize the orchestrator (main) function and
  test group functions.
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--D--</summary>

### --D--

- **default report filename***: The report filename used
  when only a directory path (or no `PATH`) is provided.
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--E--</summary>

### --E--

- **executable**: A compiled/linked program, It
  is run from a shell using a command line.
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--F--</summary>

### --F--

- **framework***: Guidelines, templates, APIs, tools, and  documentation for a class
  of projects that simplify development within that class.
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--G--</summary>

### --G--

- **golden file***: A previously generated file that can be compared
  to a newly generated file for differences. Differences (other than
  expected ones like timestamps) typically indicate a test failure.
  Sometimes the golden file is out of date and must be replaced by
  promoting the new file. See also output file.
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--H--</summary>

### --H--

_No terms currently defined._
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--I--</summary>

### --I--

_No terms currently defined._
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--J--</summary>

### --J--

_No terms currently defined._
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--K--</summary>

### --K--

_No terms currently defined._
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--L--</summary>

### --L--

_No terms currently defined._
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--M--</summary>

### --M--

_No terms currently defined._
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--N--</summary>

### --N--

_No terms currently defined._
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--O--</summary>

### --O--

- **output file***: Filee generated by executing a command line or testj.
  See also golden file.
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--P--</summary>

### --P--

- **PATH***: Optional command-line argument indicating the
  output destination; may be a report file path or directory path.
  Argument must be quoted if it contains spaces.
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--Q--</summary>

### --Q--

_No terms currently defined._
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--R--</summary>

### --R--

- **`<repo>`**: Repository root directory. In docs and usage examples,
  `<repo>` denotes a placeholder for the absolute path to the repository root.
- **`<repo_url>`**: Repository URL. In docs and usage examples,
  `<repo_url>` denotes a placeholder for the repository URL.
- **reviewer***: A person listed in `<repo>/config/contributors.md` as a reviewer.
  Note that an reviewer is also a contributor and an approver is also a
  contributor and a reviewer. A reviewer may review changes.
  A reviewer must follow the guidelines in `<repo>/docs/Contributor_Guide.md`.
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--S--</summary>

### --S--

- **semantic versioning**: A versioning scheme for artifacts. For
  example, `v<M>.<m>.<p>` where `<M>`, `<m>`, and `<p>`
  are one or two digits and M indicates the major release, m
  indicates the minor release, and p indicates the patch version.
- **shell**: A command-line interface that allows a user or script to
  submit command lines. Examples include `pwsh`, `powershell.exe`,
  `bash`, `sh`, `zsh`, and `cmd.exe`.
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--T--</summary>

### --T--

_No terms currently defined._
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--U--</summary>

### --U--

_No terms currently defined._
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--V--</summary>

### --V--

_No terms currently defined._
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--W--</summary>

### --W--

- **workflow**: A defined sequence of automated steps executed by a CI
  (continuous-integration) system. In GitHub Actions, a workflow is
  triggered by an event (such as a push, pull request, or scheduled
  run) and runs one or more jobs that perform tasks like building,
  testing, or packaging a project. Workflows may produce artifacts
  such as logs, reports, or build outputs.
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--X--</summary>

### --X--

_No terms currently defined._
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--Y--</summary>

### --Y--

_No terms currently defined._
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;--Z--</summary>

### --Z--

_No terms currently defined._
</details><br>
</details>
