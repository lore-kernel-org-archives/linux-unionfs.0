From: "A. Wan" <jm@mokwan.com>
Subject: Re: [PATCH 3/3] ovl: upper fs should not be R/O
Date: Thu, 15 Jan 2015 09:09:53 -0800
Message-ID: <da4e10d37524bff8ff274a6dbf6170cb.squirrel@www.anemaid>
References: <54B74D70.3000205@huawei.com> <54B74E39.8080405@huawei.com>
    <8579CCC5-FF7A-42D8-8E5A-381A98DC7CAD@gmail.com>
Reply-To: jm@mokwan.com
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.webnames.ca ([65.39.140.87]:37134 "EHLO mx2.webnames.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbbAOR3Q (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 15 Jan 2015 12:29:16 -0500
Received: from anemaid.no-ip.org (d162-156-172-55.bchsia.telus.net [162.156.172.55]) by mx2.webnames.ca with ESMTP id SdJ6ftHAVex1WNfG for <linux-unionfs@vger.kernel.org>; Thu, 15 Jan 2015 09:10:11 -0800 (PST)
In-Reply-To: <8579CCC5-FF7A-42D8-8E5A-381A98DC7CAD@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

Just one question.  If each r/o layer does not require a workdir, why
would a stack of r/o layers require one - and hence the requirement that
the top layer must be r/w?

Does it has to do with why workdir was introduced in the first place? 
Sorry but I couldn't find information about why workdir was introduced.  I
suppose it was to support some functions that older versions can't.

Alex

On Thu, January 15, 2015 12:20 am, Seunghun Lee wrote:
> On January 15, 2015 2:20:57 PM GMT+09:00, hujianyang
> <hujianyang@huawei.com> wrote:
>>After importing multi-lower layer support, users could mount a r/o
>>partition as the left most lowerdir instead of using it as upperdir.
>>And a r/o upperdir may cause an error like
>>
>>	overlayfs: failed to create directory ./workdir/work
>>
>>during mount.
>>
>>This patch check the *s_flags* of upper fs and return an error if
>>it is a r/o partition. The checking of *upper_mnt->mnt_sb->s_flags*
>>can be removed now.
>>
>>This patch also remove
>>
>>	/* FIXME: workdir is not needed for a R/O mount */
>>
>>from ovl_fill_super() because:
>>
>>1) for upper fs r/o case
>>Setting a r/o partition as upper is prevented, no need to care about
>>workdir in this case.
>>
>>2) for "mount overlay -o ro" with a r/w upper fs case
>>Users could remount overlayfs to r/w in this case, so workdir should
>>not be omitted.
>>
>>Signed-off-by: hujianyang <hujianyang@huawei.com>
>>---
>> fs/overlayfs/super.c |   24 +++++++++++++++++++-----
>> 1 files changed, 19 insertions(+), 5 deletions(-)
>>
>>diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>>index edbb3eb..0e7a477 100644
>>--- a/fs/overlayfs/super.c
>>+++ b/fs/overlayfs/super.c
>>@@ -529,8 +529,7 @@ static int ovl_remount(struct super_block *sb, int
>>*flags, char *data)
>> {
>> 	struct ovl_fs *ufs = sb->s_fs_info;
>>
>>-	if (!(*flags & MS_RDONLY) &&
>>-	    (!ufs->upper_mnt || (ufs->upper_mnt->mnt_sb->s_flags &
>>MS_RDONLY)))
>>+	if (!(*flags & MS_RDONLY) && (!ufs->upper_mnt))
>> 		return -EROFS;
>>
>> 	return 0;
>>@@ -619,6 +618,15 @@ static int ovl_parse_opt(char *opt, struct
>>ovl_config *config)
>> 			return -EINVAL;
>> 		}
>> 	}
>>+
>>+	/* Workdir is useless in non-upper mount */
>>+	if (!config->upperdir && config->workdir) {
>>+		pr_info("overlayfs: option \"workdir=%s\" is useless in a non-upper
>>mount, ignore\n",
>>+			config->workdir);
>>+		kfree(config->workdir);
>>+		config->workdir = NULL;
>>+	}
>>+
>> 	return 0;
>> }
>>
>>@@ -838,7 +846,6 @@ static int ovl_fill_super(struct super_block *sb,
>>void *data, int silent)
>>
>> 	sb->s_stack_depth = 0;
>> 	if (ufs->config.upperdir) {
>>-		/* FIXME: workdir is not needed for a R/O mount */
>> 		if (!ufs->config.workdir) {
>> 			pr_err("overlayfs: missing 'workdir'\n");
>> 			goto out_free_config;
>>@@ -848,6 +855,13 @@ static int ovl_fill_super(struct super_block *sb,
>>void *data, int silent)
>> 		if (err)
>> 			goto out_free_config;
>>
>>+		/* Upper fs should not be r/o */
>>+		if (upperpath.mnt->mnt_sb->s_flags & MS_RDONLY) {
>>+			pr_err("overlayfs: upper fs is r/o, try multi-lower layers
>>mount\n");
>>+			err = -EINVAL;
>>+			goto out_put_upperpath;
>>+		}
>>+
>> 		err = ovl_mount_dir(ufs->config.workdir, &workpath);
>> 		if (err)
>> 			goto out_put_upperpath;
>>@@ -939,8 +953,8 @@ static int ovl_fill_super(struct super_block *sb,
>>void *data, int silent)
>> 		ufs->numlower++;
>> 	}
>>
>>-	/* If the upper fs is r/o or nonexistent, we mark overlayfs r/o too
>>*/
>>-	if (!ufs->upper_mnt || (ufs->upper_mnt->mnt_sb->s_flags & MS_RDONLY))
>>+	/* If the upper fs is nonexistent, we mark overlayfs r/o too */
>>+	if (!ufs->upper_mnt)
>> 		sb->s_flags |= MS_RDONLY;
>>
>> 	sb->s_d_op = &ovl_dentry_operations;
>
> It works fine to me.
> And I think it is better than my implementation : )
>
> Thanks.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>




