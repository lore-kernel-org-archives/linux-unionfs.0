Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F6537996C
	for <linux-unionfs@vger.kernel.org>; Sun,  3 May 2026 20:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777840663; cv=pass; b=FmFRbsqCh25oII4bVsUSr+cqGB0MjlzpwYOmUzUVqgXFnjxHjEhWUcvessTqjqT7lqXFq2JX3LRxCe3nrV7Bf0JpyXxWv5EQ+1g1jSkf4zeeMZDI2XsXGjVnBlX7waE6Icp4k2g1cqFrIKPAEK/RpHhwrpsQEOna/5vNN50iOQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777840663; c=relaxed/simple;
	bh=ZK6kVE4aK4cIz4P0nuY6XGFvB37lYQqSEZxrRsUBqQQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lR0mEx+vrDWkDLcuPtoWxbZEm4I7PO1ms/jEnWoG0viUHw+2Hl+uLf2kYMGMDETUYxKjTQptMXUlykcIOJyStxIP22KNWrWxfmi70G2aKhKbwwbjzV/V+pKdE0SJnpa39xtboZ4NbPiL5XhHA4CmPIUfzNjetzVYbER5uswFwb8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fI5E++54; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fI5E++54"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ba6838e76f2so377203466b.2
        for <linux-unionfs@vger.kernel.org>; Sun, 03 May 2026 13:37:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777840659; cv=none;
        d=google.com; s=arc-20240605;
        b=PwS3YF08YH4YGTejlEi+XWxY/HXplbllgBKHCVBY6TMVStTKezJDivC76B3YomjHlL
         p+jbv+xc7C8B0LWlK8grqs/ExSxzjIWfM+mlfwa1N7YK3IAwtcjzAxrpXRFyX3tv+p44
         wj+KMCcmMTqMXcbZ43IM7L5ikrIzDZAMiBhmZ0TSOFyTqBHlTKdpD8oWbqBEOc6Prc7A
         2+AaKq+5XTdehP6R2yeBjPRrvlZLUMvd0mrT0610R0geOkpntki48vOKJAu+fDbZrqbY
         Hq5HkcCZC5NYJnaA/AYoG0epneCzUHvyZryuUry6XaiLTrsNb+U2rXQKkIAgSE32ebO+
         7Jdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oYDjILYmC2Y2v1Vrp32Hw/02aE233hVhJfUp7KpMFnU=;
        fh=nknJG6Sp0hJWdP51glNfYsHgR9cVrT+5nuKEeLmhupk=;
        b=LRt3okHbxdmNIUIzuIK3GQDXcKXBMRbJ8CQ/Amy8mpPyK9/OoDrYiXlEUTaOOvloXk
         r/w0egpThxoxkcn+Ta1TRKso8tQkQeLipGbVwkEmT4LAOSvnUk6k4f+imtPC7c4EgxB4
         GMiEyhd7ORBytRpv+t9e02tOEZFxzlHflCT5Sw4ChDQciBrGAXFR1idvAyfmDSHcOoN9
         jbsPn0HFNUf3aBXeBRuBwui8Mah/w+s3GZEvRZtAmR9N3FW24/BGMLSsK8izQIjLf4m9
         TuQS85HUXQ/yvsvHd/pQG9WQ52IAmupFSJ4h88My0LNj+p+eXc9WrOVw7UQQRqe9gB+u
         UE4A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777840659; x=1778445459; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oYDjILYmC2Y2v1Vrp32Hw/02aE233hVhJfUp7KpMFnU=;
        b=fI5E++54Eh/Bu+4qAfNYX2HtpCshbg6DTZGQAAaZiGG3tPLsUCr3JvB+GlFFzisQ8w
         VOkRyn8FHwx2o3pW2Q8w+IfjtxIeDmU85TxaStFMbmwYoCogLlRsgVRbjMGLJbyVm5/P
         V740t1pxDs+XHbbJJCr0ao9SvBC79r2YDLFNWhSg4dbKRYb8e59Caq42iwfXtumJU8DG
         g7UdFIB0CYDQ/li9t2rNa62BqWTo6uR7pLzYacaT9kO0psn6WQHZMMrrltejIvtdDqc8
         aRuDDp+G0bMG9lQ56Ld358hHzq3Daptp5tjbYY4evR5PJMRZM2Af30HTWSt1bDy4lb9f
         uVSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777840659; x=1778445459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oYDjILYmC2Y2v1Vrp32Hw/02aE233hVhJfUp7KpMFnU=;
        b=rsHYygxJxIgNUydSABE0ODmF0PPD9b+IbtGm2+0sqNdyQv1PpJN4NBvWrsW4+T8eYP
         Xc7GbBo28VbZcSQhZHpDlFUrxHbanjezz/2CZpI9gmov0c/OjVRyg6id3j0qmeRcSU+4
         v0imMMsBHyjWU/AvlfWVrS9SfhqjM7bStRfGVFww07LAFrTVUqp/XJOEy9F7zRXVZlVg
         zsHp69NoSn+H+DbjYGSEj9329PXHnZCkIhKW6z2fJYYQPDesCSn0wOfLPj87kDC6MVfo
         O5FqQ0hRtL/Vag1OL5tCqib2XGSoIYP3cn8cyU8hd3CIr7ae8PXWTn+yIm8pfMsRPDsq
         Jz3A==
X-Forwarded-Encrypted: i=1; AFNElJ8lxlStCCwfTSGpagzM30G5rwzqSG+Auu8dzf3NlEpZtVRZVyYrtyOaYFntN3t2SHVG6VIqTCYm/FjOtN5f@vger.kernel.org
X-Gm-Message-State: AOJu0Ywm52D5F+AUq07nElRTnr3OtZONozNEs8DVlUvsafcxKNLMHzoQ
	QSRdEXRP8WUIPEY7J3371CK+HgUzjWo9BjPklCtfsxDKNb5ZL+7WKbggjt2PLNxplzVw2PvThIR
	BdyuEp/j33JmNQamk5LfI1f3ao1S6+uQ=
X-Gm-Gg: AeBDievEonwsAiEeWUPQZgVEFt8XtP+ZHov0jH+pkoqNEUm7nEoG8Lub9ZkiBQlDy78
	FPHZGco9NcursskdW+zBfhdp+P2OU6HUfAQaSiulc3ShdF58ibVSCwpbULyFTB6ISZXhR79yA5K
	/gjEvuzJGMT8r0E66YoyY7TG4xGRNaB/ZkxuXVHpw9UwgjKtOLYFy05Wegke9A23iSEVXp0nIdK
	lNjmqLk4vVqodde8s7+ihbOaObC5tmHX+v+4Pv2aN5EBHYuUmTXsAh35H2rHyMq7FBRgaOBalzT
	piw/UTz8K8oejeRNjw==
X-Received: by 2002:a17:907:84c8:b0:bb8:fd88:f401 with SMTP id
 a640c23a62f3a-bbffb043992mr251200166b.25.1777840658652; Sun, 03 May 2026
 13:37:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260501232735.2610824-1-souvik@amlalabs.com>
In-Reply-To: <20260501232735.2610824-1-souvik@amlalabs.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 3 May 2026 22:37:27 +0200
X-Gm-Features: AVHnY4IQ3DwkmtwigHf-eOErVpffi8TOS1hCi4QQA1RgX6m_dsBwKEfxps9aVY0
Message-ID: <CAOQ4uxh6YUJEh75sASqi1gOaQYKpWhftz4to1j8s2Y9Jef-XQg@mail.gmail.com>
Subject: Re: [PATCH] ovl: use linked upper dentry in copy-up tmpfile
To: Souvik Banerjee <souvik@amlalabs.com>, Christian Brauner <brauner@kernel.org>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 2, 2026 at 1:27=E2=80=AFAM Souvik Banerjee <souvik@amlalabs.com=
> wrote:
>
> ovl_copy_up_tmpfile() stores the disconnected O_TMPFILE dentry as the
> overlay's upper dentry reference via ovl_inode_update().  vfs_tmpfile()
> allocated this dentry via d_alloc(parentpath->dentry, &slash_name), so
> d_name is "/" and d_parent is c->workdir.  Local upper filesystems
> (ext4, btrfs, xfs, ...) immediately rename it to "#<inum>" via
> d_mark_tmpfile() inside their ->tmpfile() op; FUSE and virtiofs do
> not, so both fields stay that way.  Neither identifies the destination
> directory and filename where ovl_do_link() actually linked the file.
>
> When the upper filesystem implements ->d_revalidate() (e.g. FUSE or
> virtiofs), ovl_revalidate_real() calls it with the dentry's parent
> inode and a snapshot of d_name.  The server tries to look up "/" inside
> c->workdir, fails, and overlayfs reports -ESTALE.
>
> This causes persistent ESTALE errors for any file that was copied up via
> the tmpfile path, breaking dpkg, apt, and other tools that do
> rename-over-existing on overlayfs with a FUSE/virtiofs upper.
>
> Before commit 6b52243f633e ("ovl: fold copy-up helpers into callers"),
> the tmpfile copy-up path used a dedicated helper ovl_link_tmpfile()
> that captured the linked destination dentry returned by ovl_do_link():
>
>     err =3D ovl_do_link(temp, udir, upper);
>     ...
>     if (!err)
>         *newdentry =3D dget(upper);
>
> and published it via ovl_inode_update(d_inode(c->dentry), newdentry).
> The fold inlined ovl_do_link() into ovl_copy_up_tmpfile() but dropped
> the dget(upper) capture, and rewrote the publish line as
> ovl_inode_update(d_inode(c->dentry), dget(temp)) =E2=80=94 where temp is =
the
> disconnected O_TMPFILE dentry.
>
> Fix by keeping a reference to the linked destination dentry after
> ovl_do_link() succeeds, and publishing that dentry at the existing
> ovl_inode_update() call site.  The non-tmpfile/workdir path continues to
> publish the renamed temporary dentry.
>
> Reproducer:
>   - Mount overlayfs with virtiofs (or a FUSE fs whose server advertises
>     FUSE_TMPFILE) as upper
>   - Run: dpkg -i <any .deb>
>   - Observe: "error installing new file '...': Stale file handle"
>
> Fixes: 6b52243f633e ("ovl: fold copy-up helpers into callers")
> Cc: stable@vger.kernel.org # v4.20+
> Signed-off-by: Souvik Banerjee <souvik@amlalabs.com>
> ---
>  fs/overlayfs/copy_up.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 13cb60b52bd6..e963701b4c87 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -853,7 +853,7 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx=
 *c)
>  {
>         struct ovl_fs *ofs =3D OVL_FS(c->dentry->d_sb);
>         struct inode *udir =3D d_inode(c->destdir);
> -       struct dentry *temp, *upper;
> +       struct dentry *temp, *upper, *newdentry =3D NULL;
>         struct file *tmpfile;
>         int err;
>
> @@ -889,6 +889,14 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ct=
x *c)
>         err =3D PTR_ERR(upper);
>         if (!IS_ERR(upper)) {
>                 err =3D ovl_do_link(ofs, temp, udir, upper);
> +               if (!err) {
> +                       /*
> +                        * Record the linked dentry -- not the disconnect=
ed
> +                        * O_TMPFILE dentry -- so that ->d_revalidate() o=
n
> +                        * the upper fs sees the real parent/name.
> +                        */
> +                       newdentry =3D dget(upper);
> +               }
>                 end_creating(upper);
>         }
>
> @@ -903,7 +911,7 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx=
 *c)
>
>         if (!c->metacopy)
>                 ovl_set_upperdata(d_inode(c->dentry));
> -       ovl_inode_update(d_inode(c->dentry), dget(temp));
> +       ovl_inode_update(d_inode(c->dentry), newdentry);
>
>  out:
>         ovl_end_write(c->dentry);
> --
> 2.51.1
>


Hi Souvik,

Thank you for the analysis and the fix.
Looks correct to me.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Christian,

Could you pick this up for vfs-fixes?
I do not have any other ovl fixes queued up.

Thanks,
Amir.
