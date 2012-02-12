require 'spec_helper'
require 'set'

describe Node do

  it "should be creatable" do
    n1 = Node.create
    Node.find(n1.id).should_not == nil
  end

  context "testing relations on the graph n1 -> n2 -> n3 -> n4 " do

    before :all do
      @n1 = Node.create
      @n2 = Node.create
      @n3 = Node.create
      @n4 = Node.create
      @a12 = Arc.create source: @n1, target: @n2
      @a23 = Arc.create source: @n2, target: @n3
      @a34 = Arc.create source: @n3, target: @n4
    end


    it "outarcs n2 hould be n2->n3" do
      Set.new(@n2.out_arcs).should == (Set.new [@a23])
    end

    it "inarcs n2 hould be n1->n2" do
      Set.new(@n2.in_arcs).should == (Set.new [@a12])
    end

    it "successors n2 should be n3" do
      @n2.successors.should == [@n3]
    end

    it "predecessors n2 should be n1" do
      @n2.predecessors.should == [@n1]
    end

    it "graph_descendants n2 should be [n3,n4]" do
      Set.new(@n2.graph_descendants).should == (Set.new [@n3,@n4])
    end

    it "graph_ancestors n3 should be [n1,n2]" do
      Set.new(@n3.graph_ancestors).should == (Set.new [@n1,@n2])
    end


  end


end


