---
layout: page
title: "Getting Started"
description: ""
---
{% include JB/setup %}

This guide will take you through the basic ways of using Transrate. It's worth reading through once even if you're familiar with running command-line tools, as it provides guidance about proper selection of input data.

## Installing transrate

If you haven't already, follow the [installation instructions](http://hibberdlab.com/transrate/#installation) on the home page.

## Examining your contigs

You can examine your contigs without using the reads or a reference. All you need is the assembly in FASTA format.

For example if you have the assembly in the file `assembly.fa`:

```bash
$ transrate --assembly assembly.fa
```

This analysis should run relatively fast (a few seconds to a few minutes depending on the size of your assembly and the speed of your computer).

To understand what these metrics mean, read the [contig metrics documentation](metrics.html#contig-metrics).

## Using read evidence

You can evaluate an assembly using RNAseq reads. You need your assembly in FASTA format and paired reads in separate FASTQ files for the left and right reads.

For example if you have the assembly in the file `assembly.fa` and the reads in `left.fq` and `right.fq`:

```bash
$ transrate --assembly assembly.fa \
            --left left.fq \
            --right right.fq
```

Transrate uses SNAP to align the reads. Although SNAP is extremely fast compared to other aligners, this can still take a long time if you have a lot of reads. If you have multiple processors or cores, you can use them to speed up the analysis by specifying the `--threads` option. For example if you have 32 cores:

```bash
$ transrate --assembly assembly.fa \
            --left left.fq \
            --right right.fq \
            --threads 32
```

Learn about what the results mean by reading the [read mapping metrics  documentation](http://hibberdlab.com/transrate/metrics.html#read-mapping-metrics).

### Choosing the right reads

It is important that you choose the right set of reads to use for analysis. Different sets of reads correspond to asking different question of the analysis.

If you did any of the following you should think about which stage you want to use reads from:

- quality and/or adapter trimming and filtering (e.g. with Trimmomatic)
- error correction (e.g. with BayesHAMMER)
- coverage normalisation (e.g. with khmer normalize-by-median.py)

If you use the raw reads before any treatment you are likely to get an unclear answer, because low quality reads/bases and sequencing errors can be confused with poor assembly. We therefore do not recommend using raw reads.

If you performed quality and/or adapter trimming and filtering and/or error correction you should use the final output from this entire process. For example if you ran Trimmomatic and then BayesHAMMER, use the output from BayesHAMMER as the input to Transrate. This is because these procedures are trying to reconstruct the true sequences of the reads, and should (theoretically) be producing a more accurate set of experimental evidence for the content of the transcriptome.

If you performed coverage normalisation at the end of any read processing pipeline, it is up to you whether to use the normalised reads or the processed reads prior to normalisation. We recommend using normalised reads because it makes the analysis much faster and in our experience the results are extremely similar except for the time taken. Bear in mind that coverage will be capped if you use normalised reads, so the mean coverage statistic will be lower. All other statistics should be unaffected.

## Using reference proteins as evidence

You can compare your assembly to a reference set of proteins from a related species. You need your assembly in FASTA format and the reference proteins in FASTA amino acid format.

For example if you have the assembly in the file `assembly.fa` and the reference in the file `reference.fa`:

```bash
$ transrate --assembly assembly.fa \
            --reference reference.fa
```

This analysis can take a long while to run because of the BLAST alignments. As with read analysis, you might want to use multiple threads:

```bash
$ transrate --assembly assembly.fa \
            --reference reference.fa \
            --threads 32
```

Learn about what the results mean by reading the [comparative metrics  documentation](http://hibberdlab.com/transrate/metrics.html#comparative-metrics).

### Choosing a reference

Which species you choose can strongly affect the results, and how you prepare the reference can make a big difference.

The ideal reference is one from a very closely related species that has a well annotated genome. If a well annotated genome is not available from a closely related species, then a set of proteins from a distantly related but well annotated genome is preferable to a closely related but poorly annotated one.

If your reference is from a species that is not very closely related, it is greatly preferable to use a set of proteins with only one protein per protein-coding gene. This is because most annotated genomes will have multiple isoforms for many genes, each producing a protein. The similar isoforms lead to confusing BLAST alignments and lower the quality of the results. For plant species, http://phytozome.net provides a 'single representative transcript per locus' set of proteins for every genome.

### Using the same species as a reference

It is sometimes useful to evaluate the quality of a de-novo transcriptome assembly even though a species has a well-annotated reference genome and transcriptome. To do this you can use the reference transcriptome as the reference in transrate. In this case you should *not* choose the 'single representative transcript per locus' dataset, but should take the full set of transcripts. This allows you to evaluate how well isoforms are reconstructed.

## Comparing two or more assemblies

You can easily compare multiple assemblies using Transrate. To do this you need each of the assemblies in a FASTA file, and then provide a comma-separated list with **no spaces** to the `--assembly` option.

For example if you have two assemblies, `one.fa` and `two.fa`:

```bash
$ transrate --assembly one.fa,two.fa
```

You can of course still perform all the more advanced analyses, e.g.:

```bash
$ transrate --assembly one.fa,two.fa \
            --reference ref.fa \
            --left left.fq
            --right right.fq
            --threads 32
```

Transrate will run all the specified analyses for each assembly and will write the results to a file called `transrate.csv` with one row per assembly and one column for each metric.
