#coding: utf-8
class WordSensesController < ApplicationController
  before_filter :bind_query, :only => :search

  def show
    @sense  = DanNet::WordSense.find(params[:id])
    if params[:id] != @sense.to_param
      redirect_to ord_path(@sense), :status=> :moved_permanently
    end
    @syn_set  = @sense.syn_set
    @alignments = @syn_set.alignments
    @title = "#{@sense.heading} – #{@syn_set.gloss}"
    @synonyms = @sense.synonyms
    @hyponyms = @syn_set.hyponyms.sort_by(&:pretty_label)
    @features = @syn_set.features
    bind_paths
    bind_related_syn_sets
  end

  def search
    sense = DanNet::WordSense.find_by_heading(@query)
    if sense
      redirect_to ord_path(sense), :status => :moved_permanently
    elsif DanNet::Word.find_by_lemma(@query)
      redirect_to disambiguage_word_sense_path(@query)
    else
      redirect_to correct_spelling_path(@query)
    end
  end

  def best_for_syn_set
    syn_set = DanNet::SynSet.find(params[:syn_set_id])
    redirect_to ord_path(syn_set.word_senses.first), :status => :moved_permanently
  end

  private
  def bind_paths
    @paths_to_top = @syn_set.paths_to_top.sort_by(&:size)
    # Take first element if all elements are of the same size
    if first = @paths_to_top.first
      @paths_to_top = [first] if @paths_to_top.all? {|path| first.size == path.size }
    end
  end

  def bind_related_syn_sets
    graph = DanNet::WordSenseGraph.new(@sense)
    @related_syn_sets = Hash.new {|h,k| h[k] = {} }
    graph.capped_relation_groups(140,100).each do |rel_type,syn_sets|
      syn_sets.each do |syn_set|
        @related_syn_sets[t(rel_type.name)][syn_set.pretty_label] = {
          'link'     => ord_path(syn_set.word_senses.preferred),
          'synonyms' => syn_set.words.map(&:lemma)*',',
          'gloss'    => syn_set.gloss
        }
      end
    end
  end

end
