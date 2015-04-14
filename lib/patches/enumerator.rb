class Enumerator
  def rate_limit(iterations, per: )
    unless block_given?
      return to_enum(:rate_limit, iterations, per: per) { size }
    end
    with_index do |elt, idx|
      sleep(per) if idx != 0 && idx % iterations == 0
      yield elt
    end
  end
end