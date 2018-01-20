From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v5] ovl: Check link ability between upperdir and workdir
Date: Sun, 21 Jan 2018 00:16:16 +0800
Message-ID: <05EBB732-97F3-446B-9CBB-32929D5324D6@icloud.com>
References: <1516464659-130410-1-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp002.me.com ([17.142.213.63]:63499 "EHLO
        pv33p36im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755643AbeATQQX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 20 Jan 2018 11:16:23 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp002.me.com by
 pv33p36im-asmtp002.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P2V002003TXV200@pv33p36im-asmtp002.me.com> for
 linux-unionfs@vger.kernel.org; Sat, 20 Jan 2018 16:16:23 +0000 (GMT)
In-reply-to: <1516464659-130410-1-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu
Cc: linux-unionfs@vger.kernel.org

Hi Miklos,


I=A1=AFve revised patch for warning issue and tested for function,

it worked as expected and there was no more warning.


=20

Thanks,
Chengguang.



> =D4=DA 2018=C4=EA1=D4=C221=C8=D5=A3=AC=C9=CF=CE=E712:10=A3=ACChengguang =
Xu <cgxu519@icloud.com> =D0=B4=B5=C0=A3=BA
>=20
> Inspired by encountering unexpected write error with
> error code -EXDEV when upperdir and workdir having
> different project quotas. The reason of the error is
> project quota asks files in it strictly inherit
> project id of it=A1=AFs own, so rename/link operations
> between those directories will fail and it may cause
> failure during copy-up/index-link operations in overlayfs.
>=20
> So if upper filesystem supports O_TMPFILE, try to check
> link ability between upperdir and workdir and if check
> fails, print a proper warning message to indicate potential
> possibility of write failure.
>=20
> The failure of the check does not directly lead to
> read-only mounting because in some use cases may only
> write to upperdir and do not modify anything in lowerdirs.
>=20
> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> ---
> Changes since v4:
> - Fix warning at the top of lookup_one_len() that=20
> triggers because of no locking of parent.
>=20
> Changes since v3:
> - Add more detail comment about motivation to changelog.
>=20
> Changes since v2:
> - Add comment about motivation.
> - Modify warning message.
>=20
> Changes since v1:
> - Check link ablity between upperdir and workdir instead of checking
> project ids of upperdir and workdir.
> - Print a warning message instead of falling to readonly mode.
>=20
> fs/overlayfs/super.c | 33 ++++++++++++++++++++++++++-------
> 1 file changed, 26 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 76440fe..82caf13 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -929,7 +929,7 @@ static int ovl_get_upper(struct ovl_fs *ofs, =
struct path *upperpath)
>=20
> static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
> {
> -	struct dentry *temp;
> +	struct dentry *uppertemp, *worktemp;
> 	int err;
>=20
> 	ofs->workdir =3D ovl_workdir_create(ofs, OVL_WORKDIR_NAME, =
false);
> @@ -953,12 +953,31 @@ static int ovl_make_workdir(struct ovl_fs *ofs, =
struct path *workpath)
> 	if (!err)
> 		pr_warn("overlayfs: upper fs needs to support =
d_type.\n");
>=20
> -	/* Check if upper/work fs supports O_TMPFILE */
> -	temp =3D ovl_do_tmpfile(ofs->workdir, S_IFREG | 0);
> -	ofs->tmpfile =3D !IS_ERR(temp);
> -	if (ofs->tmpfile)
> -		dput(temp);
> -	else
> +	/*
> +	 * Check if upper/work fs supports O_TMPFILE and if support, =
check
> +	 * link ability between upperdir and workdir, this is inspired =
by
> +	 * encountering unexpected write error when upperdir and workdir
> +	 * having different project ids.
> +	 */
> +	uppertemp =3D ovl_do_tmpfile(ofs->upper_mnt->mnt_root, S_IFREG | =
0);
> +	ofs->tmpfile =3D !IS_ERR(uppertemp);
> +	if (ofs->tmpfile) {
> +		inode_lock_nested(ofs->workdir->d_inode, =
I_MUTEX_PARENT);
> +		worktemp =3D ovl_lookup_temp(ofs->workdir);
> +		if (!IS_ERR(worktemp)) {
> +			err =3D ovl_do_link(uppertemp, =
ofs->workdir->d_inode,
> +							worktemp, true);
> +			inode_unlock(ofs->workdir->d_inode);
> +			if (err)
> +				pr_warn("overlayfs: cannot link files =
between upperdir and workdir, it may cause write error.\n");
> +			else
> +				ovl_cleanup(ofs->workdir->d_inode, =
worktemp);
> +			dput(worktemp);
> +		} else {
> +			inode_unlock(ofs->workdir->d_inode);
> +		}
> +		dput(uppertemp);
> +	} else
> 		pr_warn("overlayfs: upper fs does not support =
tmpfile.\n");
>=20
> 	/*
> --=20
> 1.8.3.1
>=20
