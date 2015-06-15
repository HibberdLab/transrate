---
layout: page
title: "Transrate"
---

{% include JB/setup %}

Transrate is software for *de-novo* transcriptome assembly quality analysis. It examines your assembly in detail and compares it to experimental evidence such as the sequencing reads, reporting quality scores for contigs and assemblies. This allows you to choose between assemblers and parameters, filter out the bad contigs from an assembly, and help decide when to stop trying to improve the assembly.

> NOTE: this is the documentation for transrate v1.0.0

## Overview

Transrate analyses a transcriptome assembly in three key ways:

1. by inspecting the contig sequences
2. by mapping reads to the contigs and inspecting the alignments
3. by aligning the contigs against proteins or transcripts from a related species and inspecting the alignments

**By far** the most useful metrics are those based on read mapping, in particular you should pay attention to the *[Transrate assembly score](metrics.html#the-transrate-score)*, the *[optimised assembly score](metrics.html#the-optimised-asssembly-score)* and the individual *[contig scores](metrics.html#the-contig-score)*.

You can read about all the [metrics in detail](metrics.html).

## Installation

See [the installation guide](installation.html).

## The command-line interface

Running `transrate --help` will show you the command-line interface:

```

Transrate v1.0.0
by Richard Smith-Unna, Chris Boursnell, Rob Patro,
Julian Hibberd, and Steve Kelly

DESCRIPTION:
Analyse a de-novo transcriptome assembly using three kinds of metrics:

1. sequence based (if --assembly is given)
2. read mapping based (if --left and --right are given)
3. reference based (if --reference is given)

Documentation at http://hibberdlab.com/transrate

USAGE:
transrate <options>

OPTIONS:
-a, --assembly=<s>            Assembly file(s) in FASTA format, comma-separated
-l, --left=<s>                Left reads file in FASTQ format
-r, --right=<s>               Right reads file in FASTQ format
-e, --reference=<s>           Reference proteome or transcriptome file in FASTA format
-t, --threads=<i>             Number of threads to use (default: 8)
-m, --merge-assemblies=<s>    Merge best contigs from multiple assemblies into file
-o, --outfile=<s>             Prefix filename to use for CSV output (default: transrate)
-g, --loglevel=<s>            Log level. One of [error, info, warn, debug] (default: info)
-i, --install-deps=<s>        Install any missing dependencies. One of [all, read, ref]
-x, --examples                Show some example commands with explanations
-v, --version                 Print version and exit
-h, --help                    Show this message

```

See the [getting started guide](getting_started.html) for more instructions.

## Authors and Contributors

Transrate is a collabortation between the [Hibberd lab](http://hibberdlab.com) (Cambridge) and the [Kelly lab](http://stevekellylab.com) (Oxford). It was developed by Richard Smith-Unna, Chris Boursnell, Steve Kelly and Julian Hibberd, with significant contributions from Rob Patro (Stony Brook University). Matt MacManes and the Transrate user community provided valuable feedback and testing.

We welcome contributions - please see the [README in the Github repo](https://github.com/Blahah/transrate).

## Get Support

If you're having trouble with Transrate, please first consult the documentation on this site.

If you can't find the answer to your question, you can search the [user forum](https://groups.google.com/forum/#!forum/transrate-users). If you still can't find the answer, please make a new post to the user forum describing the trouble you're having.

For urgent help, or just to chat to us, please come to the [Transrate chat room](https://gitter.im/Blahah/transrate).

If you're sure the problem you're encountering is a bug, please post it to the [issue tracker](https://github.com/Blahah/transrate/issues) and we'll fix it.

## Citation, License & Copyright

Transrate is research software. We therefore require that users cite Transrate if they use it in a publication. Please use the citation:

> Transrate v1.0.0 (2015) RD Smith-Unna, C Boursnell, R Patro, JM Hibberd and S Kelly. http://hibberdlab.com/transrate. DOI:  [10.5281/zenodo.18325](http://dx.doi.org/10.5281/zenodo.18325)

Transrate is free open source software, released under the [MIT license](http://transrate.mit-license.org).

All site content is released under CC-BY v3.0 [![CC-BY icon](https://licensebuttons.net/l/by/3.0/80x15.png)](https://creativecommons.org/licenses/by/3.0/).
