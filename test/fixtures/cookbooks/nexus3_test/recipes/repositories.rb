conf = Mash.new(
  maven: {
    versionPolicy: 'RELEASE',
    layoutPolicy: 'STRICT'
  },
  storage: {
    blobStoreName: 'default',
    writePolicy: 'ALLOW_ONCE'
  }
)

nexus3_repo 'foo' do
  attributes conf
  retries 10
  retry_delay 10
end

nexus3_repo 'foo again' do
  repo_name 'foo'
  attributes conf
  notifies :run, 'ruby_block[fail if foo is created again]', :immediately
end

ruby_block 'fail if foo is created again' do
  action :nothing
  block { raise 'nexus3_repo is not idempotent!' }
end

nexus3_repo 'bar' do
  action %i(create delete)
  attributes conf
  retries 10
  retry_delay 10
end