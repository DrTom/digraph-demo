module QueryHelper
  extend self 

  ILLEAGAL_ID = -1

  # this is a compatibility workaround; tested with PostgreSQL and sqlite3
  def map_to_inclause seq, val_id
    if seq.empty? 
      [ILLEAGAL_ID]
    else
      seq.map(& val_id)
    end
  end

end
