From: hujianyang <hujianyang@huawei.com>
Subject: Re: [PATCH] ovl: Prevent rw remount when it should be ro mount
Date: Sun, 4 Jan 2015 10:59:00 +0800
Message-ID: <54A8AC74.2060106@huawei.com>
References: <1420219609-2568-1-git-send-email-waydi1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from [119.145.14.66] ([119.145.14.66]:26896 "EHLO
	szxga03-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbbADC7v (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sat, 3 Jan 2015 21:59:51 -0500
In-Reply-To: <1420219609-2568-1-git-send-email-waydi1@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Seunghun Lee <waydi1@gmail.com>
Cc: miklos@szeredi.hu, sedat.dilek@gmail.com, richard.weinberger@gmail.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org

On 2015/1/3 1:26, Seunghun Lee wrote:
> Overlayfs should be mounted read-only when upper-fs is read-only or nonexistent.
> But now it can be remounted read-write and this can cause kernel panic.
> So we should prevent read-write remount when the above situation happens.
> 
> Signed-off-by: Seunghun Lee <waydi1@gmail.com>
> ---
>  fs/overlayfs/super.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 84f3144..8944651 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -522,10 +522,21 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>  	return 0;
>  }
>  
> +static int ovl_remount(struct super_block *sb, int *flags, char *data)
> +{
> +	struct ovl_fs *ufs = sb->s_fs_info;
> +
> +	if (!ufs->upper_mnt || (ufs->upper_mnt->mnt_sb->s_flags & MS_RDONLY))
> +		*flags |= MS_RDONLY;
> +
> +	return 0;
> +}
> +
>  static const struct super_operations ovl_super_operations = {
>  	.put_super	= ovl_put_super,
>  	.statfs		= ovl_statfs,
>  	.show_options	= ovl_show_options,
> +	.remount_fs	= ovl_remount,
>  };
>  
>  enum {
> 

I think this exporting of .remount_fs may allow people in userspace
have the ability to remount a filesystem with a new set of mounting
options. Your new adding function do nothing with the passing in
parameters.

I'm not sure if it could be competent for remount case.

Add Cc linux-unionfs.

