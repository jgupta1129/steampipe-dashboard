dashboard "my_s3_dashboard" {

  title = "My S3 Dashboard"

  container {
    card {
      sql = <<-EOQ
        select
          count(*) as "Total Buckets"
        from
          aws_s3_bucket
      EOQ
      width = 2
    } 

    card {
      sql = <<-EOQ
        select
          count(*) as "Unencrypted Buckets"
        from
          aws_s3_bucket
        where
          server_side_encryption_configuration is null;
        EOQ
      type  = "alert" 
      width = 2
    } 
  }


  container {
    title = "Analysis"

	chart {
      title = "Buckets by Account"
      sql = <<-EOQ
        select
		  split_part(arn, ':', 3) as service,
		  case
			when length(split_part(arn, ':', 7)) = 0 then case
			  when POSITION('/' in split_part(arn, ':', 6)) = 0 then null
			  else split_part(split_part(arn, ':', 6), '/', 1)
			end
			else split_part(split_part(arn, ':', 6), '/', 1) --split_part(arn, ':', 6)
		  end as resType,
		  account_id,
		  count(*) --, arn
		from
		  aws_tagging_resource
		group by
		  service,
		  resType,
		  account_id --, arn
		order by
		  account_id,
		  service
      EOQ
      type  = "column"
      width = 6
    }
    chart {
      title = "Buckets by Account"
      sql = <<-EOQ
        select
          a.title as "account",
          count(i.*) as "total"
        from
          aws_s3_bucket as i,
          aws_account as a
        where
          a.account_id = i.account_id
        group by
          account
        order by count(i.*) desc
      EOQ
      type  = "column"
      width = 6
    }


    chart {
      title = "Buckets by Region"
      sql = <<-EOQ
        select
          region,
          count(i.*) as total
        from
          aws_s3_bucket as i
        group by
          region
      EOQ
      type  = "column"
      width = 6
    }
  }

}