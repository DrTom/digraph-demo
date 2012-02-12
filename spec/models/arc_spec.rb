require 'spec_helper'
require 'set'

describe Arc do

  before :all do
      @n1 = Node.create
      @n2 = Node.create
      @n3 = Node.create
      @n4 = Node.create
  end


  it "a single edge should be creatable" do
    Arc.create source_id: @n1.id, target_id: @n2.id
    Arc.where("source_id = ?",@n1.id).where("target_id = ?", @n2.id).should_not be_empty
  end


  context "testing relations on the graph n1 -> n2 -> n3 -> n4 " do

    before :each do
      @a12 = Arc.create source_id: @n1.id, target_id: @n2.id
      @a23 = Arc.create source_id: @n2.id, target_id: @n3.id
      @a34 = Arc.create source_id: @n3.id, target_id: @n4.id
    end

    it "[@a34] should be in the successors of [@a23]" do
      (Arc.successors [@a23]).should == [@a34]
    end

    it "[@a12] should be in the predecessors of [@a23]" do
      (Arc.predecessors [@a23]).should == [@a12]
    end

    it "[@a23,@a34] should be the graph_descendants of [@a12]" do
      Set.new(Arc.graph_descendants [@a12]).should == Set.new([@a23,@a34])
    end

    it "[@a12,@a23] should be the graph_ancestors of [@a34]" do
      Set.new(Arc.graph_ancestors [@a34]).should == Set.new([@a12,@a23])
    end


  end

  context "testing DAG enforcement on n1 -> n2 -> n3" do

    before :each do
      @a12 = Arc.create source_id: @n1.id, target_id: @n2.id
      @a23 = Arc.create source_id: @n2.id, target_id: @n3.id
    end

    describe "creating a selfloop " do
      it "raises error" do
        expect { @n1.successors << @n1 }.to raise_error
      end
    end

    describe "creating a backloop" do
      it "raises error" do
        expect { @n2.successors << @n1 }.to raise_error
      end
    end

    describe "creating a multi arc" do
      it "raises error" do
        expect { @n1.successors << @n2 }.to raise_error
      end
    end

    describe "creating a cycle" do
      it "raises error" do
        expect { @n3.successors << @n1 }.to raise_error
      end
    end



  end

end
