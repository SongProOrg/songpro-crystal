require "./part"
require "./measure"

class Line
  property parts : Array(Part) = Array(Part).new,
    measures : Array(Measure) = Array(Measure).new,
    tablature : String = "",
    comment : String = ""

  def measures?
    measures.size > 0
  end

  def tablature?
    tablature.size > 0
  end

  def comment?
    comment.size > 0
  end
end
