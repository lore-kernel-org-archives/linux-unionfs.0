From: Seunghun Lee <waydi1@gmail.com>
Subject: Re: [PATCH] ovl: Fix condition check for workdir
Date: Sat, 10 Jan 2015 03:11:06 +0900
Message-ID: <54B019BA.6050500@gmail.com>
References: <1420720880-28459-1-git-send-email-waydi1@gmail.com> <54AF3FA0.8010808@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54AF3FA0.8010808@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: hujianyang <hujianyang@huawei.com>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org


On 01/09/2015 11:40 AM, hujianyang wrote:
> On 2015/1/8 20:41, Seunghun Lee wrote:
>> When file system is mounted read-only workdir is not needed.
>>
>> Signed-off-by: Seunghun Lee <waydi1@gmail.com>
>> ---
>>  fs/overlayfs/super.c | 35 +++++++++++++++++++++++------------
>>  1 file changed, 23 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index 84f3144..4e50617 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -30,6 +30,7 @@ struct ovl_config {
>>  	char *lowerdir;
>>  	char *upperdir;
>>  	char *workdir;
>> +	bool is_rw;
>>  };
>>  
>>  /* private information held for overlayfs's superblock */
>> @@ -515,10 +516,11 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>>  	struct ovl_fs *ufs = sb->s_fs_info;
>>  
>>  	seq_printf(m, ",lowerdir=%s", ufs->config.lowerdir);
>> -	if (ufs->config.upperdir) {
>> +	if (ufs->config.upperdir)
>>  		seq_printf(m, ",upperdir=%s", ufs->config.upperdir);
>> +	if (ufs->config.is_rw)
>>  		seq_printf(m, ",workdir=%s", ufs->config.workdir);
>> -	}
>> +
>>  	return 0;
>>  }
>>  
>> @@ -822,16 +824,27 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>>  
>>  	sb->s_stack_depth = 0;
>>  	if (ufs->config.upperdir) {
>> -		/* FIXME: workdir is not needed for a R/O mount */
>> +		err = ovl_mount_dir(ufs->config.upperdir, &upperpath);
>> +		if (err)
>> +			goto out_free_config;
>> +
>> +		sb->s_stack_depth = upperpath.mnt->mnt_sb->s_stack_depth;
>> +	}
>> +
>> +	/* If the upper fs is r/o or nonexistent, we mark overlayfs r/o too */
>> +	if (!upperpath.mnt || (upperpath.mnt->mnt_sb->s_flags & MS_RDONLY)) {
>> +		ufs->config.is_rw = false;
>> +		sb->s_flags |= MS_RDONLY;
>> +	} else {
>> +		ufs->config.is_rw = true;
>> +	}
> Hi Seunghun,
>
> A partition can be mounted with ro flag. I think workdir is not
> needed in this way either.
Hi Hu,

I agree with you, workdir is not needed when filesystem is mounted with ro flag.
After mount,  however, it can be remounted with rw flag.

Thanks.
