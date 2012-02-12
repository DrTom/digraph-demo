
namespace :generator do

  task :cycle  => :environment do
    Arc.destroy_all
    Node.destroy_all

    n = ENV['N'] && ENV['N'].to_i || 3

    prev = Node.create
    (2..n).each do
      nxt = Node.create
      prev.successors << nxt
      prev = nxt
    end

    begin
      Node.last.successors << Node.first
    rescue Exception => err
      puts err
    end

  end

  task :twostar => :environment do
    Arc.destroy_all
    Node.destroy_all

    n = ENV['N'] && ENV['N'].to_i || 50
    star_n = n / 2  - 1

    c1 = Node.create
    c2 = Node.create
    c1.successors << c2

    (1..star_n).each do
      Node.create.successors << c1
      c2.successors << Node.create
    end

  end


  task :er => :environment do

    Arc.destroy_all
    Node.destroy_all

    n = ENV['N'] && ENV['N'].to_i || 100
    m = ENV['M'] && ENV['M'].to_i || [n * (n-1) /2, 5*n].min

    (1..n).each do
      Node.create
    end

    min_id = Node.order("id asc").limit(1).first.id
    max_id = Node.order("id desc").limit(1).first.id
    diff = max_id - min_id

    begin
      begin
        Node.find(rand(diff) + min_id).successors <<  Node.find(rand(diff) + min_id)
      rescue Exception => err
        puts err
      end
    end while(Arc.count < m);

  end

end

