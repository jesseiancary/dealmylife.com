class SystemFile
  
  def exists?
    File.exists? (@fullpath)
  end
  alias exist? exists?
  
  def fullpath
    @fullpath
  end
  
  def contents
    File.open(@fullpath, "r") { |f| f.read }
  end
  
  def save(contents)
    
    Dir.mkdir(@path) unless File.directory?(@path)
    
    #contents = contents.gsub("\r\n", "{crlf}").gsub("\r", "{cr}").gsub("\n", "{lf}").gsub("\t", "{t}")
    
    File.open(@fullpath, "w+") { |f| f.write contents }
    #File.chmod(664, @fullpath)
    
    # Check for file write errors !!  return false
    
    return true
    
  end
  
  protected
  
  def initialize(p, f)
    @fullpath = File.join(@path = p, @file = f.gsub(" ", "-"))
    File.open(@fullpath, "w+") if !self.exists?
  end
  
end