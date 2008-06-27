## uniq -- IKeJI
## 
## it looks like uniq command in unix

def uniq(config,data)
  result = {}
  data.reverse.each_with_index do|i,ind|
    result[ (i.link rescue i) ] = [ind,i]
  end
  data = []
  result.values.sort{|a,b| b[0]<=>a[0]}.each do |a|
    data << a[1]
  end
  return data
end
