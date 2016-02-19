---
layout: page
title: Metrics
---

This page describes the ways Transrate measures an assembly.

By far the most useful metric is the Transrate score. You should read about that first.

## The Transrate score

The Transrate scores measure quality of the assembly without using a reference. A score is produced for the whole assembly, and for each contig. The scoring process uses the reads that were used to generate the assembly as evidence - so if you want to get a Transrate score, you need to run transrate in read-metrics mode (by passing in the paired-end reads with `--left` and `--right`).

### The assembly score

The assembly score allows you to compare two or more assemblies made with the same reads. The score is designed so that an increased score is very likely to correspond to an assembly that is more biologically accurate.

The score is calculated as the geometric mean of all contig scores multiplied by the proportion of input reads that provide positive support for the assembly.

Thus, the score captures how confident you can be in what was assembled, as well as how complete the assembly is.

0 is the minimum possible score, while 1.0 is the maximum.

The assembly score for each assembly is printed during a Transrate run, e.g.:

```bash
TRANSRATE ASSEMBLY SCORE: 0.2871
```

It is also saved in the `*assemblies.csv` file.

### The contig score

Each contig is assigned a score by measuring how well it is supported by read evidence. The contig score can be thought of as measure of whether the contig is an accurate, complete, non-redundant representation of a transcript that was present in the sequenced sample.

There are four components to the contig score:

1. A measure of whether each base has been called correctly. This is estimated using the mean per-base edit distance, i.e. how many changes would have to be made to a read covering a base before the sequence of the read and the covered region of the contig agreed perfectly.
2. A measure of whether each base is truly part of the transcript. This is estimated by determining whether any reads provide agreeing coverage for a base.
3. The probability that the contig is derived from a single transcript (rather than pieces of two or more transcripts). This is measured as the probability that the read coverage is best modelled by a single Dirichlet distribution, rather than two or more distributions.
4. The probability that the contig is structurally complete and correct. This is estimated as the proportion of assigned read pairs that agree with the structure and composition of the contig, which in turn is calculated by classifying the read pair alignments.

The contig score is the product of the components.

The score components are useful independently of the contig score, as they can identify contigs that can be treated in different ways to improve the quality of an assembly. See Read Metrics below for details.

The contig scores and other metrics for each contig are saved in the `*contigs.csv` file for each assembly.

## The optimised assembly score

Contig scores can be used to filter out bad contigs from an assembly, leaving you with only the well-assembled ones. Transrate does this automatically, by learning the contig score cutoff that maximises the assembly score. The assembly score of the subset of contigs scoring above the cutoff (the optimal assembly score) is reported at the command line and in the `*assembliles.csv` file. The 'good' contigs as determined by the cutoff optimisation procedure are output to the file `good.*.fa`.

## Contig metrics

Contig metrics are measures based entirely on analysing the set of contigs themselves.

These metrics are best used only as a quick, crude way of detecting major problems with the assembly.

They are informative, but are only weakly useful for judging assembly quality. For most of these metrics, we don't know what the optimum is, although we can recognise extremely bad values. For example, an extremely small (\<5,000) or extremely large (\>100,000) number of contigs is biologically implausible for most organisms, and therefore might suggest a problem with the assembly.

You will need to use your biological knowledge about the species you are investigating to decide what values are acceptable.

Transrate outputs a set of contig metrics that looks like this:

```
Contig metrics:
-----------------------------------
n seqs                       147600
smallest                         83
largest                        8133
n bases                    69200630
mean len                     447.77
n under 200                   23838
n over 1k                     12804
n over 10k                        0
n with orf                    24771
mean orf percent              64.33
N90                             276
N70                             441
N50                             670
N30                            1021
N10                            1878
gc                             0.44
gc skew                        -0.0
at skew                        0.01
cpg ratio                      0.56
bases n                      178748
proportion n                    0.0
linguistic complexity           0.1
```

| name                  | explanation                                                                                                    |
|:----------------------|:---------------------------------------------------------------------------------------------------------------|
| n_seqs                | the number of contigs in the assembly                                                                          |
| smallest              | the size of the smallest contig                                                                                |
| largest               | the size of the largest contig                                                                                 |
| n_bases               | the number of bases included in the assembly                                                                   |
| mean_len              | the mean length of the contigs                                                                                 |
| n under 200           | the number of contigs shorter than 200 bases                                                                   |
| n over 1k             | the number of contigs greater than 1,000 bases long                                                            |
| n over 10k            | the number of contigs greater than 10,000 bases long                                                           |
| n with orf            | the number of contigs that had an open reading frame                                                           |
| mean orf percent      | for contigs with an ORF, the mean % of the contig covered by the ORF                                           |
| NX (e.g. N50)         | the largest contig size at which at least X% of bases are contained in contigs at least this length            |
| gc                    | % of bases that are G or C                                                                                     |
| gc skew               | http://en.wikipedia.org/wiki/GC_skew                                                                           |
| at skew               | see GC skew                                                                                                    |
| cpg ratio             | count of CpG sites relative to expected number (only valid for stranded assemblies)                            |
| bases n               | the number of bases that are N                                                                                 |
| proportion n          | the proportion of bases that are N                                                                             |
| linguistic complexity | the total [linguistic complexity](http://en.wikipedia.org/wiki/Linguistic_sequence_complexity) of the assembly |

## Read mapping metrics

Read mapping metrics are based on aligning the reads used in the assembly to the assembled contigs.

These are by far the most useful metrics - better even than comparison to a reference. This is because the reads contain a wealth of information that is specific to the organism you sequenced, and this information can be used to evaluate confidence in each base and contig in the assembly.

If you want to optimise your assembly, we suggest using read-mapping metrics, in particular the transrate score and contig scores.

When you include the `--left` and `--right` options, Transrate will do the following:

1. map the provided reads to the assembly using [SNAP](http://snap.cs.berkeley.edu)
2. infer the most likely contig of origin for any multi-mapping reads with [Salmon](https://github.com/kingsfordgroup/sailfish/releases/tag/v0.3.0)
3. inspect the resulting alignments with [transrate-tools](https://github.com/cboursnell/transrate-tools) and use them to evaluate each contig in the assembly

```
Read mapping metrics:
-----------------------------------
fragments                    689080
fragments mapped             463918
p fragments mapped             0.67
good mappings                335728
p good mapping                 0.49
bad mappings                 128190
potential bridges               209
bases uncovered                4888
p bases uncovered               0.0
contigs uncovbase               380
p contigs uncovbase            0.36
contigs uncovered                14
p contigs uncovered            0.01
contigs lowcovered              286
p contigs lowcovered           0.27
contigs segmented                51
p contigs segmented            0.05
contigs good                    828
p contigs good                 0.78
```

| name                 | explanation                                                                          | optimum                                                                                        |
|:---------------------|:-------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------|
| fragments            | the number of read pairs provided                                                    | NA                                                                                             |
| fragments mapped     | the total number of read pairs mapping                                               | theoretically equal to `fragments` if all errors, adapters and contamination have been removed |
| p fragments mapped   | the proportion of the provided read pairs that mapped successfully                   | theoretically 1.0 (see above)                                                                  |
| good mappings        | the number of read pairs mapping in a way indicative of good assembly                | equal to `fragments`                                                                           |
| p good mappings      | the proportion of read pairs mapping in a way indicative of a good assembly          | 1.0                                                                                            |
| bad mappings         | the number and proportion of reads pairs mapping in a way indicative of bad assembly | 0                                                                                              |
| potential bridges    | the number of potential links between contigs that are supported by the reads        | 0                                                                                              |
| n bases uncovered    | the number of bases that are not covered by any reads                                | 0                                                                                              |
| p bases uncovered    | the proportion of bases that are not covered by any reads                            | 0.0                                                                                            |
| contigs uncovbase    | the number of contigs that contain at least one base with no read coverage           | 0                                                                                              |
| p contigs uncovbase  | the proportion of contigs that contain at least one base with no read coverage       | 0.0                                                                                            |
| contigs uncovered    | the number of contigs that have a mean per-base read coverage of < 1                 | 0                                                                                              |
| p contigs uncovered  | the proportion of contigs that have a mean per-base read coverage of < 1             | 0.0                                                                                            |
| contigs lowcovered   | the number of contigs that have a mean per-base read coverage of < 10                | no specific optimum                                                                            |
| p contigs lowcovered | the proportion of contigs that have a mean per-base read coverage of < 10            | no specific optimum                                                                            |


### Good and bad mappings

'Good' mappings are those aligned in a way that is consistent with the contig being perfectly assembled, i.e.:

- where both members of the pair are aligned
- in the correct orientation
- on the same contig
- without overlapping either end of the contig

Conversely, 'bad' pairs are those where one of the conditions for being 'good' are not met.

### Bridges

Transrate calculates whether the read mappings contain any evidence that different contigs originate from the same transcript. These theoretical links are called bridges, and the number of bridges is shown in the **supported bridges** metric. A low count of supported bridges could be good or bad depending on the context. If you have a fragmented assembly, a large number of supported bridges means that scaffolding could greatly improve it. On the other hand, a large number of supported bridges in an otherwise seemingly good assembly could be indicative of misassemblies.

The list of supported bridges is output to a file, `supported_bridges.csv`.

## Comparative metrics

Comparative metrics involve comparing the assembly to a related reference species. These metrics are powerful because they are an external validation of the experimental results.

However, comparative metrics are **not ideal for optimising assembly**. This is because comparison to a reference will always penalise genuine biological novelty contained in the assembly. Read metrics are much better for assembly optimisation.

Usually, the closer the reference species is to the species you've assembled, the more resolution you will have in your comparative metrics. In other words, there are likely to be more genes shared between closely related species than between distantly related species. This means that you are more likely to be able to distinguish between two assemblies of similar quality by using a closely related reference.

Taken with the read mapping metrics, comparative metrics allow you to optimise the quality of your assembly.

When you include the `--reference` option, Transrate will align each contig in your assembly to each protein or transcript in the reference using [Conditional Reciprocal Best BLAST](https://github.com/cboursnell/crb-blast) (CRBB). CRBB is a novel algorithm for finding homologous genes developed by [Steve Kelly](http://stevekellylab.com) and described in our paper on long-range comparative transcriptomics [(Aubry at el. 2014)](http://www.plosgenetics.org/article/info%3Adoi%2F10.1371%2Fjournal.pgen.1004365). CRBB hits are high-confidence predicted homologs.

CRB-BLAST starts out with bi-directional BLAST+ alignments:

- assembly -> reference (using blastx)
- reference -> assembly (using tblastn)

It then selects the reciprocal best hits: those where the top match in one direction is the same as the top match in the other direction. These are considered highest confidence predicted homologs, and are used to learn an appropriate e-value cutoff for each length of contig. Finally it selects all alignments with e-values below the cutoff for each length as high-confidence predicted homologs.

Transrate analyses these alignments and produces output like:

```
Comparative metrics:
------------------------------
CRBB hits                 38678
p contigs with CRBB        0.34
n contigs with CRBB       38678
p refs with CRBB           0.33
n refs with CRBB          12874
reference coverage        0.65
collapse factor           9.73
cov25                    11303
cov50                     9336
cov75                     6908
cov85                     5357
cov95                     2841
p cov25                   0.29
p cov50                   0.24
p cov75                   0.18
p cov85                   0.14
p cov95                   0.07
```

| name                   | explanation                                                                                                                                                        | optimum                                                                                                                                                                                              |
|:-----------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| CRBB hits              | the number of reciprocal best hits against the reference using CRB-BLAST. A high score indicates that a large number of real transcripts have been assembled.      | As high as possible. The theoretical maximum is the number of contigs (**n seqs**). In practise, the maximum depends on the evolutionary divergence between the assembled species and the reference. |
| p contigs with CRBB    | the proportion of contigs with a CRB-BLAST hit                                                                                                                     | 1                                                                                                                                                                                                    |
| n contigs with CRBB    | the number of contigs with a CRB-BLAST hit                                                                                                                         | `n seqs`                                                                                                                                                                                             |
| p references with CRBB | the proportion of references with a CRB-BLAST hit                                                                                                                  | 1                                                                                                                                                                                                    |
| n references with CRBB | the number of references with a CRB-BLAST hit                                                                                                                      | `n seqs`                                                                                                                                                                                             |
| reference coverage     | the proportion of reference bases/amino acids covered by a CRB-BLAST hit                                                                                           | As high as possible (see above)                                                                                                                                                                      |
| collapse factor        | the mean number of reference proteins mapping to each contig. A high score on this metric indicates the assembly contains chimeras or has collapsed gene families. | Dependent on the phylogenomic relationship between the organisms, e.g. whether a genome duplication has taken place.                                                                                 |
| covX                   | number of reference proteins with at least X% of their bases covered by a CRB-BLAST hit                                                                            | All of them                                                                                                                                                                                          |
| p covX                 | proportion of reference proteins with at least X% of their bases covered by a CRB-BLAST hit                                                                        | 1                                                                                                                                                                                                    |
