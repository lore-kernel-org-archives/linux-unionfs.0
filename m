Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E763AE705
	for <linux-unionfs@vger.kernel.org>; Fri, 20 Mar 2026 12:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774010051; cv=pass; b=nZf0NeWnNXnWS8P92B7JW+jAHQ9zj+mPD4sm14qizeyv4FX5v200bnugPxiVOE1sYR1lMJ/XKvPvG5g/CfDrIMjCOrGpXJuMuR09fBc59CXsjDLQABCGLwoD3U69unZcE86QXr/dQyZceimP/i1SIUWPthvYZ3Kw3v0LmFtRKWc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774010051; c=relaxed/simple;
	bh=XLaoLqDtanoExFeuxa0YKat22sa9hJ9P+EPmS3WvgL8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A5TRw7466CfbUfEKW4f2eRekMi3dHUHboEU6ZqsBtaX8CaErfni9X63JBpASwU2gGvL/kErHndmWQ12VV5muapHfoNyDy/gQhZChz4O7bZPczSOZqMmqB4JCiIyvMKQmJT60WtUhYW4vC58nOa2Hh0p5NsEf4MhT5prNOmJVTgI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kgp7Fjyb; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kgp7Fjyb"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-661cfb9f3aaso2173265a12.2
        for <linux-unionfs@vger.kernel.org>; Fri, 20 Mar 2026 05:34:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774010048; cv=none;
        d=google.com; s=arc-20240605;
        b=O+H63CaZ1po3/PO7mjTKTE3ddMnwpR9P75pc5gOSXLpBTmfarCUe8XBfrGm27Au1HR
         WhrRdPLjQbUBkk2tvsD/uvHhnGFUazPt0KIKD2xs8Ka/qhqRqQy8vjIozI00tE85dk9J
         +7oGr3PtoPWKhYICqYKoIg87FuKuaGyr5/0pYPpOxJpYIQEI6BLw5+uV+BNjrzQ6QECb
         jn//nckFsG4bqTv5TwMbfbE2jVj4jbFHF7Vwf5GX7vQx/s2s/RqMXXxrU+yxp4Woi0eQ
         s7qCkxIcMys0zGu5SfTIgN9MUh2VHba7FPvLi7PiP62gMXeVTbzUvg/V/L6Fow+4osKj
         YFWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3K8SJZxerjn7Jv5y3gL2e2Dax0E0bqqyMdQ4wn7A4ls=;
        fh=8L6dE+mAK7bUO//KofuRg1dhuxTJYS3zIivD77gu6Ms=;
        b=X/wI6FCfXU6QL12VRHbvYvPiASGgCRHwg2OQAhcF7oYG313oEFHLzlzddzXvJqseCB
         EZdCI7hzmYJKV384n8plzpqhDExJusBo276KGfat0SPzV9jiIl07vHHzimOYD5VfLzvP
         bXygzQI4tm04KGk76UT60MPM3W2IRBfs0J+glWYSyY6tGbv2Q4ZcKpHfwB0ZDrsJty8C
         /MI1jvoQBYyS5TdE8Vu1+btTNJaiv69iAKubiOOdte9L7/oKBnksihHEDdds+T1dKEGH
         6o+Njjz4YPzkqDXgLsMoXAdWODwXarA8j9KXIYo0+2SSNRtsOVZlw+xNnLH60Hk7uElt
         Qv5Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774010048; x=1774614848; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3K8SJZxerjn7Jv5y3gL2e2Dax0E0bqqyMdQ4wn7A4ls=;
        b=Kgp7FjybKjpTHrOOpyYircgze9ZH96xU05e3De1KUvI/TdyyUVIjPMKzxB7DsAzuI8
         YXpHJMZh3qeeCFYhZDlOqSRjecMsxdF1T3zRuK7ZcjwNqOO6OEEjiBwnuAv8L+YWOblK
         1mAHi1SSgNSqMaUWhuRtsy5vCy0tuY0Ubt/Onbtdqp2a1WTUE+hBxHsqUZHCNDncCf+H
         KT5XCyx9kSOQeR4x/A/WxegzfdXHRW3AZnWO1068MMNXWbPOtOzegXsjSJQj6NmArNSY
         UIheDaHBuuXhcbacJzxUev/6V5ANMlV0dmuV49mdBKzjL4n3kN/4HF/FcPSkmSem49Sb
         HpdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774010048; x=1774614848;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3K8SJZxerjn7Jv5y3gL2e2Dax0E0bqqyMdQ4wn7A4ls=;
        b=SQi+rAwezLZkGUOK2ROeGoa/IYfeS/3K6V54MqJxbAjc1/7Cc5byzKgxHOZaWGboYb
         PloASldqzRamvwodAgwVuQ9PVD5SvR6y4BhyEiJSz9MvRHadoNZ0Hb9Hk7FbC+YY2SV9
         q4zc8YhIbadVeKueilJeNl0vLbmOXxCMs4xCm0IXSzyWhs738MK3jFjIb57wBtuFX1/i
         mcTSM9fet0QQWcphq8FgW7aZHtoiGXY8WXLKjqmHgzx83RqpquZC9TvRsbipL8+ki20p
         qtao5EdAMk3qH0/GA8ysMyS/0qDI2tHrMqZb0wvrZDSOVVyUdtYJY51V93H4FmxDx2cM
         sO6g==
X-Forwarded-Encrypted: i=1; AJvYcCU2qhkdAU5XEyWoEqI9zsvRnXrxfzfU7Pfll5+KcUMXJsTq/nigPuuPLQNKAmuTCZY2/KMBsx7RQwi+2IIo@vger.kernel.org
X-Gm-Message-State: AOJu0YyOSeekd6zFCTNHizvNNC/4jdSqT5cy7S2w/fiCBj/99jnExClf
	gNzzM9kwCXBT5ZAi0oPUvCpRY0QrgaGOLqLYCSNpFXlyjKEpOf/ig/j9cNzwosWm3B8I9YhCnTe
	zQ+dFaj3VHOj0H8e34Wh1ZwZTmNTit9U=
X-Gm-Gg: ATEYQzzYxaiufXuwoAfqIYWE5PqDTqBwZUpppOlEReecprxLlj6D3P1jsUAHoPPnNtO
	GFWMOpBLsllPs90lQ1XZwPj4iN9H5o0+qLDoqUckMi1RktNNz7m8yK2vPo8JSTm6/SgBJY1Bpgu
	eLokTbCFiKAQ6JZ1VsqJpVeIvjtwUZR8uuVKr3TSPtsZ8u4nLVkhd8HlW+ncQK1Ri2VSUwmb34D
	tk0Da9VCDOH/5X8tp1ATWf54ZEX1I6W7utvgc+tKWfPsBg5ELJHYNQGSagPxKPV+obpaaoKTXwT
	NC2/7CwP8IBB8awdAuyY2oV9QBi9PWh7NlpyaZNV0g==
X-Received: by 2002:a17:907:1604:b0:b97:fe6d:2e4a with SMTP id
 a640c23a62f3a-b982f0a95fbmr232459366b.10.1774010047484; Fri, 20 Mar 2026
 05:34:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260320122918.1726043-1-amir73il@gmail.com>
In-Reply-To: <20260320122918.1726043-1-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Mar 2026 13:33:55 +0100
X-Gm-Features: AaiRm50yxSl-GpcT9aAyYPhbaKvhkBm3eNaH28AUrvLwA3Ejcz4sEkf5zVBNIlU
Message-ID: <CAOQ4uxhsTG0mQCeiAw-8qGqjQo9HjRYfdRYQzPGXSgKb4udOiw@mail.gmail.com>
Subject: Re: [PATCH v2] fs: allow backing file code to open an O_PATH file
 with negative dentry
To: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, 
	Paul Moore <paul@paul-moore.com>, Gao Xiang <xiang@kernel.org>, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, 
	syzbot+f34aab278bf5d664e2be@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 20, 2026 at 1:29=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> The fields f_mapping and f_wb_err are irrelevant for the O_PATH file
> in backing_file_user_path_file().
>
> Create a dedicated helper kernel_path_file_open(), which skips all the
> generic code in do_dentry_open() and does only the essentials, so that
> the internal O_PATH file could be opened with a negative dentry.
>
> This is needed for backing_tmpfile_open() to open a backing O_PATH
> tmpfile before instantiating the dentry.
>
> The callers of backing_tmpfile_open() are responsible for calling
> backing_tmpfile_finish() after making the path positive.
>
> Reported-by: syzbot+f34aab278bf5d664e2be@syzkaller.appspotmail.com
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Christian,
>
> This patch fixes the syzbot report [1] that the
> backing_file_user_path_file() patch [2] introduces.

Sorry, forgot to mention that this patch applies on top of [2]
so the vfs CI is likely to fail to apply it.

The previous patch + fix are also available on my github
https://github.com/amir73il/linux/commits/user_path_file/

Thanks,
Amir.

>
> Following your feedback on v1, this version makes an effort to stay
> out of the way of main vfs execution paths and restrict the changes
> to backing_file users.
>
> This still introduced a temporary state of an O_PATH file with negative
> path, but only for a short time and only for backing_file users and
> ones that use backing_tmpfile_open() (i.e. only overlayfs), so the
> risk is minimal.
>
> WDYT?
>
> Thanks,
> Amir.
>
> Changes since v1:
> - Create helper for internal O_PATH open with negative path
> - Create backing_tmpfile_finish() API to fixup the negative path
>
> [1] https://syzkaller.appspot.com/bug?extid=3Df34aab278bf5d664e2be
> [2] https://lore.kernel.org/linux-fsdevel/20260318131258.1457101-1-amir73=
il@gmail.com/
>
>  fs/backing-file.c            |  6 ++++++
>  fs/file_table.c              | 14 ++++++++++++--
>  fs/internal.h                |  7 +++++++
>  fs/open.c                    | 34 ++++++++++++++++++++++++++++++----
>  fs/overlayfs/dir.c           |  2 ++
>  include/linux/backing-file.h |  1 +
>  6 files changed, 58 insertions(+), 6 deletions(-)
>
> diff --git a/fs/backing-file.c b/fs/backing-file.c
> index d0a64c2103907..3357d624eac96 100644
> --- a/fs/backing-file.c
> +++ b/fs/backing-file.c
> @@ -80,6 +80,12 @@ struct file *backing_tmpfile_open(const struct path *u=
ser_path,
>  }
>  EXPORT_SYMBOL(backing_tmpfile_open);
>
> +void backing_tmpfile_finish(struct file *file)
> +{
> +       backing_file_set_user_path_inode(file);
> +}
> +EXPORT_SYMBOL_GPL(backing_tmpfile_finish);
> +
>  struct backing_aio {
>         struct kiocb iocb;
>         refcount_t ref;
> diff --git a/fs/file_table.c b/fs/file_table.c
> index e8b4eb2bbff85..a4d1064d50896 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -69,11 +69,21 @@ EXPORT_SYMBOL_GPL(backing_file_user_path_file);
>
>  int backing_file_open_user_path(struct file *f, const struct path *path)
>  {
> -       /* open an O_PATH file to reference the user path - should not fa=
il */
> -       return WARN_ON(vfs_open(path, &backing_file(f)->user_path_file));
> +       if (WARN_ON(!(f->f_mode & FMODE_BACKING)))
> +               return -EIO;
> +       kernel_path_file_open(&backing_file(f)->user_path_file, path);
> +       return 0;
>  }
>  EXPORT_SYMBOL_GPL(backing_file_open_user_path);
>
> +void backing_file_set_user_path_inode(struct file *f)
> +{
> +       if (WARN_ON(!(f->f_mode & FMODE_BACKING)))
> +               return;
> +       file_set_d_inode(&backing_file(f)->user_path_file);
> +}
> +EXPORT_SYMBOL_GPL(backing_file_set_user_path_inode);
> +
>  static void destroy_file(struct file *f)
>  {
>         security_file_free(f);
> diff --git a/fs/internal.h b/fs/internal.h
> index 7c44a58627ba3..4a9e5e00678d9 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -109,6 +109,13 @@ struct file *alloc_empty_file_noaccount(int flags, c=
onst struct cred *cred);
>  struct file *alloc_empty_backing_file(int flags, const struct cred *cred=
,
>                                       const struct cred *user_cred);
>  int backing_file_open_user_path(struct file *f, const struct path *path)=
;
> +void backing_file_set_user_path_inode(struct file *f);
> +void kernel_path_file_open(struct file *f, const struct path *path);
> +
> +static inline void file_set_d_inode(struct file *f)
> +{
> +       f->f_inode =3D d_inode(f->f_path.dentry);
> +}
>
>  static inline void file_put_write_access(struct file *file)
>  {
> diff --git a/fs/open.c b/fs/open.c
> index 91f1139591abe..a7b3b04cd9ae7 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -884,10 +884,38 @@ static inline int file_get_write_access(struct file=
 *f)
>         return error;
>  }
>
> +static const struct file_operations empty_fops =3D {};
> +
> +static void do_path_file_open(struct file *f)
> +{
> +       f->f_mode =3D FMODE_PATH | FMODE_OPENED;
> +       file_set_fsnotify_mode(f, FMODE_NONOTIFY);
> +       f->f_op =3D &empty_fops;
> +}
> +
> +/**
> + * kernel_path_file_open - open an O_PATH file for kernel internal use
> + * @f:         pre-allocated file with f_flags and f_cred initialized
> + * @path:      path to reference (may have a negative dentry)
> + *
> + * Open a minimal O_PATH file that only references a path.
> + * Unlike vfs_open(), this does not require a positive dentry and does n=
ot
> + * set up f_mapping and other fields not needed for O_PATH.
> + * If path is negative at the time of this call, the caller is responsib=
le for
> + * callingn backing_file_set_user_path_inode() after making the path pos=
itive.
> +
> + */
> +void kernel_path_file_open(struct file *f, const struct path *path)
> +{
> +       f->__f_path =3D *path;
> +       path_get(&f->f_path);
> +       file_set_d_inode(f);
> +       do_path_file_open(f);
> +}
> +
>  static int do_dentry_open(struct file *f,
>                           int (*open)(struct inode *, struct file *))
>  {
> -       static const struct file_operations empty_fops =3D {};
>         struct inode *inode =3D f->f_path.dentry->d_inode;
>         int error;
>
> @@ -898,9 +926,7 @@ static int do_dentry_open(struct file *f,
>         f->f_sb_err =3D file_sample_sb_err(f);
>
>         if (unlikely(f->f_flags & O_PATH)) {
> -               f->f_mode =3D FMODE_PATH | FMODE_OPENED;
> -               file_set_fsnotify_mode(f, FMODE_NONOTIFY);
> -               f->f_op =3D &empty_fops;
> +               do_path_file_open(f);
>                 return 0;
>         }
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 5fd32ccc134d2..4010c87e10196 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -1408,6 +1408,8 @@ static int ovl_create_tmpfile(struct file *file, st=
ruct dentry *dentry,
>                         err =3D ovl_instantiate(dentry, inode, newdentry,=
 false, file);
>                         if (!err) {
>                                 file->private_data =3D of;
> +                               /* user_path_file was opened with a negat=
ive path */
> +                               backing_tmpfile_finish(realfile);
>                         } else {
>                                 dput(newdentry);
>                                 ovl_file_free(of);
> diff --git a/include/linux/backing-file.h b/include/linux/backing-file.h
> index 8afba93f3ce07..52ac51ada6ff9 100644
> --- a/include/linux/backing-file.h
> +++ b/include/linux/backing-file.h
> @@ -47,6 +47,7 @@ struct file *backing_tmpfile_open(const struct path *us=
er_path,
>                                   const struct cred *user_cred, int flags=
,
>                                   const struct path *real_parentpath,
>                                   umode_t mode, const struct cred *cred);
> +void backing_tmpfile_finish(struct file *file);
>  ssize_t backing_file_read_iter(struct file *file, struct iov_iter *iter,
>                                struct kiocb *iocb, int flags,
>                                struct backing_file_ctx *ctx);
> --
> 2.53.0
>
