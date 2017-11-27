From: cgxu <cgxu@mykernel.net>
Subject: Re: [PATCH] ovl: Check project quota ids during ovl_fill_super()
Date: Mon, 27 Nov 2017 23:36:20 +0800
Message-ID: <965DEAEF-6BC2-453D-8A11-1D880F6E3484@mykernel.net>
References: <1510588761-82660-1-git-send-email-cgxu@mykernel.net>
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Content-Type: text/plain;
        charset=gb2312
Content-Transfer-Encoding: 8BIT
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from smtpbguseast2.qq.com ([54.204.34.130]:42430 "EHLO
        smtpbguseast2.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752597AbdK0Pg2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 27 Nov 2017 10:36:28 -0500
In-Reply-To: <1510588761-82660-1-git-send-email-cgxu@mykernel.net>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, Suyue <suyue@meili-inc.com>

Hi Miklos

Any suggestion for the patch?


Best Regards,
Chengguang



> 在 2017年11月13日，下午11:59，Chengguang Xu <cgxu@mykernel.net> 写道：
> 
> When upperdir has project quota and has different project id with workdir,
> write may fail with error message "Invalid cross-device link" although mounted on r/w mode.
> This patch checks project quota information of upperdir/workdir during ovl_fill_super(),
> and if different mount on r/o mode. It doesn’t check detail inherit flag because
> the implementations are different in specific filesystems.
> 
> Signed-off-by: Chengguang Xu <cgxu@mykernel.net>
> Signed-off-by: Suyue <suyue@meili-inc.com>
> ---
> fs/overlayfs/super.c | 32 +++++++++++++++++++++++++++++++-
> 1 file changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index f5738e9..7b64d5c 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -276,10 +276,34 @@ static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
> 	return err;
> }
> 
> +static bool ovl_check_project_quota_ok(struct ovl_fs *ufs)
> +{
> +	struct super_block *sb;
> +	kprojid_t upperdir_projid = KPROJIDT_INIT(-1);
> +	kprojid_t workdir_projid = KPROJIDT_INIT(-1);
> +
> +	if (!ufs->upper_mnt || !ufs->workdir)
> +		return true;
> +
> +	sb = ufs->upper_mnt->mnt_sb;
> +	if (!(sb->s_quota_types & QTYPE_MASK_PRJ))
> +		return true;
> +
> +	if (sb->dq_op && sb->dq_op->get_projid) {
> +		sb->dq_op->get_projid(ufs->upper_mnt->mnt_root->d_inode, &upperdir_projid);
> +		sb->dq_op->get_projid(ufs->workdir->d_inode, &workdir_projid);
> +		if (projid_valid(upperdir_projid) && projid_valid(workdir_projid))
> +			if (!projid_eq(upperdir_projid, workdir_projid))
> +				return false;
> +	}
> +
> +	return true;
> +}
> +
> /* Will this overlay be forced to mount/remount ro? */
> static bool ovl_force_readonly(struct ovl_fs *ufs)
> {
> -	return (!ufs->upper_mnt || !ufs->workdir);
> +	return (!ufs->upper_mnt || !ufs->workdir || !ovl_check_project_quota_ok(ufs));
> }
> 
> /**
> @@ -1060,6 +1084,12 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
> 	else if (ufs->upper_mnt->mnt_sb != ufs->same_sb)
> 		ufs->same_sb = NULL;
> 
> +	/* if upperdir and workdir have different project quota ids, we mark overlayfs r/o too */
> +	if (!ovl_check_project_quota_ok(ufs)) {
> +		pr_warn("overlayfs: mounting read-only because upperdir and workdir have different project quota ids.\n");
> +		sb->s_flags |= MS_RDONLY;
> +	}
> +
> 	if (!(ovl_force_readonly(ufs)) && ufs->config.index) {
> 		/* Verify lower root is upper root origin */
> 		err = ovl_verify_origin(upperpath.dentry, ufs->lower_mnt[0],
> -- 
> 1.8.3.1
> 
> 
