![Guide](/docs/branding/Guide.png)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Latest Release](https://img.shields.io/github/v/release/paulsinclair51/briteRepo?display_name=tag)](https://github.com/paulsinclair51/briteRepo/releases)
[![CI](https://github.com/paulsinclair51/briteRepo/actions/workflows/ci.yml/badge.svg)](https://github.com/paulsinclair51/briteRepo/actions/workflows/ci.yml)

#### Version: v1.0.0

briteRepo is an easy-to-use repository source code management framework
that simplifies contributor workflow. It provides a set of bash scripts
for contributor workflow, clear reporting, and comprehensive documentation.

#### Copyright (c) 2026 Paul Sinclair

<details>
<summary><strong>License</strong></summary>

### License

SPDX-License-Identifier: MIT

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
</details>

<details>
<summary><strong>Preface</strong></summary>

## Preface

This document is intended for users and contributors who need guidance on using
briteRepo including concepts and a quick start example. This also serves as the
`<repo>/README.md` for briteRepo.

For a list of other documents and the repository layout, see
the Documentation Guide.

For a glossary of terms, see the Glossary Reference.

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

1. [**Introduction**](#1-introduction)<br>
   1.1. [Key Strengths](#11-key-strengths)<br>
   1.2. [Quick Start](#12-quick-start)<br>
   1.3. [Requirements](#13-requirements)<br>
   1.4. [Installation](#14-installation)<br>

2. [**Contributing**](#2-contributing)<br>
   2.1. [For Public Users](#21-for-public-users)<br>
   2.2. [For Contributors](#22-for-contributors)<br>
</details>

<details>
<summary><strong>1. Introduction</strong></summary>

## 1. Introduction

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;1.1. Key Strengths</summary>

### 1.1. Key Strengths

- Lightweight design - minimal files, minimal API surface, easy to embed.
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;1.2. Quick Start</summary>

### 1.2. Quick Start

Install the briteRepo scripts on your system.

Create a new repository with the briteRepo canonical layout or
convert an existing repository to the briteRepo canonical layout.

Make changes and use the commit script to commit the changes.
Use the push, pushup, pull, pulldown, copyfix, retarget scripts
for branch management. Use the review and feedback scripts for
review and feedback. Use the release script to publish a release.
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;1.3. Requirements</summary>

### 1.3. Requirements

Bash 4.4 or later, github.

macOS ships Bash 3.2 by default; install a newer Bash (for example, with
Homebrew) before using briteRepo.
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;1.4. Installation</summary>

### 1.4. Installation

briteRepo is installed once per user account, separately from any
repository you use it to manage.

1. Clone the repository temporarily and run its installer:

   ```sh
   git clone --depth 1 https://github.com/paulsinclair51/briteRepo.git /tmp/briterepo-src
   bash /tmp/briterepo-src/briterepo/bin/install
   rm -rf /tmp/briterepo-src
   ```

   This installs the commands and shared helpers to `~/briterepo/` and
   adds `~/briterepo/bin` to PATH.

2. Reload your shell configuration so the updated PATH takes effect:

   ```sh
   source ~/.bashrc
   hash -r
   ```

3. Authenticate the GitHub CLI, which the scripts use for GitHub operations:

   ```sh
   gh auth login
   ```

Scripts are now available by name (for example, `lsbranch -h`). Rerun the
installer the same way to update to a newer release; it always fully
refreshes `~/briterepo/`.
</details>
</details>

<details>
<summary><strong>2. Contributing</strong></summary>

## 2. Contributing

briteRepo welcomes feedback and contributions from the community. This section
explains how to engage with the project based on your interest level.

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;2.1. For Public Users</summary>

### 2.1. For Public Users

If you want to provide feedback on briteRepo, ask questions, or suggest
features:

**Use [GitHub Discussions](../../discussions)**

- **Ask questions** about the repository or using briteRepo.
- **Suggest features** and improvements for the repository.
- **Report bugs** and share workarounds.
- **Share examples** and best practices.

GitHub Discussions is the public engagement channel. Feedback is welcome and
will be reviewed by the maintainers.

**Follow releases:**

Subscribe to [releases](../../releases) to get notified about new versions and
improvements.
</details>

<details>
<summary>&nbsp;&nbsp;&nbsp;&nbsp;2.2. For Contributors</summary>

### 2.2. For Contributors

To contribute code or documentation:

1. **Request contributor access** via [GitHub Discussions](../../discussions)
   or contact the maintainers
2. **Review** the [Contributor Guide](./Contributor_Guide.md) for detailed
   requirements on:
   - Branching model and workflow
   - Coding standards
   - Documentation guidelines
   - Testing requirements
   - Contributor workflow process

3. **Add to contributors list** - Once approved, you'll be added to
   `config/contributors.md` with one of these roles:
   - **C** (Contributor): Can create branches and submit changes
   - **R** (Reviewer): Can also review pull requests
   - **A** (Approver): Can merge changes and manage releases

**Contributor Workflow** - The contributor workflow is only for
contributors to the repository. Use GitHub Discussions for public
feedback on features or issues.
</details>
</details>
