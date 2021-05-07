class Version < PaperTrail::Version


  def whodonit_user
    User.find(self.whodunnit) #rescue self.whodunnit
  end

end