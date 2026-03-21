# frozen_string_literal: true

require 'spec_helper'
require 'legion/extensions/postgres/helpers/client'
require 'legion/extensions/postgres/runners/tables'

RSpec.describe Legion::Extensions::Postgres::Runners::Tables do
  let(:pg_conn) { double('PGConnection') }

  let(:runner_class) do
    conn = pg_conn
    Class.new do
      include Legion::Extensions::Postgres::Runners::Tables

      define_method(:connection) { |**_opts| conn }
    end
  end

  let(:runner) { runner_class.new }

  describe '#list_tables' do
    it 'returns an array of table names' do
      rows = [{ 'table_name' => 'orders' }, { 'table_name' => 'products' }, { 'table_name' => 'users' }]
      allow(pg_conn).to receive(:exec_params).and_return(rows)
      expect(runner.list_tables).to eq({ result: %w[orders products users] })
    end

    it 'passes the schema as a bind parameter' do
      allow(pg_conn).to receive(:exec_params).with(anything, ['public']).and_return([])
      runner.list_tables(schema: 'public')
      expect(pg_conn).to have_received(:exec_params).with(anything, ['public'])
    end

    it 'accepts a custom schema' do
      rows = [{ 'table_name' => 'metrics' }]
      allow(pg_conn).to receive(:exec_params).with(anything, ['analytics']).and_return(rows)
      expect(runner.list_tables(schema: 'analytics')).to eq({ result: ['metrics'] })
    end

    it 'returns an empty array when the schema has no tables' do
      allow(pg_conn).to receive(:exec_params).and_return([])
      expect(runner.list_tables).to eq({ result: [] })
    end
  end

  describe '#describe_table' do
    let(:id_column) do
      {
        'column_name'              => 'id',
        'data_type'                => 'integer',
        'character_maximum_length' => nil,
        'is_nullable'              => 'NO',
        'column_default'           => "nextval('users_id_seq'::regclass)"
      }
    end

    let(:email_column) do
      {
        'column_name'              => 'email',
        'data_type'                => 'character varying',
        'character_maximum_length' => '255',
        'is_nullable'              => 'YES',
        'column_default'           => nil
      }
    end

    let(:column_rows) { [id_column, email_column] }

    it 'returns column definitions as symbol-keyed hashes' do
      allow(pg_conn).to receive(:exec_params).and_return(column_rows)
      result = runner.describe_table(table: 'users')
      expect(result[:result].first).to include(column_name: 'id', data_type: 'integer')
    end

    it 'passes table name and schema as bind parameters' do
      allow(pg_conn).to receive(:exec_params).with(anything, %w[public users]).and_return([])
      runner.describe_table(table: 'users', schema: 'public')
      expect(pg_conn).to have_received(:exec_params).with(anything, %w[public users])
    end

    it 'returns an empty array for a non-existent table' do
      allow(pg_conn).to receive(:exec_params).and_return([])
      expect(runner.describe_table(table: 'nonexistent')).to eq({ result: [] })
    end
  end

  describe '#table_size' do
    it 'returns the table size as an integer' do
      allow(pg_conn).to receive(:exec_params)
        .with('SELECT pg_total_relation_size($1) AS size', ['orders'])
        .and_return([{ 'size' => '16384' }])
      expect(runner.table_size(table: 'orders')).to eq({ result: 16_384 })
    end

    it 'casts the size string to integer' do
      allow(pg_conn).to receive(:exec_params).and_return([{ 'size' => '8192' }])
      result = runner.table_size(table: 'users')
      expect(result[:result]).to be_a(Integer)
      expect(result[:result]).to eq(8192)
    end
  end
end
