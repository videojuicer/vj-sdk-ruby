# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{vj-sdk}
  s.version = "0.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["danski", "thejohnny", "knowtheory", "sixones", "btab"]
  s.date = %q{2010-03-04}
  s.email = %q{dan@videojuicer.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION.yml",
     "lib/core_ext/cgi.rb",
     "lib/core_ext/hash.rb",
     "lib/core_ext/object.rb",
     "lib/core_ext/string.rb",
     "lib/sdk_connection_harness.rb",
     "lib/videojuicer.rb",
     "lib/videojuicer/asset/audio.rb",
     "lib/videojuicer/asset/base.rb",
     "lib/videojuicer/asset/document.rb",
     "lib/videojuicer/asset/flash.rb",
     "lib/videojuicer/asset/image.rb",
     "lib/videojuicer/asset/text.rb",
     "lib/videojuicer/asset/video.rb",
     "lib/videojuicer/campaign.rb",
     "lib/videojuicer/campaign_policy.rb",
     "lib/videojuicer/criterion/base.rb",
     "lib/videojuicer/criterion/date_range.rb",
     "lib/videojuicer/criterion/geolocation.rb",
     "lib/videojuicer/criterion/request.rb",
     "lib/videojuicer/criterion/time.rb",
     "lib/videojuicer/criterion/week_day.rb",
     "lib/videojuicer/oauth/multipart_helper.rb",
     "lib/videojuicer/oauth/proxy_factory.rb",
     "lib/videojuicer/oauth/request_proxy.rb",
     "lib/videojuicer/presentation.rb",
     "lib/videojuicer/preset.rb",
     "lib/videojuicer/promo/base.rb",
     "lib/videojuicer/resource/base.rb",
     "lib/videojuicer/resource/collection.rb",
     "lib/videojuicer/resource/embeddable.rb",
     "lib/videojuicer/resource/errors.rb",
     "lib/videojuicer/resource/inferrable.rb",
     "lib/videojuicer/resource/property_registry.rb",
     "lib/videojuicer/resource/relationships/belongs_to.rb",
     "lib/videojuicer/resource/types.rb",
     "lib/videojuicer/seed.rb",
     "lib/videojuicer/session.rb",
     "lib/videojuicer/shared/configurable.rb",
     "lib/videojuicer/shared/exceptions.rb",
     "lib/videojuicer/user.rb",
     "spec/assets/audio_spec.rb",
     "spec/assets/document_spec.rb",
     "spec/assets/flash_spec.rb",
     "spec/assets/image_spec.rb",
     "spec/assets/text_spec.rb",
     "spec/assets/video_spec.rb",
     "spec/belongs_to_spec.rb",
     "spec/campaign_policy_spec.rb",
     "spec/campaign_spec.rb",
     "spec/collection_spec.rb",
     "spec/criterion/date_range_spec.rb",
     "spec/criterion/geolocation_spec.rb",
     "spec/criterion/request_spec.rb",
     "spec/criterion/time_spec.rb",
     "spec/criterion/week_day_spec.rb",
     "spec/files/audio.mp3",
     "spec/files/document.js",
     "spec/files/empty_file",
     "spec/files/flash.swf",
     "spec/files/image.jpg",
     "spec/files/text.txt",
     "spec/files/video.mov",
     "spec/helpers/be_equal_to.rb",
     "spec/helpers/spec_fixtures.rb",
     "spec/helpers/spec_helper.rb",
     "spec/presentation_spec.rb",
     "spec/preset_spec.rb",
     "spec/promos/audio_spec.rb",
     "spec/promos/image_spec.rb",
     "spec/promos/text_spec.rb",
     "spec/promos/video_spec.rb",
     "spec/property_registry_spec.rb",
     "spec/request_proxy_spec.rb",
     "spec/seed_spec.rb",
     "spec/session_spec.rb",
     "spec/shared/asset_spec.rb",
     "spec/shared/configurable_spec.rb",
     "spec/shared/dependent_spec.rb",
     "spec/shared/embeddable_spec.rb",
     "spec/shared/model_spec.rb",
     "spec/shared/resource_spec.rb",
     "spec/spec.opts",
     "spec/user_spec.rb",
     "spec/videojuicer_spec.rb",
     "tasks/vj-core.rb",
     "vj-sdk.gemspec"
  ]
  s.homepage = %q{http://github.com/videojuicer/vj-sdk}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Videojuicer core-sdk}
  s.test_files = [
    "spec/assets/audio_spec.rb",
     "spec/assets/document_spec.rb",
     "spec/assets/flash_spec.rb",
     "spec/assets/image_spec.rb",
     "spec/assets/text_spec.rb",
     "spec/assets/video_spec.rb",
     "spec/belongs_to_spec.rb",
     "spec/campaign_policy_spec.rb",
     "spec/campaign_spec.rb",
     "spec/collection_spec.rb",
     "spec/criterion/date_range_spec.rb",
     "spec/criterion/geolocation_spec.rb",
     "spec/criterion/request_spec.rb",
     "spec/criterion/time_spec.rb",
     "spec/criterion/week_day_spec.rb",
     "spec/helpers/be_equal_to.rb",
     "spec/helpers/spec_fixtures.rb",
     "spec/helpers/spec_helper.rb",
     "spec/presentation_spec.rb",
     "spec/preset_spec.rb",
     "spec/promos/audio_spec.rb",
     "spec/promos/image_spec.rb",
     "spec/promos/text_spec.rb",
     "spec/promos/video_spec.rb",
     "spec/property_registry_spec.rb",
     "spec/request_proxy_spec.rb",
     "spec/seed_spec.rb",
     "spec/session_spec.rb",
     "spec/shared/asset_spec.rb",
     "spec/shared/configurable_spec.rb",
     "spec/shared/dependent_spec.rb",
     "spec/shared/embeddable_spec.rb",
     "spec/shared/model_spec.rb",
     "spec/shared/resource_spec.rb",
     "spec/user_spec.rb",
     "spec/videojuicer_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 1.0"])
      s.add_runtime_dependency(%q<ruby-hmac>, [">= 0.3.2"])
      s.add_runtime_dependency(%q<mash>, [">= 0.0.3"])
    else
      s.add_dependency(%q<json>, [">= 1.0"])
      s.add_dependency(%q<ruby-hmac>, [">= 0.3.2"])
      s.add_dependency(%q<mash>, [">= 0.0.3"])
    end
  else
    s.add_dependency(%q<json>, [">= 1.0"])
    s.add_dependency(%q<ruby-hmac>, [">= 0.3.2"])
    s.add_dependency(%q<mash>, [">= 0.0.3"])
  end
end
