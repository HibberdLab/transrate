---
layout: page
title: "Transrate"
---

{% include JB/setup %}

Transcriptome assembly is hard. The algorithms are complex, the data are messy, and it's often not clear how to determine whether an assembly is suitable for answering a biological question.

Transrate helps by examining your assembly in detail and providing insight about its quality and usefulness in various situations. This can allow you to choose between assemblers and parameters, and helps you decide when to stop trying to improve the assembly.

## Overview

Transrate analyses an assembly in three key ways:

1. by inspecting the contigs themselves
2. by mapping reads to the contigs and inspecting the alignments
3. by aligning the contigs against proteins from a related species and inspecting the alignments

You can read about these analyses in detail on the [transcriptome assembly metrics](metrics.html) page.

## Installation

If you've got Ruby v2.0.0 or later, simply install Transrate with the command:

```bash
$ gem install transrate
```

Transrate depends on some external tools that can't be installed by the transrate installer, including BLAST+ and Bowtie2. You can install these dependencies yourself, or you can let Transrate do it for you by running the command:

```bash
$ transrate --install-deps
```

If you don't have at least v2 Ruby installed, you should install the latest version using the Ruby Version Manager: [RVM.io](http://rvm.io), then install transrate as above.

## The command-line interface

Running `transrate --help` will show you the command-line interface:

```
Transrate v0.2.0 by Richard Smith-Unna <rds45@cam.ac.uk>
                and Chris Boursnell.

DESCRIPTION:
Analyse a de-novo transcriptome
assembly using three kinds of metrics:

1. contig-based
2. read-mapping (if --left and --right are provided)
3. reference-based (if --reference is provided)

Bug reports and feature requests at:
http://github.com/blahah/transrate

USAGE:
transrate <options>

EXAMPLES:
transrate --assembly contigs.fa --reference Athaliana_protein.fa --threads 8

OPTIONS:
  --assembly, -a <s>:   assembly file(s) in FASTA format, comma-separated
 --reference, -r <s>:   reference proteome file in FASTA format
      --left, -l <s>:   left reads file in FASTQ format
     --right, -i <s>:   right reads file in FASTQ format
--insertsize, -n <i>:   mean insert size (default: 200)
  --insertsd, -s <i>:   insert size standard deviation (default: 50)
   --threads, -t <i>:   number of threads to use (default: 8)
   --outfile, -o <s>:   filename to use for CSV output
                        (default: transate_results.csv)
  --loglevel, -g <s>:   the amount of information to print.
                        one of [error, info, warn, debug] (default: info)
  --install-deps, -d:   install any missing dependencies
       --profile, -p:   debug option: profile the code as it runs
       --version, -v:   Print version and exit
          --help, -h:   Show this message
```

See the [getting started guide](getting_started.html) for more instructions.

## Authors and Contributors

Transrate was conceived and led by Richard Smith-Unna (RSU) and written by RSU and Chris Boursnell under the guidance of [Professor Julian Hibberd](http://hibberdlab.com) at the University of Cambridge. [Steve Kelly](http://www.stevekellylab.com/) (Oxford) and [Matt MacManes](http://genomebio.org/) (University of New Hampshire) helped conceive and refine metrics.

We welcome collaboration - if you'd like help with your transcriptome project please send an email to rds45@cam.ac.uk.

We also welcome contributions to the code base - please see the [README in the Github repo](https://github.com/Blahah/transrate).

## Support or Contact

If you're having trouble with transrate, please first consult the documentation.

If you can't find the answer to your question, you can search the [user forum](https://groups.google.com/forum/#!forum/transrate-users). If you still can't find the answer, please make a new post to the user forum describing the trouble you're having.

If you're sure the problem you're encountering is a bug, please post it to the [issue tracker](https://github.com/Blahah/transrate/issues?state=open) and we'll fix it.

## Citation, License & Copyright

Transrate is research software. We therefore require that users cite Transrate if they use it in a publication. Please use the citation:

> Transrate v0.2.0 (2014) RD Smith-Unna, C Boursnell, S Kelly and JM Hibberd.      http://hibberdlab.com/transrate. DOI: [10.5281/zenodo.10799](http://dx.doi.org/10.5281/zenodo.10799).

Transrate is free open source software, released under the [MIT license](http://blahah.mit-license.org/).

© Richard Smith-Unna 2014.
