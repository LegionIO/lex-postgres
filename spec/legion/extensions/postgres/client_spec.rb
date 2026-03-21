# frozen_string_literal: true

require 'spec_helper'
require 'legion/extensions/postgres/client'

RSpec.describe Legion::Extensions::Postgres::Client do
  let(:mock_conn) { double('PGConnection') }

  before do
    allow(Legion::Extensions::Postgres::Helpers::Client).to receive(:connection).and_return(mock_conn)
  end

  describe '#initialize' do
    it 'stores default options' do
      client = described_class.new
      expect(client.opts).to include(host: '127.0.0.1', port: 5432, dbname: 'postgres', user: 'postgres')
    end

    it 'omits password from opts when not provided' do
      client = described_class.new
      expect(client.opts).not_to have_key(:password)
    end

    it 'includes password in opts when provided' do
      client = described_class.new(password: 'secret')
      expect(client.opts).to include(password: 'secret')
    end

    it 'accepts custom connection options' do
      client = described_class.new(host: 'db.local', port: 5433, dbname: 'myapp', user: 'app')
      expect(client.opts).to include(host: 'db.local', port: 5433, dbname: 'myapp', user: 'app')
    end
  end

  describe '#connection' do
    it 'delegates to Helpers::Client.connection with stored opts' do
      client = described_class.new(host: 'db.local', dbname: 'myapp')
      result = client.connection
      expect(Legion::Extensions::Postgres::Helpers::Client).to have_received(:connection)
        .with(hash_including(host: 'db.local', dbname: 'myapp'))
      expect(result).to eq(mock_conn)
    end

    it 'allows per-call overrides' do
      client = described_class.new(host: 'db.local')
      client.connection(dbname: 'override_db')
      expect(Legion::Extensions::Postgres::Helpers::Client).to have_received(:connection)
        .with(hash_including(host: 'db.local', dbname: 'override_db'))
    end
  end

  describe 'runner methods' do
    let(:client_instance) { described_class.new }

    it 'responds to Queries runner methods' do
      expect(client_instance).to respond_to(:execute, :execute_params)
    end

    it 'responds to Tables runner methods' do
      expect(client_instance).to respond_to(:list_tables, :describe_table, :table_size)
    end

    it 'can call execute through the client' do
      pg_result = [{ 'count' => '5' }]
      allow(mock_conn).to receive(:exec).with('SELECT COUNT(*) FROM users').and_return(pg_result)
      result = client_instance.execute(sql: 'SELECT COUNT(*) FROM users')
      expect(result[:result]).to eq([{ count: '5' }])
    end

    it 'can call list_tables through the client' do
      pg_result = [{ 'table_name' => 'users' }, { 'table_name' => 'orders' }]
      allow(mock_conn).to receive(:exec_params).and_return(pg_result)
      result = client_instance.list_tables
      expect(result[:result]).to eq(%w[users orders])
    end
  end
end
