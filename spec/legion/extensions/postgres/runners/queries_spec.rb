# frozen_string_literal: true

require 'spec_helper'
require 'legion/extensions/postgres/helpers/client'
require 'legion/extensions/postgres/runners/queries'

RSpec.describe Legion::Extensions::Postgres::Runners::Queries do
  let(:pg_conn) { double('PGConnection') }

  let(:runner_class) do
    conn = pg_conn
    Class.new do
      include Legion::Extensions::Postgres::Runners::Queries

      define_method(:connection) { |**_opts| conn }
    end
  end

  let(:runner) { runner_class.new }

  describe '#execute' do
    it 'returns rows as an array of symbol-keyed hashes' do
      allow(pg_conn).to receive(:exec).with('SELECT 1 AS val').and_return([{ 'val' => '1' }])
      expect(runner.execute(sql: 'SELECT 1 AS val')).to eq({ result: [{ val: '1' }] })
    end

    it 'returns an empty array when the query yields no rows' do
      allow(pg_conn).to receive(:exec).with('SELECT 1 WHERE false').and_return([])
      expect(runner.execute(sql: 'SELECT 1 WHERE false')).to eq({ result: [] })
    end

    it 'converts string keys to symbols on each row' do
      rows = [{ 'id' => '1', 'name' => 'Jane Doe' }]
      allow(pg_conn).to receive(:exec).with('SELECT id, name FROM users').and_return(rows)
      result = runner.execute(sql: 'SELECT id, name FROM users')
      expect(result[:result].first).to eq({ id: '1', name: 'Jane Doe' })
    end
  end

  describe '#execute_params' do
    it 'passes params to exec_params and returns symbol-keyed rows' do
      allow(pg_conn).to receive(:exec_params)
        .with('SELECT * FROM users WHERE id = $1', [42])
        .and_return([{ 'id' => '42', 'name' => 'Jane Doe' }])
      result = runner.execute_params(sql: 'SELECT * FROM users WHERE id = $1', params: [42])
      expect(result[:result]).to eq([{ id: '42', name: 'Jane Doe' }])
    end

    it 'defaults params to an empty array' do
      allow(pg_conn).to receive(:exec_params).with('SELECT now()', []).and_return([{ 'now' => '2026-03-21' }])
      result = runner.execute_params(sql: 'SELECT now()')
      expect(result).to eq({ result: [{ now: '2026-03-21' }] })
    end

    it 'returns an empty array when no rows match' do
      allow(pg_conn).to receive(:exec_params).with('SELECT * FROM users WHERE id = $1', [999]).and_return([])
      result = runner.execute_params(sql: 'SELECT * FROM users WHERE id = $1', params: [999])
      expect(result).to eq({ result: [] })
    end
  end
end
