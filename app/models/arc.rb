require 'set'

class Arc < ActiveRecord::Base
  extend QueryHelper

  before_save :prevent_back_loop
  before_save :prevent_cycle
  before_save :prevent_multi_arc
  before_save :prevent_self_loop

  belongs_to :source, class_name: "Node", foreign_key: :source_id
  belongs_to :target, class_name: "Node", foreign_key: :target_id

  scope :successors, lambda { |from| 
    where("source_id in (?)",map_to_inclause(from,:target_id))
  }

  scope :predecessors, lambda { |to|
    where("target_id in (?)",map_to_inclause(to,:source_id))
  }


  class << self

    [[:graph_descendants,:successors],[:graph_ancestors,:predecessors]].each do |mdef|
      name,call_scope =  mdef
      define_method name do |arcs|
        new_found= send call_scope, arcs
        found = Set.new new_found
        while new_found.size > 0
          new_found = (send call_scope, new_found).keep_if{|arc| not found.include?(arc)}
          found.merge new_found
        end
        where("id in (?)",map_to_inclause(found,:id))
      end
    end

  end


  def prevent_multi_arc 
    unless Arc.where("target_id = ?",target_id).where("source_id = ?",source_id).empty?
      raise "multiarcs are not allowed"
    end
  end

  def prevent_self_loop 
    if target_id == source_id
      raise "self loops are not allowed"
    end
  end

  def prevent_back_loop
    unless Arc.where("target_id = ?",source_id).where("source_id = ?",target_id).empty?
      raise "back loops are not allowed"
    end
  end

  def prevent_cycle
    if Node.find(target_id).graph_descendants.include? Node.find(source_id)
      raise "arcs which create cycles are not allowed"
    end
  end

end
