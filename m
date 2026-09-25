Received: from mail-ed2-f34.google.com (mail-ed2-f34.google.com [74.125.228.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C344C8C79
	for <linux-unionfs@vger.kernel.org>; Fri, 25 Sep 2026 15:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.98
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790351859; cv=pass; b=HAPpFNCx05aHZkoQKx61jYeZQ4ZN5pq8SRiwMAceEhU4v22d0kbPLvYT2Pwg8CVTWUKbewVSjeTDtWBlvKPjKjlAErWMsLbNRtP0UYn+Z0aMtkCzZ2LOANfdoNb+hBvatSJ3NhqLvCLPMnupV0vbnwp6LGOCFmZEUp2iDBh6uPE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790351859; c=relaxed/simple;
	bh=+rd9BLTE4a5WJJ+eX0XRtQ3schbzUk6dFpAODuJHfJE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h9R2Jl/q3qx+/MzwEomaxbV9i06e0QvjlIZN61SxTxrmZ2HiEB52FMfOnLsvdXM02ggRupUtaq1T7Vpu7lbx9aNqIJKOmn36wOsUzz9hFbn3TywG/QgiPyNOUY8a6ubcZWqdwzuQqnEqhrsEGM6gFfhp8O19x//I3FTblgLnd5k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gAVYgi67; arc=pass smtp.client-ip=74.125.228.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gAVYgi67"
Received: by mail-ed2-f34.google.com with SMTP id 4fb4d7f45d1cf-6aae7b7fe22so1593607a12.2
        for <linux-unionfs@vger.kernel.org>; Fri, 25 Sep 2026 08:57:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790351855; cv=none;
        d=google.com; s=arc-20260327;
        b=VJ3LT/anzo8VTACA3+uJrLH+eScTSTe/2LwzXrk7W4MEHCowCC0aikfdotxnBWPkw8
         rn4z1FW07pRtRuzCKroKh0+wlImuro+tVcnWs1bVkqUN7rMrNhBHfgGj6fc1MhEUaCrA
         rJwJ6Cszfbe8u9ReC/6oc32N5byrRfBHs/akgUgZqdjgStnXHrs/m7QzXg+8eJUseW77
         Kb/KmTJrhMH+xlTmuc5zIpJpcxRvXulzxLshiEKfDfG5/rx/zUvPgjCDs55RiSVSgVz0
         nKEAbkBzSt1+B8NqUZDf3gstClgUXK1abShV7ktleLWAtpUsmTW/I6K6Nft5X0/lFjCx
         1H/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nMAg6pX/HlA77Pu3mxpzrHzAZUs7ETdSimrKmiOB8sM=;
        fh=CnMDtrmFRBSOf+HNsfmDF/ZTajcdT7bVbiFygb/V9s0=;
        b=eaCRq8WbL4f8ioHyU6ZiHhRawnJetEG39GL/AeCUzXuJovVLh4xoIx8jqOhs0EFSIR
         5U/BMKhgF0h27JPb7LZPnwpV1PSGYOahr1T9XL7zb216rLrEMzMoobUdZwoIKIS5ws+Z
         MF4R3/rlJNUUn97+NT94Ii5rC7e5QUE1dJVW7HMxUgscOeb4Q6GmsJ2eWDSZM7gmyPZi
         YG9ILoZR14A+uA21GFrkE6H15C4X9dG1aiziVsjrcbZL6QjR4hlP7MAIqPajy+bc1iu6
         DOzqhSSwcGQWWtZPK3pXuiGnMQrNdRyEPQf1Vj89iCm3BTu18o5ZNoE/G0GUL9ychZ0N
         NoTQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790351855; x=1790956655; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nMAg6pX/HlA77Pu3mxpzrHzAZUs7ETdSimrKmiOB8sM=;
        b=gAVYgi670zfKUzzOMdMCKrTF6MMXXzY8WhAoWiALNjDT0aSxm1+Laa13xnVRtje+KY
         eXXdZ5NM4LqLNJo91LvvAKoC/F9w5xeM45n/3LOM/psf7agz8GkVuzYPjLgschPnZ+OS
         +M3P6IubLFHbk2NN8pNpO3B6bmRqqtEnhbaSpqfGDeRjl7jowo8Z1YjfFs2ekTXLjDkJ
         kZ3P4eILmpqjwC7qIvvQF9x1+E7b6VatTpajjZNY1gguT6V5fqXkrFL5BdsYkY6z0P8m
         lnxYWQrsxTHxC1ARkai7VLjh+HeYwzXmg6KYIa2Io+l09O05k35N8EImSMZSG3SDXgiJ
         UxUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790351855; x=1790956655;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nMAg6pX/HlA77Pu3mxpzrHzAZUs7ETdSimrKmiOB8sM=;
        b=HqOy5JS5FJfZrXlT7Q0DUXH1yy+6FsXqSkGEuXhv6KjOMoGGZ0RTWMIIQowNc+jyc0
         EIRO0L3ycNLeYLQr0QixmhyOeCHElQleXDQ3MJWjhIukiqcKgF5Ynaavu7K007y0fKOd
         41bgCQIVLWI4HPDSOU4d9X85lItMG22mLUWJRqsAM8E+6UVRO3HVHTKtGKPC/nsjPv/A
         b09W/pV99v7Vf9YrIDK5m1zv+9+I3WSCnvTMH5UhkydTbbacwbCvmF73MZpyGi7au05a
         zGEuNuRztF2M8Jg8Po5je1aZlWt0I2pjs6I4QupDKmGZVO3/LwZrhma2a+4FK0jB8AXP
         6MXQ==
X-Forwarded-Encrypted: i=1; AKwUvBwtBUDQomWeT4kNfi0nBlxFBULFVn37MDcAXO/YfFb7RPnw7UMMs1FqPiPFcjgD2HxqHYgCUz/k5oky5G0D@vger.kernel.org
X-Gm-Message-State: AFuF++mRdE71A56KOrrPvkR1zvJDU9j2WLSKTXjpY8VAySoJJjtd7IT6
	r3WnLlbGj0YS5ry50SJApM64uQmSzNzpEHJcVNN4h3SQaF4x4F1sg909itooKfIbSi1H3SDt48B
	GWF3zdqaDkOkuTMT37FCLYbnqb/bviuo=
X-Gm-Gg: AYBFou0JBtoZt/P7bu5XSCtxqXA8QbMoc7afbasKLFdlAKCy7U5e/sOe0FMIA7/FlsC
	+AuOqmBa3BRQI5+0ACdoykbL5kcd38yHlcodF3FPrD/9cTmno4tjRip8X9GPkbvbm+ldbSB+HRw
	g3Qtd67gs1+cCSzl3sv0qXxcSPIIapQNDB2X7XTCOOaxBfis58cF0jGhl7sJB8cRxEYRfDBXjG3
	17lOd1Iyft0Jc0XcVXrMgyml7v1t8GF/w6WIvLxeCkYngHMIvJ5yF3WRSGGURB2a2ccYuKF620t
	3WvEUvSvP4EH5YbGQjT8HX/8ZEzVzNzbGVuOFe6gZY0Yripf9CuGdhJwUsGLv66X1eo=
X-Received: by 2002:a05:6402:3806:b0:6aa:e46b:2ca with SMTP id
 4fb4d7f45d1cf-6aae8f391b3mr2402778a12.30.1790351854413; Fri, 25 Sep 2026
 08:57:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260924112858.51392-1-disgoel@linux.ibm.com> <20260924112858.51392-2-disgoel@linux.ibm.com>
In-Reply-To: <20260924112858.51392-2-disgoel@linux.ibm.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 25 Sep 2026 17:57:23 +0200
X-Gm-Features: AclHuK92kTEXDHL8m7s-mwWhA-PfNWKaA3m5DTMfLrf-QlUnLQ-m8TUSXfz_Sqs
Message-ID: <CAOQ4uxgj3RL2roivmha9yeWToR-s9kaBm8WUK1vJ_q7pWOjxOQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ovl: fix wrong layer paths in mountinfo for detached
 mount FDs
To: Disha Goel <disgoel@linux.ibm.com>, brauner@kernel.org
Cc: miklos@szeredi.hu, viro@zeniv.linux.org.uk, jack@suse.cz, shuah@kernel.org, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 24, 2026 at 1:29=E2=80=AFPM Disha Goel <disgoel@linux.ibm.com> =
wrote:
>
> When overlayfs layers are passed as detached mount file descriptors
> (opened with open_tree(OPEN_TREE_CLONE)), ovl_parse_layer() uses d_path()
> to record the layer's path for display in mountinfo.
>
> d_path() walks up the mount tree to the process's filesystem root.  For
> detached mounts this walk stops at the anonymous namespace root instead
> of the real system root, producing a short incorrect path like "/l1"
> instead of the full absolute path.
>
> Export mnt_is_anon() from fs/namespace.c to detect detached mounts.  In
> ovl_parse_layer(), use dentry_path_raw() for detached mounts instead of
> d_path().  dentry_path_raw() walks the dentry chain independent of mount
> namespace and returns the correct fs-relative path.  The path is
> display-only; the actual layer_path used for mounting is always correct.
>
> Also fix the set_layers_via_detached_mount_fds selftest: the mountinfo
> check strings were copy-pasted from the regular (non-detached) test and
> expected absolute /tmp/ paths, causing the test to always fail.
>
> Fixes: a08557d19ef4 ("ovl: specify layers via file descriptors")
> Cc: stable@vger.kernel.org
> Signed-off-by: Disha Goel <disgoel@linux.ibm.com>

Disha,

Thanks for the report!

> ---
>  fs/namespace.c                                |  9 ++++++++
>  fs/overlayfs/params.c                         | 14 ++++++++++-
>  include/linux/mount.h                         |  1 +
>  .../overlayfs/set_layers_via_fds.c            | 23 +++++++++++--------
>  4 files changed, 37 insertions(+), 10 deletions(-)
>
> diff --git a/fs/namespace.c b/fs/namespace.c
> index ae5dc64f8b45..9feefa0a517d 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -363,6 +363,15 @@ bool __mnt_is_readonly(const struct vfsmount *mnt)
>  }
>  EXPORT_SYMBOL_GPL(__mnt_is_readonly);
>
> +bool mnt_is_anon(struct vfsmount *mnt)
> +{
> +       struct mount *m =3D real_mount(mnt);
> +       struct mnt_namespace *ns =3D READ_ONCE(m->mnt_ns);
> +
> +       return !IS_ERR_OR_NULL(ns) && is_anon_ns(ns);
> +}
> +EXPORT_SYMBOL_GPL(mnt_is_anon);
> +
>  static inline void mnt_inc_writers(struct mount *mnt)
>  {
>  #ifdef CONFIG_SMP
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index c93fcaa45d4a..2758ff8426b7 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -477,7 +477,19 @@ static int ovl_parse_layer(struct fs_context *fc, st=
ruct fs_parameter *param,
>                 layer_path =3D param->file->f_path;
>                 path_get(&layer_path);
>
> -               layer_name =3D d_path(&layer_path, buf, PATH_MAX);
> +               /*
> +                * For detached mounts (open_tree(OPEN_TREE_CLONE)), d_pa=
th()
> +                * resolves against the anonymous namespace root and retu=
rns a
> +                * short fs-relative path rather than a full system path.=
  Use
> +                * dentry_path_raw() instead, which gives the path relati=
ve to
> +                * the filesystem root regardless of mount namespace.  Th=
e name
> +                * is display-only; layer_path itself is always correct.
> +                */
> +               if (mnt_is_anon(layer_path.mnt))
> +                       layer_name =3D dentry_path_raw(layer_path.dentry,
> +                                                    buf, PATH_MAX);
> +               else
> +                       layer_name =3D d_path(&layer_path, buf, PATH_MAX)=
;
>                 if (IS_ERR(layer_name))
>                         return PTR_ERR(layer_name);
>
> diff --git a/include/linux/mount.h b/include/linux/mount.h
> index acfe7ef86a1b..51e9f228c9d1 100644
> --- a/include/linux/mount.h
> +++ b/include/linux/mount.h
> @@ -78,6 +78,7 @@ extern void mnt_make_shortterm(struct vfsmount *mnt);
>  extern struct vfsmount *mnt_clone_internal(const struct path *path);
>  extern bool __mnt_is_readonly(const struct vfsmount *mnt);
>  extern bool mnt_may_suid(struct vfsmount *mnt);
> +extern bool mnt_is_anon(struct vfsmount *mnt);
>
>  extern struct vfsmount *clone_private_mount(const struct path *path);
>  int mnt_get_write_access(struct vfsmount *mnt);
> diff --git a/tools/testing/selftests/filesystems/overlayfs/set_layers_via=
_fds.c b/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
> index 7a293544233d..12d930fe46be 100644
> --- a/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
> +++ b/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
> @@ -686,23 +686,28 @@ TEST_F(set_layers_via_fds, set_layers_via_detached_=
mount_fds)
>         while (getline(&line, &len, f_mountinfo) !=3D -1) {
>                 char *haystack =3D line;
>
> -               if (strstr(haystack, "workdir=3D/tmp/w"))
> +               /*
> +                * Detached mount FDs are resolved via dentry_path_raw(),
> +                * which gives a path relative to the underlying fs root
> +                * (e.g. "/u/upper", "/l1") rather than a full system pat=
h.
> +                */
> +               if (strstr(haystack, "upperdir=3D/u/upper"))
>                         layers_found[0] =3D true;
> -               if (strstr(haystack, "upperdir=3D/tmp/u"))
> +               if (strstr(haystack, "workdir=3D/u/work"))
>                         layers_found[1] =3D true;
> -               if (strstr(haystack, "lowerdir+=3D/tmp/l1"))
> +               if (strstr(haystack, "lowerdir+=3D/l1"))
>                         layers_found[2] =3D true;
> -               if (strstr(haystack, "lowerdir+=3D/tmp/l2"))
> +               if (strstr(haystack, "lowerdir+=3D/l2"))
>                         layers_found[3] =3D true;
> -               if (strstr(haystack, "lowerdir+=3D/tmp/l3"))
> +               if (strstr(haystack, "lowerdir+=3D/l3"))
>                         layers_found[4] =3D true;
> -               if (strstr(haystack, "lowerdir+=3D/tmp/l4"))
> +               if (strstr(haystack, "lowerdir+=3D/l4"))
>                         layers_found[5] =3D true;
> -               if (strstr(haystack, "datadir+=3D/tmp/d1"))
> +               if (strstr(haystack, "datadir+=3D/d1"))
>                         layers_found[6] =3D true;
> -               if (strstr(haystack, "datadir+=3D/tmp/d2"))
> +               if (strstr(haystack, "datadir+=3D/d2"))
>                         layers_found[7] =3D true;
> -               if (strstr(haystack, "datadir+=3D/tmp/d3"))
> +               if (strstr(haystack, "datadir+=3D/d3"))
>                         layers_found[8] =3D true;
>         }
>         free(line);
> --
> 2.45.1
>

Christian,

I confirm that the test is failing on upstream:

# Starting 1 tests from 1 test cases.
#  RUN           set_layers_via_fds.set_layers_via_detached_mount_fds ...
# set_layers_via_fds.c:717:set_layers_via_detached_mount_fds:Expected
layers_found[i] (0) =3D=3D true (1)
# set_layers_via_fds.c:39:set_layers_via_detached_mount_fds:Expected
rmdir("/set_layers_via_fds") (-1) =3D=3D 0 (0)
# set_layers_via_detached_mount_fds: Test terminated by assertion
#          FAIL  set_layers_via_fds.set_layers_via_detached_mount_fds
not ok 1 set_layers_via_fds.set_layers_via_detached_mount_fds
# FAILED: 0 / 1 tests passed.

I could not find a point of regression.
Could it be that the test was merged failing?
That would be strange.

This is how mountinfo of detached layers look like on upstream:
/ /set_layers_via_fds rw,relatime - overlay none
rw,lowerdir+=3D/,lowerdir+=3D/,lowerdir+=3D/,lowerdir+=3D/,datadir+=3D/,dat=
adir+=3D/,datadir+=3D/,upperdir=3D/upper,workdir=3D/work,uuid=3Don,metacopy=
=3Don

Whether the suggested solution is what we want for it, I am not sure.
I also don't recall if we discussed this at the time and whether
there were any decisions about how to present this mountinfo.

Maybe this mountinfo is fine and then we only need to fix the test.

Thanks,
Amir.
