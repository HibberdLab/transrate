## The metrics

   1. [contig metrics](#contig-metrics)
   2. [read mapping metrics](#read-mapping-metrics)
   3. [comparative metrics](#comparative-metrics)
   4. [total assembly score](#total-assembly-score)

### Contig metrics

Contig metrics are measures based entirely on analysing the set of contigs themselves.

These are informative, but are only weakly useful for judging assembly quality. For most of these metrics, we don't know what the optimum is, although we can recognise extremely bad values. For example, an extremely small (\<10,000) or extremely large (\>100,000) number of contigs is biologically implausible for most organisms, and therefore suggests a problem with the assembly.

These metrics should therefore be used only as a quick, crude way of detecting major problems with the assembly.

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
n90                             276
n70                             441
n50                             670
n30                            1021
n10                            1878
gc                             0.44
gc skew                        -0.0
at skew                        0.01
cpg ratio                      0.56
bases n                      178748
proportion n                    0.0
linguistic complexity           0.1
```

| name          | explanation  |
| ------------- |:-------------|
| n_seqs | the number of contigs in the assembly |
| smallest | the size of the smallest contig |
| largest | the size of the largest contig |
| n_bases | the number of bases included in the assembly |
| mean_len | the mean length of the contigs |
| n > 1k | the number of contigs greater than 1,000 bases long |
| n > 10k | the number of contigs greater than 10,000 bases long |
| n with orf | the number of contigs that had an open reading frame |
| mean orf percent | the mean percent of the contig covered by an ORF |
| nX | the largest contig size at which at least X% of bases are contained in contigs at least this length |
| gc | % of bases that are G or C |
| gc skew | http://en.wikipedia.org/wiki/GC_skew |
| at skew | see GC skew |
| cpg ratio | count of CpG sites relative to expected number |
| bases n | the number of bases that are N |
| proportion n | the proportion of bases that are N |
| linguistic complexity | the total [linguistic complexity](http://en.wikipedia.org/wiki/Linguistic_sequence_complexity) of the assembly |

### Read mapping metrics

Read mapping metrics are based on aligning a subset of the reads used in the assembly to the assembled contigs. These are a way of determining how well the assembly is supported by the original experimental evidence, and can be very useful overall quality metrics. However, they should not be considered alone, as read mapping metrics can be high for very fragmented assemblies.

These metrics can be useful for optimising your assembly. In particular, we want to maximise the proportion of the read pairs that map to the contigs successfully and in a biologically plausible way.

When you include the `--left` and `--right` options, Transrate will map the provided reads to the assembly using Bowtie2 and inspect the results. It will output something like:

```
Read mapping metrics:
------------------------------
num pairs              3093698
total mappings         2843248
percent mapping           91.9
good mappings          2840064
pc good mapping           91.8
bad mappings              3184
potential bridges         9247
mean coverage             7.13
n uncovered bases      4854319
p uncovered bases         0.07
n uncovered base contigs 79139
p uncovered base contigs   0.7
n uncovered contigs       9003
p uncovered contigs       0.08
n lowcovered contigs     81404
p lowcovered contigs      0.72
```

| name          | explanation  | optimum
| ------------- |:-------------| :----
| num pairs | the number of read pairs provided | NA |
| total mappings | the total number of read pairs mapping | theoretically all of them if all errors, adapters and contamination have been removed |
| percent mapping | the percentage of read pairs mapping | theoretically 100% (see above) |
| good mappings | the number of read pairs mapping in a way indicative of good assembly | as above |
| pc good mappings | the percentage of read pairs mapping in a way indicative of a good assembly | as above |
| bad | the number and proportion of reads pairs mapping in a way indicative of bad assembly | 0 |
| potential bridges | the number of potential links between contigs that are supported by the reads | 0 |
| mean coverage | the mean per-base coverage across all contigs | no specific optimum, but very low values are bad |
| n uncovered bases | the number of bases that are not covered by any reads | 0 |
| p uncovered bases | the proportion of bases that are not covered by any reads | 0.0 |
| n uncovered base contigs | the number of contigs that contain at least one base with no read coverage | 0 |
| p uncovered base contigs | the proportion of contigs that contain at least one base with no read coverage | 0.0 |
| n uncovered contigs | the number of contigs that have a mean per-base read coverage of < 1 | 0 |
| p uncovered contigs | the proportion of contigs that have a mean per-base read coverage of < 1 | 0.0 |
| n lowcovered contigs | the number of contigs that have a mean per-base read coverage of < 10 | 0 |
| p lowcovered contigs | the number of contigs that have a mean per-base read coverage of < 10 | 0.0 |


#### Good and bad mappings

'Good' mappings are those aligned in a biologically plausible way, i.e.:

- where both members are aligned
- in the correct orientation
- either on the same contig or...
- within a plausible distance of the ends of two separate contigs.

Conversely, 'bad' pairs are those where one of the conditions for being 'good' are not met.

#### Bridges

Additionally, Transrate calculates whether the read mappings contain any evidence that different contigs originate from the same transcript. These theoretical links are called bridges, and the number of bridges is shown in the **supported bridges** metric. A low count of supported bridges could be good or bad depending on the context. If you have a fragmented assembly, a large number of supported bridges means that scaffolding could greatly improve it. On the other hand, a large number of supported bridges in an otherwise seemingly good assembly could be indicative of misassemblies.

The list of supported bridges is output to a file, `supported_bridges.csv`, in case you want to make use of the information. At a later date, transrate will include the ability to scaffold the assembly using this and other information.

### Comparative metrics

Comparative metrics involve comparing the assembly to a related reference species. These metrics are very powerful because they are an external validation of the experimental results.

Usually, the closer the reference species is to the species you've assembled, the more resolution you will have in your comparative metrics. In other words, there are likely to be more genes shared between closely related species than between distantly related species. This means that you are more likely to be able to distinguish between two assemblies of similar quality by using a closely related reference.

Taken with the read mapping metrics, comparative metrics allow you to optimise the quality of your assembly.

When you include the `--reference` option, Transrate will align each contig in your assembly to each protein in the reference using [Conditional Reciprocal Best BLAST](https://github.com/cboursnell/crb-blast) (CRBB). CRBB-hits are high-confidence homologs.

CRB-BLAST starts out with bi-directional BLAST+ alignment of assembly -> reference and reference -> assembly. It then selects the reciprocal best hits as highest confidence and uses them to learn an appropriate e-value cutoff for each length of contig. Finally it selects all alignments with e-values below the cutoff for each length as high-confidence homologs.

Transrate analyses these alignments and produces output like the

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

| name          | explanation  | optimum
| ------------- |:-------------|:----
| CRBB hits | the number of reciprocal best hits against the reference using CRB-BLAST. A high score indicates that a large number of real transcripts have been assembled. | As high as possible. The theoretical maximum is the number of contigs (**n seqs**). In practise, the maximum depends on the evolutionary divergence between the assembled species and the reference.
| contig hit rate | the proportion of contigs having a reciprocal best hit | As high as possible (see above)
| reference hit rate | the proportion of reference sequences having a reciprocal best hit | As high as possible (see above)
| ortholog hit ratio | the mean ratio of alignment length to reference sequence length. A low score on this metric indicates the assembly contains full-length transcripts. |  Close to 1
| collapse factor | the mean number of reference proteins mapping to each contig. A high score on this metric indicates the assembly contains chimeras. |  Dependent on the phylogenomic relationship between the organisms, e.g. whether a genome duplication has taken place.

### Total assembly score

A total assembly score can calculated by combining the other metrics. It takes into account:

- the **proportion of the read pairs that map in a biologically plausible way** ('good')
- the **proportion of the reference sequences having reciprocal best hits** ('rhr')
- the **mean ratio of alignment length to references sequence length** ('ohr')

The score is produced by taking the euclidean distance from the point [0, 0] of the assembly score described by the formula:

 (**good**, **rhr** \* **ohr**)
