Transrate
----

Quality analysis and comparison of transcriptome assemblies.

## Transcriptome assembly quality metrics

**transrate** implements a variety of established and new metrics. 

note: this list will be expanded soon with detailed explanations and a guide to interpreting the results.

### Contig metrics

* **n_seqs** - the number of contigs in the assembly
* **smallest** - the size of the smallest contig
* **largest** - the size of the largest contig
* **n_bases** - the number of bases included in the assembly
* **mean_len** - the mean length of the contigs
* **n > 1k** - the number of contigs greater than 1,000 bases long
* **n > 10k** - the number of contigs greater than 10,000 bases long
* **nX** - the largest contig size at which at least X% of bases are contained in contigs *longer* than this length

### Read mapping metrics

* **total** - the total number of reads pairs mapping
* **good** - the number of read pairs mapping in a way indicative of good assembly
* **bad** - the number of reads pairs mapping in a way indicative of bad assembly

'Good' pairs are those where both members are aligned, in the correct orientation, either on the same contig or within a plausible distance of the ends of two separate contigs.

Conversely, 'bad' pairs are those where one of the conditions for being 'good' are not met.

Additionally, the software calculates whether there is any evidence in the read mappings that different contigs originate from the same transcript. These theoretical links are called bridges, and the number of bridges is shown in the **supported bridges** metric. The list of supported bridges is output to a file, `supported_bridges.csv`, in case you want to make use of the information. At a later date, transrate will include the ability to improve the assembly using this and other information.

### Comparative metrics

* **reciprocal hits** - the number of reciprocal best hits against the reference using ublast. A high score indicates that a large number of real transcripts have been assembled.
* **ortholog hit ratio** - the mean ratio of alignment length to reference sequence length. A low score on this assembly indicates the assembly contains full-length transcripts.
* **collapse factor** - the mean number of reference proteins mapping to each contig. A high score on this metric indicates the assembly contains chimeras.

## Installation

You can install transrate very easily. Just run at the terminal:

`gem install transrate`

If that doesn't work, check the requirements below...

## Usage

`transrate --help` will give you...

```
Transrate v0.0.1a by Richard Smith <rds45@cam.ac.uk>

DESCRIPTION:
Analyse a de-novo transcriptome
assembly using three kinds of metrics:

1. contig-based
2. read-mapping
3. reference-based

Please make sure USEARCH and bowtie2 are both installed
and in the PATH.

Bug reports and feature requests at:
http://github.com/blahah/transrate

USAGE:
transrate <options>

OPTIONS:
    --assembly, -a <s>:   assembly file in FASTA format
   --reference, -r <s>:   reference proteome file in FASTA format
        --left, -l <s>:   left reads file in FASTQ format
       --right, -i <s>:   right reads file in FASTQ format
  --insertsize, -n <i>:   mean insert size (default: 200)
    --insertsd, -s <i>:   insert size standard deviation (default: 50)
     --threads, -t <i>:   number of threads to use (default: 8)
         --version, -v:   Print version and exit
            --help, -h:   Show this message
```

If you don't include --left and --right read files, the read-mapping based analysis will be skipped. I recommend that you don't align all your reads - just a subset of 500,000 will give you a very good idea of the quality. You can get a subset by running (on a linux system):

`head -2000000 readfile.fastq`

FASTQ records are 4 lines long, so make sure you multiply the number of reads you want by 4, and be sure to run the same command on both the left and right read files.

### Example

```
transrate --assembly assembly.fasta \
		  --reference reference.fasta \
		  --left l.fq \
		  --right r.fq \
		  --threads 4
```

## Requirements

### Ruby

First, you'll need Ruby v1.9.3 or greater installed. You can check with:

`ruby --version`

If you don't have Ruby installed, or you need a higher version, I recommend using [RVM](http://rvm.io/) as your Ruby Version Manager. To install RVM along with the latest Ruby, just run:

`\curl -L https://get.rvm.io | bash -s stable`

### Rubygems

Your Ruby installation *should* come with RubyGems, the package manager for Ruby. You can check with:

`gem --version`

If you don't have it installed, I recommend installing the latest version of Ruby and RubyGems using the RVM instructions above (in the Requirements:Ruby section.

## Development status

This software is in very early development. Nevertheless, we welcome bug reports.