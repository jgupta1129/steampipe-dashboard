query "get_aws_account_services_and_their_count" {
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
			  aws_tagging_resource
			where
				account_id = $1
			group by
			  service_and_ResType
			order by
				service_and_ResType
	EOQ
	
	param "account_id" {}
}

dashboard "deere_scs_aws_accounts_dashboard" {

  title = "Deere SCS AWS Accounts Dashboard"

  container {
    title = "Services and Resources for Account Sourcing Management-Devl (063483230045)"

	chart {
      title = "Services and Resources for Account Sourcing Management-Devl (063483230045)"
      type  = "pie"
	  width = 6
	  query = query.get_aws_account_services_and_their_count
      args  = {
        "account_id" = "063483230045"
      }
    }
	table {
      width = 6
      query = query.get_aws_account_services_and_their_count
      args  = {
        "account_id" = "063483230045"
      }
    }
  }
  
    container {
		title = "Services and Resources for Account EOD-Devl (663554031644)"

		chart {
		  title = "Services and Resources for Account Sourcing Management-Devl (063483230045)"
		  type  = "pie"
		  width = 6
		  query = query.get_aws_account_services_and_their_count
		  args  = {
			"account_id" = "663554031644"
		  }
		}
		table {
		  width = 6
		  query = query.get_aws_account_services_and_their_count
		  args  = {
			"account_id" = "663554031644"
		  }
		}
  }

}