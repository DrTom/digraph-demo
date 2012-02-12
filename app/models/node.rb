class Node < ActiveRecord::Base
  include QueryHelper

  has_many :in_arcs, class_name: Arc.name, foreign_key: :target_id
  has_many :out_arcs, class_name: Arc.name, foreign_key: :source_id

  has_many :predecessors, through: :in_arcs, source: :source
  has_many :successors, through: :out_arcs, source: :target


  def graph_descendants
    Node.where "id in (?)" , map_to_inclause((Arc.graph_descendants(out_arcs) | out_arcs),:target_id)
  end

  def graph_ancestors
    Node.where "id in (?)" , map_to_inclause((Arc.graph_ancestors(in_arcs) | in_arcs), :source_id)
  end

end
