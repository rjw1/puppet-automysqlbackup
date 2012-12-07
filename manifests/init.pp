# READ FIRST
#
# Before using this module, you need to consult the automysqlbackup
# developer documentation in order to comprehend what each option
# performs. It is included with this module and is certainly worth
# getting familiar with. I have kept the same variable names as the
# author of the script to make it easier to lookup the documentation.
# Basically, add CONFIG_ to the variable in question and regex search
# the documentation to find the meaning. No interpretation from me.
# 
# Chain of supercedence:
#
# automysqlbackup.conf overwrites script values
#
# Anything with an empty string implies that you are conceding to
# the default value in automysqlbackup.conf. Anything not specified
# in automysqlbackup.conf accepts the scripts builtin, default value.
# The option will simply be excluded from the myserver.conf file.
# 
# For example:
# 
# 	$mysql_dump_socket = ""
#
# Results in...
# 
#	#CONFIG_mysql_dump_socket=''
#
# in the myserver.conf file.
#
# END RAMBLING

class automysqlbackup (
	$mysql_dump_username = "",
	$mysql_dump_password = "",
	$mysql_dump_host = "",
	$mysql_dump_port = 3306,
	$backup_dir = "",
	$multicore = "",
	$multicore_threads = "",
	$db_names = [],
	$db_month_names = [],
	$db_exclude = [],
	$table_exclude = [],
	$do_monthly = "01",
	$do_weekly = "5",
	$rotation_daily = "6",
	$rotation_weekly = "35",
	$rotation_monthly = "150",
	$mysql_dump_commcomp = "",
	$mysql_dump_usessl = "",
	$mysql_dump_socket = "",
	$mysql_dump_max_allowed_packet = "",
	$mysql_dump_buffer_size = "",
	$mysql_dump_single_transaction = "",
	$mysql_dump_master_data = "",
	$mysql_dump_full_schema = "",
	$mysql_dump_dbstatus = "",
	$mysql_dump_create_database = "",
	$mysql_dump_use_separate_dirs = "",
	$mysql_dump_compression = "gzip",
	$mysql_dump_latest = "",
	$mysql_dump_latest_clean_filenames = "",
	$mysql_dump_differential = "",
	$mailcontent = "",
	$mail_maxattsize = "",
	$mail_splitandtar = "",
	$mail_use_uuencoded_attachments = "",
	$mail_address = "",
	$encrypt = "",
	$encrypt_password = "",
	$backup_local_files = [],
	$prebackup = "",
	$postbackup = "",
	$umask = "",
	$dryrun = "",
) inherits automysqlbackup::params {

	file { $etc_dir:
		ensure	=> directory,
		owner	=> "root",
		group	=> "root",
		mode	=> 0750,
	}

	file { "$etc_dir/automysqlbackup.conf.example":
		ensure	=> file,
		owner	=> "root",
		group	=> "root",
		mode	=> 0660,
		source	=> "puppet:///modules/automysqlbackup/automysqlbackup.conf",
	}
	
	file { "$etc_dir/README":
		ensure	=> file,
		source	=> "puppet:///modules/automysqlbackup/README",
	}
	
	file { "$etc_dir/LICENSE":
		ensure	=> file,
		source	=> "puppet:///modules/automysqlbackup/LICENSE",
	}

	file { "$bin_dir/automysqlbackup":
		ensure	=> file,
		owner	=> "root",
		group	=> "root",
		mode	=> 0755,
		source	=> "puppet:///modules/automysqlbackup/automysqlbackup",
	}

	# Creating a hash, really could probably avoid doing this, but wanted to try
	$template_string_options = {
		"mysql_dump_username" => $mysql_dump_username,
    	"mysql_dump_password" => $mysql_dump_password,
    	"mysql_dump_host" => $mysql_dump_host,
    	"mysql_dump_port" => $mysql_dump_port,
    	"backup_dir" => $backup_dir,
    	"multicore" => $multicore,
    	"multicore_threads" => $multicore_threads,
    	"do_monthly" => $do_monthly,
    	"do_weekly" => $do_weekly,
    	"rotation_daily" => $rotation_daily,
    	"rotation_weekly" => $rotation_weekly,
    	"rotation_monthly" => $rotation_monthly,
    	"mysql_dump_commcomp" => $mysql_dump_commcomp,
    	"mysql_dump_usessl" => $mysql_dump_usessl,
    	"mysql_dump_socket" => $mysql_dump_socket,
    	"mysql_dump_max_allowed_packet" => $mysql_dump_max_allowed_packet,
    	"mysql_dump_buffer_size" => $mysql_dump_buffer_size,
    	"mysql_dump_single_transaction" => $mysql_dump_single_transaction,
    	"mysql_dump_master_data" => $mysql_dump_master_data,
    	"mysql_dump_full_schema" => $mysql_dump_full_schema,
    	"mysql_dump_dbstatus" => $mysql_dump_dbstatus,
    	"mysql_dump_create_database" => $mysql_dump_create_database,
    	"mysql_dump_use_separate_dirs" => $mysql_dump_use_separate_dirs,
    	"mysql_dump_compression" => $mysql_dump_compression,
    	"mysql_dump_latest" => $mysql_dump_latest,
    	"mysql_dump_latest_clean_filenames" => $mysql_dump_latest_clean_filenames,
		"mysql_dump_differential" => $mysql_dump_differential,
    	"mailcontent" => $mailcontent,
    	"mail_maxattsize" => $mail_maxattsize,
    	"mail_splitandtar" => $mail_splitandtar,
    	"mail_use_uuencoded_attachments" => $mail_use_uuencoded_attachments,
    	"mail_address" => $mail_address,
    	"encrypt" => $encrypt,
    	"encrypt_password" => $encrypt_password,
    	"prebackup" => $prebackup,
    	"postbackup" => $postbackup,
    	"umask" => $umask,
    	"dryrun" => $dryrun
	}
	$template_array_options = {
		"db_names" => $db_names,
    	"db_month_names" => $db_month_names,
    	"db_exclude" => $db_exclude,
    	"table_exclude" => $table_exclude,
    	"backup_local_files" => $backup_local_files,
	}

	# last but not least, create the automysqlbackup.conf
	file { "$etc_dir/automysqlbackup.conf":
		ensure	=> file,
		content	=> template('automysqlbackup/myserver.conf.erb'),
		owner	=> "root",
		group	=> "root",
		mode	=> 0650,
	}

}