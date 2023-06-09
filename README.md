# Logstash AVRO File input plugin

This is AVRO file input plugin for [Logstash](https://github.com/elastic/logstash).

It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way.


## Building
0. To build the plugin, you need to have:
    1. JRuby    installed
    2. Logstash binaries
1. It is recommended to have `rbenv` installed, so you can install any required JRuby version (as logstash gets upgraded, you may need newer JRuby each time you build plugin for that version of logstash)
2. You need to set 2 env varialbes
```bash
export LOGSTASH_PATH=/path/to/logstash/binaries
export LOGSTASH_SOURCE=1
```
4. Install dependencies*
```sh
bundle install
bundle exec rake vendor
```
5. Build plugin
```sh
gem build logstash-input-avro_file.gemspec
```


## Test
- Run tests

```sh
bundle exec rspec
```


## Use plugin in Logstash
1. Build plugin locally
2. Install plugin to the local version of Logstash that was used to build the plugin
3. Once plugin is installed to local Logstash, create offline-package with the plugin
```sh
./bin/logstash-plugin prepare-offline-pack logstash-input-avro_file
```
4. Deploy artifact generated in Step 3 onto server where Logstash runs
5. To install offline-package run following command from Logstash directory
```sh
./bin/logstash-plugin install --local file:///path/to/custom/plugin.zip
```


## Notes:
1. Known limitations:
    1. Can only handle complete files: if you append events to file, those won't be processed
    2. Doesn't save position in the file, so if you restart the Logstash, this input would process file from the start
2. Interesting, but `filewatcher` gem is not being packed together with this plugin when it gets build (probably missing something), so `filewatcher` gem (and its dependencies) must be manually copied into `LOGSTASH_PATH/vendor/cache`, otherwise you won't be able to install it (only locally, when you prepare-offline-pack it gets sorted nicely)
