#coding: utf-8
class LabelCandidatesController < ApplicationController
  before_filter :bind_syn_set, :only => [:edit, :update]

  def index
    sql = <<SQL
      SELECT * FROM syn_sets
      WHERE EXISTS (  SELECT syn_set_id
                          FROM word_senses
                          WHERE syn_set_id = syn_sets.id
                          AND label_candidate IS NULL
                          GROUP BY syn_set_id
                          HAVING COUNT(*) > 1)
      ORDER BY RANDOM()
      LIMIT 1
SQL
    @random_syn_set = DanNet::SynSet.find_by_sql(sql)
    redirect_to edit_label_candidate_url(@random_syn_set)
  end

  def update
    @syn_set.attributes = params[:dan_net_syn_set]
    if @syn_set.save
      flash[:notice] = "Gemt!"
      redirect_to label_candidates_url
    end
  end
  
  def export
    rows = DanNet::WordSense.all(:conditions => 'label_candidate IS NOT NULL').collect do |ws|
      syn_set = ws.syn_set
      word  = ws.word
      words = syn_set.word_senses.map(&:word)
      { :word => word.lemma,
        #:syn_set_id => syn_set.id
        :long_word => word.lemma.length > words.map {|w| w.lemma.length}.min || words.length == 1,
        :specific_sense => syn_set.depth >= 4,
        :dan_net_freq  => word.syn_sets.count,
#        :length => word.lemma.length,
#        :avg_length => words.sum {|w| w.lemma.length }.to_f / words.size,
#        :depth => syn_set.depth,
#        :max_depth => words.map(&:word_senses).flatten.map {|ws| ws.syn_set.depth }.max,
#        :dan_net_freq  => word.syn_sets.count,
#        :avg_dan_net_freq => words.sum {|w| w.syn_sets.count },
        :label_candidate => ws.label_candidate,
        
      }
    end
    keys = rows.first.keys
    out = keys*";" + "\r\n"
    out += rows.collect {|row|
      keys.collect do |key|
        row[key]
      end*";"
    }*"\r\n"
    render :text => out
  end

  private
  def bind_syn_set
    @syn_set = DanNet::SynSet.find(params[:id])
  end

end
