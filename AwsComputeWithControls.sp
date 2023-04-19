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
      title = "Services and Resources for Account EOD-Devl (663554031644)"
      sql = <<-EOQ
        select
		  split_part(arn, ':', 3) || '--' ||
		  case
			when length(split_part(arn, ':', 7)) = 0 then case
			  when POSITION('/' in split_part(arn, ':', 6)) = 0 then null
			  else split_part(split_part(arn, ':', 6), '/', 1)
			end
			else split_part(split_part(arn, ':', 6), '/', 1) --split_part(arn, ':', 6)
		  end as service_and_ResType,
		  count(*) --, arn
		from
		  aws_eo_devl.aws_tagging_resource
		group by
		  service_and_ResType
		order by
			service_and_ResType
      EOQ
      type  = "column"
      width = 6
    }
	chart {
      title = "Services and Resources for Account Sourcing Management-Devl (063483230045)"
      sql = <<-EOQ
        select
		  split_part(arn, ':', 3) || '--' ||
		  case
			when length(split_part(arn, ':', 7)) = 0 then case
			  when POSITION('/' in split_part(arn, ':', 6)) = 0 then null
			  else split_part(split_part(arn, ':', 6), '/', 1)
			end
			else split_part(split_part(arn, ':', 6), '/', 1) --split_part(arn, ':', 6)
		  end as service_and_ResType,
		  count(*) --, arn
		from
		  aws_sm_devl.aws_tagging_resource
		group by
		  service_and_ResType
		order by
			service_and_ResType
      EOQ
      type  = "column"
      width = 6
    }
    
  }

}