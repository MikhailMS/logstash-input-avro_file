Gem::Specification.new do |s|
  s.name          = 'logstash-input-avro_file'
  s.version       = '0.1.0'
  s.licenses      = ['MIT']
  s.summary       = 'Input plugin to handle AVRO files'
  s.authors       = ['Mikhail Molotkov']
  s.require_paths = ['lib']

  s.files = Dir['lib/**/*', 'spec/**/*', '*.gemspec', '*.md', 'CONTRIBUTORS', 'Gemfile', 'LICENSE', 'NOTICE.TXT', 'vendor/jar-dependencies/**/*.jar', 'vendor/jar-dependencies/**/*.rb', 'VERSION', 'docs/**/*']
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { 'logstash_plugin' => 'true', 'logstash_group' => 'input' }

  # Gem dependencies
  s.add_runtime_dependency 'avro',        '~> 1.10.2' # (Apache 2.0 license)
  s.add_runtime_dependency 'filewatcher', '~> 2.1'

  s.add_runtime_dependency 'logstash-codec-plain'
  s.add_runtime_dependency 'logstash-core-plugin-api', '>= 1.60', '<= 2.99'

  s.add_development_dependency 'logstash-devutils'
end
