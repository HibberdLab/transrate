require 'bio'
require 'csv'
require 'forwardable'

module Transrate

  # Container for a transcriptome assembly and its associated
  # metadata.
  #
  # @!attribute [rw] ublast_db
  #   @return [String] path to a ublast database generated from this assembly
  # @!attribute [rw] orss_ublast_db
  #   @return [String] path to a ublast database generated from the orfs
  #     extracted from this assembly
  # @!attribute [r] assembly
  #   @return [Array<Bio::FastaFormat>] the assembly
  # @!attribute [r] has_run
  #   @return [BOOL] whether the basic metrics have been generated
  # @!attribute [w] n_bases
  #   @return [Integer] the number of bases in the assembly
  # @!attribute [rw] file
  #   @return [String] path to the assembly FASTA file
  # @!attribute [r] n50
  #   @return [Integer] assembly n50
  class Assembly

    include Enumerable
    extend Forwardable
    def_delegators :@assembly, :each, :<<, :size, :length

    attr_accessor :file
    attr_reader :assembly
    attr_reader :has_run
    attr_accessor :n_bases
    attr_reader :n50

    # Create a new Assembly.
    #
    # @param file [String] path to the assembly FASTA file
    def initialize file
      @file = File.expand_path file
      @assembly = []
      @n_bases = 0
      Bio::FastaFormat.open(file).each do |entry|
        @n_bases += entry.length
        @assembly << Contig.new(entry)
      end
    end

    # Return basic statistics about the assembly in
    # the specified FASTA file
    #
    # @param file [String] path to assebmly FASTA file
    #
    # @return [Hash] basic statistics about the assembly
    def self.stats_from_fasta file
      a = Assembly.new file
      a.basic_stats
    end

    # Generate and store the basic statistics for this assembly
    #
    # @param threads [Integer] number of threads to use
    def run threads=8
      stats = self.basic_stats threads
      stats.each_pair do |key, value|
        ivar = "@#{key.gsub(/\ /, '_')}".to_sym
        attr_ivar = "#{key.gsub(/\ /, '_')}".to_sym
        # creates accessors for the variables in stats
        singleton_class.class_eval { attr_accessor attr_ivar }
        self.instance_variable_set(ivar, value)
      end
      @has_run = true
    end

    # Return a hash of statistics about this assembly. Stats are
    # calculated in parallel by splitting the assembly into
    # equal-sized bins and calling Assembly#basic_bin_stat on each
    # bin in a separate thread.
    #
    # @param threads [Integer] number of threads to use
    #
    # @return [Hash] basic statistics about the assembly
    def basic_stats threads=8

      # disable threading basic stats for now
      threads = 1

      # create a work queue to process contigs in parallel
      queue = Queue.new

      # split the contigs into equal sized bins, one bin per thread
      binsize = (@assembly.size / threads.to_f).ceil
      @assembly.each_slice(binsize) do |bin|
        queue << bin
      end
      # a classic threadpool - an Array of threads that allows
      # us to assign work to each thread and then aggregate their
      # results when they are all finished
      threadpool = []

      # assign one bin of contigs to each thread from the queue.
      # each thread will process its bin of contigs and then wait
      # for the others to finish.
      semaphore = Mutex.new
      stats = []

      threads.times do
        threadpool << Thread.new do |thread|
          # keep looping until we run out of bins
          until queue.empty?

            # use non-blocking pop, so an exception is raised
            # when the queue runs dry
            bin = queue.pop(true) rescue nil
            if bin
              # calculate basic stats for the bin, storing them
              # in the current thread so they can be collected
              # in the main thread.
              bin_stats = basic_bin_stats bin
              semaphore.synchronize { stats << bin_stats }
            end
          end
        end
      end

      # collect the stats calculated in each thread and join
      # the threads to terminate them
      threadpool.each(&:join)
      # merge the collected stats and return then
      # merge_basic_stats stats
      # as threading is currently disabled there's no need to do merging
      stats[0]

    end # basic_stats


    # Calculate basic statistics in an single thread for a bin
    # of contigs.
    #
    # Basic statistics are:
    #
    # - N10, N30, N50, N70, N90
    # - number of contigs >= 1,000 base pairs long
    # - number of contigs >= 10,000 base pairs long
    # - length of the shortest contig
    # - length of the longest contig
    # - number of contigs in the bin
    # - mean contig length
    # - total number of nucleotides in the bin
    # - mean % of contig length covered by the longest ORF
    #
    # @param [Array] bin An array of Bio::Sequence objects
    # representing contigs in the assembly

    def basic_bin_stats bin

      # cumulative length is a float so we can divide it
      # accurately later to get the mean length
      cumulative_length = 0.0

      # we'll calculate Nx for x in [10, 30, 50, 70, 90]
      # to do this we create a stack of the x values and
      # pop the first one to set the first cutoff. when
      # the cutoff is reached we store the nucleotide length and pop
      # the next value to set the next cutoff. we take a copy
      # of the Array so we can use the intact original to collect
      # the results later
      x = [90, 70, 50, 30, 10]
      x2 = x.clone
      cutoff = x2.pop / 100.0
      res = []
      n_under_200 = 0
      n_over_1k = 0
      n_over_10k = 0
      n_with_orf = 0
      orf_length_sum = 0
      # sort the contigs in ascending length order
      # and iterate over them
      bin.sort_by! { |c| c.seq.length }
      bin.each do |contig|

        # increment our long contig counters if this
        # contig is above the thresholds
        if contig.length < 200
          # ignore contigs less than 200 bases,
          # but record how many there are
          n_under_200 += 1
          next
        end
        n_over_1k += 1 if contig.length > 1_000
        n_over_10k += 1 if contig.length > 10_000

        # add the length of the longest orf to the
        # running total
        orf_length = contig.orf_length
        orf_length_sum += orf_length
        # only consider orfs that are realistic length
        # (here we set minimum amino acid length as 50)
        n_with_orf += 1 if orf_length > 149

        # increment the cumulative length and check whether the Nx
        # cutoff has been reached. if it has, store the Nx value and
        # get the next cutoff
        cumulative_length += contig.length
        if cumulative_length >= @n_bases * cutoff
          res << contig.length
          if x2.empty?
            cutoff = 1
          else
            cutoff = x2.pop / 100.0
          end
        end

      end

      # if there aren't enough sequences we might have no value for some
      # of the Nx. Fill the empty ones in with the longest contig length.
      while res.length < x.length do
        res << bin.last.length
      end

      # calculate and return the statistics as a hash
      mean = cumulative_length / @assembly.size
      ns = Hash[x.map { |n| "n#{n}" }.zip(res)]
      {
        'n_seqs' => bin.size,
        'smallest' => bin.first.length,
        'largest' => bin.last.length,
        'n_bases' => n_bases,
        'mean_len' => mean,
        'n_under_200' => n_under_200,
        'n_over_1k' => n_over_1k,
        'n_over_10k' => n_over_10k,
        'n_with_orf' => n_with_orf,
        'mean_orf_percent' => 300 * orf_length_sum / (@assembly.size * mean)
      }.merge ns

    end # basic_bin_stats

    def merge_basic_stats stats
      # convert the array of hashes into a hash of arrays
      collect = Hash.new{ |h, k| h[k] = [] }
      stats.each_with_object(collect) do |collect, result|
        collect.each{ |k, v| result[k] << v }
      end
      merged = {}
      collect.each_pair do |stat, values|
        if stat == 'orf_percent' || /N[0-9]{2}/ =~ stat
          # store the mean
          merged[stat] = values.inject(0, :+) / values.size
        elsif stat == 'smallest'
          merged[stat] = values.min
        elsif stat == 'largest'
          merged[stat] = values.max
        else
          # store the sum
          merged[stat] = values.inject(0, :+)
        end
      end

      merged

    end # merge_basic_stats

    # return the number of bases in the assembly, calculating
    # from the assembly if it hasn't already been done.
    def n_bases
      unless @n_bases
        @n_bases = 0
        @assembly.each { |s| @n_bases += s.length }
      end
      @n_bases
    end

    def print_stats
      self.basic_stats.map do |k, v|
        "#{k}#{" " * (20 - (k.length + v.to_i.to_s.length))}#{v.to_i}"
      end.join('\n')
    end

    # Calls *block* with two arguments, the contig and an array
    # of integer per-base coverage counts.
    #
    # @param bam [Bio::Db::Sam] a bam alignment of reads against this assembly
    # @param block [Block] the block to call
    def each_with_coverage(bam, &block)
      # generate coverage with samtools
      covfile = Samtools.coverage bam
      # get an assembly enumerator
      assembly_enum = assembly.each
      contig = assembly_enum.next
      # precreate an array of the correct size to contain
      # coverage. this is necessary because samtools mpileup
      # doesn't print a result line for bases with 0 coverage
      contig.coverage = Array.new(contig.length, 0)
      # the columns we need
      name_i, pos_i, cov_i = 0, 1, 3
      # parse the coverage file
      File.open(covfile).each_line do |line|
        cols = line.chomp.split("\t")
        unless (cols && cols.length > 4)
          # last line
          break
        end
        # extract the columns
        name, pos, cov = cols[name_i], cols[pos_i].to_i, cols[cov_i].to_i
        unless contig.name == name
          while contig.name != name
            block.call(contig, contig.coverage)
            contig = assembly_enum.next
            contig.coverage = Array.new(contig.length, 0)
          end
        end
        contig.coverage[pos - 1] = cov
      end
      # yield the final contig
      block.call(contig, contig.coverage)
    end

  end # Assembly

end # Transrate
