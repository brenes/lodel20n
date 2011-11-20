VCR.config do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = 'db/vcr'
  c.stub_with :webmock # or :fakeweb
end