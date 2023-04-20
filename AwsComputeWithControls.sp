dashboard "deere_scs_aws_accounts_dashboard" {

  title = "Deere SCS AWS Accounts Dashboard"


  container {
    title = "Analysis"

	chart {
      title = "Services and Resources for Account Sourcing Management-Devl (063483230045)"
      sql = <<-EOQ
        select
		  split_part(arn, ':', 3) || COALESCE('--' ||
		  case
			when length(split_part(arn, ':', 7)) = 0 then case
			  when POSITION('/' in split_part(arn, ':', 6)) = 0 then null
			  else split_part(split_part(arn, ':', 6), '/', 1)
			end
			else split_part(split_part(arn, ':', 6), '/', 1)
		  end, '') as service_and_ResType,
		  count(*)
		from
		  aws_sm_devl.aws_tagging_resource
		group by
		  service_and_ResType
		order by
			service_and_ResType
      EOQ
      type  = "column"
    }
  }
  
    container {
		title = "Analysis"

		chart {
		  title = "Services and Resources for Account EOD-Devl (663554031644)"
		  sql = <<-EOQ
			select
			  split_part(arn, ':', 3) || COALESCE('--' ||
			  case
				when length(split_part(arn, ':', 7)) = 0 then case
				  when POSITION('/' in split_part(arn, ':', 6)) = 0 then null
				  else split_part(split_part(arn, ':', 6), '/', 1)
				end
				else split_part(split_part(arn, ':', 6), '/', 1)
			  end, '') as service_and_ResType,
			  count(*)
			from
			  aws_eo_devl.aws_tagging_resource
			group by
			  service_and_ResType
			order by
				service_and_ResType
		  EOQ
		  type  = "bar"
		}
  }

}