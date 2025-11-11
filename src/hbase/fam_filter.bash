import org.apache.hadoop.hbase.filter.SingleColumnValueFilter
import org.apache.hadoop.hbase.filter.CompareFilter
import org.apache.hadoop.hbase.util.Bytes

scan('family', { COLUMNS => ['favorites:food'] }).each do |row|
  foods = row['favorites:food'].map { |c| c['value'] } rescue []
  if foods.include?('Pizza')
    # Get the personal:name column
    name = get('family', row['ROW'], 'personal:name')[0]['value'] rescue ''
    puts "#{row['ROW']}\t#{name}"
  end
end
