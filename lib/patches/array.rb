class Array

  def hash_by(msg)
    self.map do |elt|
      [elt.public_send(msg), elt]
    end.to_h
  end

end
