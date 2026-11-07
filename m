Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794048625;
	b=zvAKnXlTgAypt9LNvbeHFokaB8kMGs6qbkk2+8vTtTG9PjfvkplI3vVo2phe2CTJRaT/
	 HrZU/p7fZ3FFfkTiSENz9XcZPuI4bSANYT8jmxg7uATmGDDLeLcvaquh3/PTqvFb2BC8O
	 H129B2EREotsxDb+HyFJde9KZyJg5pvQofx2YwRRNbnbmfyKcV5NiKezVSlqpjdL6rz+w
	 8UsN2WcO8V/lHCGqMOxKuy2H61vYRYP5gyMkBkPCdLcGDsgkocZuzyaogRqfEIOs1tupm
	 wx4MtnNYjkao8pcMu/ry0VVEha0swHUKTK7qh41g74/bUDnjJNJxN7TexmOnmKBSS2g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794048625;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=uZEeBH3cPO82lNtPrFEZgZR6riIHLqK/uU58y7M4AUg=;
	b=A79KDGiRu+369ynGfN8czybY6DBknHrlRIp6QmQE/hqMix2Xs2QGzfp5OrUnkN0H0TJb
	 JkvCJtfkFFvDA6GlQFPp0yeJ+5prmUT98tBdqnDvdX0NwH5EUibDa3FhHaMWfrXmTHw3J
	 ObiaYKuL7QeANWhbI/U/PwazltSzCyUDpChAHPSn7pJ1R7jya72/+5Wnj44CGgLYEF7/0
	 I0nd2Lu6zYx83ZmVab9mnhHjc05kvUrfaJI03LmCJX1d9+6+USfN8nVvli7wbDoFEwv9t
	 PAxD/CeDntYtP4GdgVzpiV4gRIFFSGpdiJf7hFsqov8PkPgdoSPbI02NhCyKaRLeDQA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uyLXrvTc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7585B606D827
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 10:50:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7585B606D827
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uyLXrvTc
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b704171bc9so186481a12.0
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2026 02:50:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794048624; cv=none;
        d=google.com; s=arc-20260327;
        b=svWrWZKHIgU/8EvaDTEF8wj2VsPpaMFtpZhRkq+QF1b0fIjHXeLItTwmVxxZ6mOils
         BLdoeDG11DJtedWGYUb5aieDU/59rTKxYGTvZzlBRhVGTp3BXsGgrI1hWWNeEafSaw1m
         MUnqfC3OL+yUa7BiH/bk9He9MDegT9IrNsriRDVaN2WzcXiufNWRofU7g19FKcFWv9iG
         1gsEcjDrcekhdQ/g+gUg0o7AiwM/DbIJvFU8lRjRrAEHlxmaeeD40oONrsZVaPgxuwqe
         I5kub97nsTloVS4oXn3slzVWxhkXDS6uAYIDL53K7xRQvkUM6s9IHVKP8SP2ScPRk7mQ
         WxSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uZEeBH3cPO82lNtPrFEZgZR6riIHLqK/uU58y7M4AUg=;
        fh=+/dqJh/JJ6ZutZHwKdoyiTHQw+hETUJQnEqO5RB3IeY=;
        b=UxujkTL3klotjrKLdm8LwmbQ9xQgTDHXVqqjPNQX3tfaeEn3abMaDo1tFtUY8aWYye
         Ory3KwP5/97aIjTAEYGZ8d5Jv+FFZ992J+GqOVEpAI7OoDvE0Pz6+5ri+Fd0BQzxWu9V
         z8ntYaUuuBk/iD1pnrVJDjyxWyWnNS5sOc6u9+YcfKtwch3+W6XhZ/tvxf0oehyAgKz8
         U3Foc5R9YZpw5CUQIVlk4an5rxCWzHbx/JjL1+yGljDcrB8dlIdR/aoQIZMlASZYWEoy
         ALDOBd5b1nNAchFoLD89qFRvdehqAPUtkAfgycU6jmPDCcwEmGNk8yPnO+cehv7TaKDR
         T7fA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794048624; x=1794653424; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uZEeBH3cPO82lNtPrFEZgZR6riIHLqK/uU58y7M4AUg=;
        b=uyLXrvTcnXlGMF4xHoIVZwtvjFB8F2h/zLHGfHi7tmHkHI0SX0Bhe5BQlIXtme5dso
         toor8SB4OufO4DTR0sh4uID6VtjVB+ZQa46GiV5RymVEZPpQdLqiZbXv7dnradhrBlsX
         E4Z1Esh7xd2cEVb0ldUSsGr2qFsZmFDbjdgEwl2xLBTZU2V+9wRSBuNodZZW3/2v+O96
         8Jfkwj2sGa4vN+zirC6oQNLLr2w1dvIq/ssxMgyRZZaxiJky5GOkad0uVqlWosNpWkOT
         HluawS3aZwuvW5MPHQmCFGMJtNzDHDdr6LF7MD1HkrUWlsR9i2c/Ai6V/V4hOM+OW1lo
         2Nvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794048624; x=1794653424;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uZEeBH3cPO82lNtPrFEZgZR6riIHLqK/uU58y7M4AUg=;
        b=PT0VewkGOCTo3BplA0Iu/yPoXmRoHVyxtfzJqgxfU3Y0XOf959WoBoyBnlo9rC5+5m
         9+ZYjM2moBRxIMzCJ78bEAhAnHroR9DD4Q6cU6E7UAZiC1fOiMc9INCEZp3rRSuDJf2O
         KySrRKP0LhIDXpw2Z9c/tysQ21GF+1ZtU+gWHAyxZvYc90KAEpns+34fftHc20R9ticf
         Xhg4La/HOeF5lTMEPUCsSFysOECU5O0kNkLiL98Kn2i/XPzm4Evc3EXRlQRLiRK8t45B
         LKlFpqogrqnxuIhNxTEFy8Q0F5gRqiQGE3r0FIDUzyjwxLxfCknwMcoWcETqIxPgSSXH
         Lh5Q==
X-Forwarded-Encrypted: i=1; AL+hErE7S8CrwCyHYNYZGfua0SaaQxsnbpHaAOiYYJz2/qM+LRZrTXykamRS2J/2LEG+tEkJWGngmf/H6V9CPOga@vger.kernel.org
X-Gm-Message-State: APuU4Z8NZbYfooBz6OEcw0yCKbrJzs3vX9MivpYhUVovFqtFj6corugW
	UVx5mgvwo3tU25vqXjHkr22SnGZtKawCX446H2C8xdiFdzBk8qKPUJu9E2gYPiHd/PHemRxpVPC
	wQ/KC1Q3b0PDmhD+jtXrS4k6MoSVNDfXVvmzs2xI=
X-Gm-Gg: AYBFou0tXTbuMAVaAAJtPGmTltde2z1r2ZKNjXHDEzM8Q9FPpC9md8/3sHuy/dmj3R8
	1GTnWCrAJhVWPQe8Y7GCBcCz62RqrqSV1mfXECaMHSmoYsa+pIAV/j9nf51GkyNHrL9WmRpGf4p
	3MtIHvmPfE2fQZs+1EdEkftoqrcvKCLx643P1Ebi1AgO/G5lMeS+tqGYNleYxRQsIwVZlFeXoDj
	Ck8UgMWnyPeqEwLGIceDW7BFamXsRnRnngaWvi8jFOlDPBVLuzXK7o1sgQHgQRWRYSFNTEhV7gB
	MZfijF04SeG3lZ0PjOEKIUKCavNY9/HqzE2ViOtsNV/xvzutk/fJ5SdK/QGY12z3aQveX5ydi2o
	zUs8k1oqDUdRFWTnAkDlD9yvRiI/mIG2R2QJsaUi+JcRSNupuhUt7/dLz9XX0Lc9GWuoCun97Mr
	TOTUCy+QIT6Eblfeg=
X-Received: by 2002:a05:6402:5d5:b0:6b1:d2ee:392f with SMTP id
 4fb4d7f45d1cf-6b5977e0f6amr3462312a12.25.1794048623497; Sat, 07 Nov 2026
 02:50:23 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106181459.4166343-1-den@openvz.org>
In-Reply-To: <20261106181459.4166343-1-den@openvz.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 7 Nov 2026 11:50:11 +0100
X-Gm-Features: AclHuK9oP7KQWFNTlKkk0yY835oIARMUfGhV4uGnUmqeGmnb5Kbt_bc3-VonTGM
Message-ID: <CAOQ4uxi=Ac=N03ZXJFV9tzxzLJVhiY7Ppv0H-YaV0_cCJiBcnQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: release the upperdir/workdir in-use locks before the
 umount sync
To: "Denis V. Lunev" <den@openvz.org>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 6, 2026 at 7:15=E2=80=AFPM Denis V. Lunev <den@openvz.org> wrot=
e:
>
> From: Denis V. Lunev <den@openvz.org>
>
> The in-use locks on upperdir and workdir are released by ovl_free_fs()
> from ->put_super(). generic_shutdown_super() calls sync_filesystem()
> before that, and ovl_sync_fs() syncs the whole upper filesystem, so the
> locks stay held across a journal commit and a cache flush of the upper
> fs after the overlay is gone. With index=3Don a new overlay that uses the
> same upperdir, or uses it as a lowerdir, fails to mount in that window:
>
>   overlayfs: upperdir is in-use as upperdir/workdir of another mount,
>   mount with '-o index=3Doff' to override exclusive upperdir protection.
>
> Userspace hits this when the last reference is not dropped by umount(2)
> itself. Docker with the containerd snapshotter mounts a snapshot on a
> thread with a private mount namespace for docker cp and for buildkit,
> and the superblock dies when that thread exits, after the reply to the
> client has gone out. The next request then gets EBUSY. The window grows
> with the flush latency of the upper fs and is there even if nothing was
> written through the overlay, as the mount itself dirties the upper.
>
> ->kill_sb() is called once s_active drops to zero, with no mount and no
> open file left. Release the locks there, before generic_shutdown_super()
> runs. What the dying superblock still does to the upper fs, the sync and
> dropping its references to upper dentries and inodes, does not touch the
> contents of upperdir or workdir. ovl_free_fs() still releases the locks
> for a failed mount, so clear the *_locked flags to keep it from
> unlocking a second time and dropping the lock of a newer mount.
>
> This takes the sync out of the window but does not close it: the final
> mntput of a dying mount namespace runs from task_work, after the exiting
> thread may have reported completion. Userspace that needs the
> directories free should umount(2) before saying the job is done.
>
> Fixes: 2cac0c00a6cd ("ovl: get exclusive ownership on upper/work dirs")
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Cc: Amir Goldstein <amir73il@gmail.com>
> Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> Signed-off-by: Denis V. Lunev <den@openvz.org>
> ---
> Tested on a 6.12-based distribution kernel, where this code is the
> same, with a reproducer built on unshare(1) and with docker cp and
> docker build in a container. Built and checked on master.

Applied to ovl-fixes with minor change (see below)

>
>  fs/overlayfs/overlayfs.h |  1 +
>  fs/overlayfs/params.c    |  5 +----
>  fs/overlayfs/super.c     | 12 +++++++++++-
>  fs/overlayfs/util.c      | 12 ++++++++++++
>  4 files changed, 25 insertions(+), 5 deletions(-)
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 901335026a20..85e167a060f4 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -583,6 +583,7 @@ static inline int ovl_set_impure_dir(struct dentry *d=
entry)
>  bool ovl_inuse_trylock(struct dentry *dentry);
>  void ovl_inuse_unlock(struct dentry *dentry);
>  bool ovl_is_inuse(struct dentry *dentry);
> +void ovl_inuse_unlock_all(struct ovl_fs *ofs);
>  bool ovl_need_index(struct dentry *dentry);
>  int ovl_nlink_start(struct dentry *dentry);
>  void ovl_nlink_end(struct dentry *dentry);
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index 5a15e5478a6b..82e270711dbc 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -849,11 +849,8 @@ void ovl_free_fs(struct ovl_fs *ofs)
>         iput(ofs->workdir_trap);
>         dput(ofs->whiteout);
>         dput(ofs->workdir);
> -       if (ofs->workdir_locked)
> -               ovl_inuse_unlock(ofs->workbasedir);
> +       ovl_inuse_unlock_all(ofs);

I moved this up to the start of ovl_free_fs() to be consistent with order
in ovl_kill_super.

Thanks,
Amir.

>         dput(ofs->workbasedir);
> -       if (ofs->upperdir_locked)
> -               ovl_inuse_unlock(ovl_upper_mnt(ofs)->mnt_root);
>
>         /* Reuse ofs->config.lowerdirs as a vfsmount array before freeing=
 it */
>         mounts =3D (struct vfsmount **) ofs->config.lowerdirs;
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index d9174eaccce2..c7018dde1228 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1609,13 +1609,23 @@ int ovl_fill_super(struct super_block *sb, struct=
 fs_context *fc)
>         return err;
>  }
>
> +static void ovl_kill_sb(struct super_block *sb)
> +{
> +       struct ovl_fs *ofs =3D OVL_FS(sb);
> +
> +       /* Nothing can modify them now, do not hold them across the sync =
*/
> +       if (ofs)
> +               ovl_inuse_unlock_all(ofs);
> +       kill_anon_super(sb);
> +}
> +
>  struct file_system_type ovl_fs_type =3D {
>         .owner                  =3D THIS_MODULE,
>         .name                   =3D "overlay",
>         .init_fs_context        =3D ovl_init_fs_context,
>         .parameters             =3D ovl_parameter_spec,
>         .fs_flags               =3D FS_USERNS_MOUNT | FS_ALLOW_IDMAP,
> -       .kill_sb                =3D kill_anon_super,
> +       .kill_sb                =3D ovl_kill_sb,
>  };
>  MODULE_ALIAS_FS("overlay");
>
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 521717209b2e..517d503fc557 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -1050,6 +1050,18 @@ bool ovl_is_inuse(struct dentry *dentry)
>         return inuse;
>  }
>
> +void ovl_inuse_unlock_all(struct ovl_fs *ofs)
> +{
> +       if (ofs->workdir_locked) {
> +               ovl_inuse_unlock(ofs->workbasedir);
> +               ofs->workdir_locked =3D false;
> +       }
> +       if (ofs->upperdir_locked) {
> +               ovl_inuse_unlock(ovl_upper_mnt(ofs)->mnt_root);
> +               ofs->upperdir_locked =3D false;
> +       }
> +}
> +
>  /*
>   * Does this overlay dentry need to be indexed on copy up?
>   */
> --
> 2.53.0
>
