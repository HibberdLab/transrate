---
layout: page
title: "Transrate"
---

{% include JB/setup %}

Transcriptome assembly is hard. The algorithms are complex, the data are messy, and it's often not clear how to determine whether an assembly is suitable for answering a biological question.

Transrate helps by examining your assembly in detail and providing insight about its quality and usefulness in various situations. This can allow you to choose between assemblers and parameters, and helps you decide when to stop trying to improve the assembly.

> NOTE: this is the documentation for transrate v1.0.0 beta2

## Overview

Transrate analyses a transcriptome assembly in three key ways:

1. by inspecting the contigs themselves
2. by mapping reads to the contigs and inspecting the alignments
3. by aligning the contigs against proteins from a related species and inspecting the alignments

**By far** the most useful metrics are those based on read mapping, in particular you should pay attention to the *Transrate score* and the individual *contig scores*.

You can read about these in detail on the [transcriptome assembly metrics](metrics.html) page.

## Installation

See [the installation guide](installation.html).

## The command-line interface

Running `transrate --help` will show you the command-line interface:

```
Transrate v1.0.0.beta2
by Richard Smith-Unna <rds45@cam.ac.uk> and Chris Boursnell

DESCRIPTION:
Analyse a de-novo transcriptome assembly using three kinds of metrics:

1. sequence-based (basic)
2. read-mapping-based (if --left and --right are provided)
3. reference-based (if --reference is provided)

Bug reports and feature requests at:
http://github.com/blahah/transrate

USAGE:
transrate <options>

EXAMPLES:
# check dependencies and install any that are missing
transrate --install-deps
# get the transrate score for the assembly and each contig
transrate --assembly contigs.fa --left left.fq --right right.fq
# basic assembly metrics only
transrate --assembly contigs.fa
# basic and reference-based metrics with 8 threads
transrate --assembly contigs.fa --reference Athaliana_transcripts.fa
--threads 8
# contig and read-based metrics for two assemblies with 32 threads
transrate --assembly one.fa,two.fa --left l.fq --right r.fq --threads 32

OPTIONS:
-a, --assembly=<s>         assembly file(s) in FASTA format, comma-separated
-r, --reference=<s>        reference proteome file in FASTA format
-l, --left=<s>             left reads file in FASTQ format
-i, --right=<s>            right reads file in FASTQ format
-t, --threads=<i>          number of threads to use (default: 8)
-o, --outfile=<s>          prefix filename to use for CSV output (default:
  transrate)
  -g, --loglevel=<s>         the amount of information to print. one of [error,
  info, warn, debug] (default: info)
  -n, --install-deps         install any missing dependencies
  -s, --install-read-deps    install missing dependencies for read metrics only
  -e, --install-ref-deps     install missing dependencies for reference metrics
  only
  -v, --version              Print version and exit
  -h, --help                 Show this message
```

See the [getting started guide](getting_started.html) for more instructions.

## Authors and Contributors

Transrate was developed by Richard Smith-Unna and Chris Boursnell, with significant contributions from [Rob Patro](http://www.robpatro.com/redesign/), under the guidance of [Steve Kelly](http://www.stevekellylab.com/) (Oxford) and [Professor Julian Hibberd](http://hibberdlab.com) (University of Cambridge). [Matt MacManes](http://genomebio.org/) (University of New Hampshire) provided valuable discussion and testing.

We welcome collaboration - if you'd like help with your transcriptome project please send an email to rds45@cam.ac.uk.

We also welcome contributions to the code base - please see the [README in the Github repo](https://github.com/Blahah/transrate).

## Get Support or Contact

If you're having trouble with transrate, please first consult the documentation on this site.

If you can't find the answer to your question, you can search the [user forum](https://groups.google.com/forum/#!forum/transrate-users). If you still can't find the answer, please make a new post to the user forum describing the trouble you're having.

For urgent help, or just to chat to us, please come to the [Transrate chat room](https://gitter.im/Blahah/transrate).

If you're sure the problem you're encountering is a bug, please post it to the [issue tracker](https://github.com/Blahah/transrate/issues?state=open) and we'll fix it.

## Citation, License & Copyright

Transrate is research software. We therefore require that users cite Transrate if they use it in a publication. Please use the citation:

> Transrate v1.0.0.beta2 (2014) RD Smith-Unna, C Boursnell, R Patro, JM Hibberd, and S Kelly. http://hibberdlab.com/transrate. DOI: [10.5281/zenodo14897](http://dx.doi.org/10.5281/zenodo14897).

Transrate is free open source software, released under the [MIT license](http://blahah.mit-license.org/).

© Richard Smith-Unna 2014.
