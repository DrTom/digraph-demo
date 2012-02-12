
select * from nodes;
select * from arcs;

select target_id from arcs where source_id in ( IDS_OF_ALL_BLUE_NODES );

-- example: all successors of the node with minimal id
select * from nodes where nodes.id in (
  with recursive 
    pair(p,s) as 
      (   select source_id as p, target_id as s from arcs where source_id = (select min(id) from nodes)
        UNION
          select pair.p , arcs.target_id as s from pair
            INNER JOIN arcs on s = arcs.source_id)
  select s from pair);



-- example: get up to the second level successors of the node with minimal id
select target_id from arcs where source_id = (select min(id) from nodes)
UNION 
select target_id from arcs where source_id in (
  select target_id from arcs where source_id = (select min(id) from nodes));


