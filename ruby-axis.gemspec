# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ruby-axis}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bryan Taylor"]
  s.cert_chain = ["/home/bryan/gem_private_key/gem-public_cert.pem"]
  s.date = %q{2011-04-25}
  s.description = %q{A gem that provides a ruby API to Axis cameras}
  s.email = %q{btaylor39 @nospam@ csc.com}
  s.files = ["Manifest", "Rakefile", "ruby-axi.gemspec", "ruby-axis.gemspec"]
  s.homepage = %q{http://rubyisbeautiful.com}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Ruby-axis"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ruby-axis}
  s.rubygems_version = %q{1.3.7}
  s.signing_key = %q{/home/bryan/gem_private_key/gem-private_key.pem}
  s.summary = %q{features: uses VAPIX, telnet, scripting}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
