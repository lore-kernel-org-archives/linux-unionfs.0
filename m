Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879183DD84F
	for <linux-unionfs@vger.kernel.org>; Mon, 21 Sep 2026 08:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789978510; cv=pass; b=JOiS/WjFcYiMJlcslU809Pd+YMuhhvixjP7FzWQ0tygjr5Gq+uvTgKX7Z787Ft9yVGD6k8tqUX4tROSrwpfbVrbuO006FPBrvhuVYl/JyYbFOcOAU1fSkC/1Woi2OBwZMAiBdNstYhyAfZ0bD3nev3ZNePrGkQgJBUFODCOEbvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789978510; c=relaxed/simple;
	bh=ZuB6ygpndjsOpo+e/6By11Si9o/wgm2eyRuJxVmjzBc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=crH9yXPIEboRDZqYI8YdK7s7aNn18QKXWBTIo7iLuIfP7BgpBnCOWeU1PaIZczTVk27ZcQ1UhAbQSjRg38CiJc9qjI/0mDAcWelZ+9ZwHC5sDhSk6vUtj51raX6Jod4nwLSxg5yYMCNGgEyNOY/fB4rHt3a1FBjk1N5iWgb04Gk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M/SV0WPa; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M/SV0WPa"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c25ef7a3ce9so312467766b.3
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Sep 2026 01:15:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789978507; cv=none;
        d=google.com; s=arc-20260327;
        b=A8VzjrpxC9aoNIP5UTF5Y2milONm6wke4MyhvBNUl9OnyxniHm5e9zxoEdbHmHlEI/
         FEA91x9KyADnokliD/lZrrLS0mZicRgCJYpGl1rhYXk2Hj5SEWDPNilElCSk86HEsHUd
         Jkl7ICNPkiIo4pVR+JExxMjgfaQH8HMyT/eAUFR5pstuKZozzXVx95O+E6AFQ6d6J0dz
         wlx3iQqZNp1hP7jxzzRtXeCGE1AMlpduA+yLTlClQWRZSEZ5HZB8TnU5/cPeOFf8CYTg
         EkAAn4ljFH7+mWIjtZmQKaGelmh8E0psNeruySgxVGnY1Wl/mK06RfKAKb5AdaqoAvHH
         Kgog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UhW2cidclEmuAluUEKhOZS7Y3pI88Y4LmjXMPyC5ARY=;
        fh=XLVC1WWIYe22BacrWvCYMizoJzRJB4qgiJebFddbfMo=;
        b=U/KtSApJjGUYT1tA4OS6bm3NLIldug7dvwu3RfSzxL1TtYewIeV6XDsaXB11gUOAhL
         bU2PjLc/FFjOOJ7EUsqevKjswi/vsoGoda3h5O1U1Abayt7hFDFqdbBPAsDNxn9N0Ez4
         jV+UxJWO80mI1MOuNCLFOAlZ4/oaYb3M/y+Q9r7tWrkj3Cf2d5OKAigLy8lvnPce/q+J
         y/vhUzrH8iiHar1ESFgz6rplfbcBpuTs/Fti5tfU0Gyk5iTseYWU+iLkwGmIYc0gV+20
         oETgk0S3CfgbxZ3hekbcoAXE/bpc6ksxcR/lIYFi+XLWtLMj8Nv9sU4+LyBxGfexn3ds
         Tu1Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789978507; x=1790583307; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UhW2cidclEmuAluUEKhOZS7Y3pI88Y4LmjXMPyC5ARY=;
        b=M/SV0WPaNud9GUwWvtJszxd+826jNK8DJrcwKkNIwpha1l5QGYWop63zT8V/O12Y9z
         MJzs5xdxa/uHHicoiKm5pBqaQxTldsjYfs1BdPUwxYOiq4jEWwU/pqthqRLLliI/zCmk
         CDr/QpFcFgUeRJTAskxYaVV52FZUAuVfcOtIn6gpzGSlWNwSlrE9dPhxM8YALIsmoSH9
         e/BMVySnHP6gfMG81SAKDwNxICMdUkmbZSE1O+GZdhKuBpjXRP/ojyw1TFhfgVMk6Oqu
         +E+/0LsSEpP7xh6lAP6c3TzMCnhiMV0HIdGIGQDNhsaZvrycySlBDRSEpNjQGss1Qmqa
         zAeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789978507; x=1790583307;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UhW2cidclEmuAluUEKhOZS7Y3pI88Y4LmjXMPyC5ARY=;
        b=2MRb1A3Ko7GKulQWPK2XP8ZkMOv08upOCZ5pNeNa9jah8DS9uHLWVrSskQ4FkF7fax
         zQbKcl4GA0moaAyK/45LJSp9tkE/We92xx9RxDj2PWisfdbg5uS72t+kcvRIHHh7ODZz
         ZBndTN84zb5v0UNRzJsB4CLgY8us+t2SO9b6BxsaIIoWIOPhB7XC3ncgVtqjqIxFNHZm
         2lasz0Vlui3+GTneWZzrCJ7Witlu+Xp2DkF3B9eW7WnG2uKaIa0+mwp+vijMXNONKkGh
         Y5ru77s882IwXp1LzLwO9EaRUVsX54TszkEGf8k/GdrTOF8niNl9lN+9N94UUlu+O/ZH
         bE7A==
X-Forwarded-Encrypted: i=1; AKwUvBxfkgkPmwNtI2IQ63Co5sBr3VKVdvJa3GkdKHAogmDVhRPyhavXpsyT817KxwPrnqS4FBmfq4hR7tHKswWo@vger.kernel.org
X-Gm-Message-State: AFuF++lPqoADWOHgfhc688/tFEL8B4bVShw7l7xw/71cHeJhbeRfvlMl
	WxY/rI20S5iy/uxyPF0FfxGdRWtPxKhrv2DCu54C8ji32HrR6E/rhmQZPdN6JiZ84Ov/e+xteYF
	DpAscYqGjMPkwWFaTyJoZO8u9vJFUD3c=
X-Gm-Gg: AYBFou3I/Ip9TqwlKn7Jf//rM306Mjr/a3ezXuBHoYDKsPmsYYz2uc3xD9+5pjI5REz
	JEdpSttWE5EzPwy+KaT6kDSa+B9ipFfpHnEG+QjCgabLHuh1M6UOBH4rAK412VAbVbkroIBg0aq
	B4SHGIfd+LmcyroLq0ZH0WlTBniYizeKYMHTKkmCqH3wGYe8CwiEVCscKBELxNFvijaiTDWLUsA
	F5pM3Wh91AoVqrlXAYWOpByBb0KDgXqu7r2Z5QHyh3DRH8qtkC4Hrh+yCWd1X9nVScsuDy9rR2s
	7DNkUwZfmBAbJTMt3pfSLADobbnvqgIAX81iM1OUGqlNFZLeBZNnd+KJ/g==
X-Received: by 2002:a17:907:9285:b0:c29:5340:182e with SMTP id
 a640c23a62f3a-c2a15788ecamr847167466b.2.1789978506086; Mon, 21 Sep 2026
 01:15:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260920203239.2876221-2-Jeremy.Jean@oss.cyber.gouv.fr> <20260920203239.2876221-4-Jeremy.Jean@oss.cyber.gouv.fr>
In-Reply-To: <20260920203239.2876221-4-Jeremy.Jean@oss.cyber.gouv.fr>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 21 Sep 2026 10:14:55 +0200
X-Gm-Features: AcwNN1UbcG29pyU5X3cJMyM7lMwffUz3zVeuQCo9MypS9XqzCrCk_TNC4ujot-o
Message-ID: <CAOQ4uxjdY3ppNiZf7bHxwmpXqSyx0oGrjXxgmmYy2gyK4VzrMg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] selftests: overlayfs: reject handles for mixed
 lower idmaps
To: =?UTF-8?B?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>, 
	brauner@kernel.org
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 20, 2026 at 10:33=E2=80=AFPM J=C3=A9r=C3=A9my Jean
<Jeremy.Jean@oss.cyber.gouv.fr> wrote:
>
> Add an idmapped overlay test for two lower layers that share a backing
> superblock but use different idmaps. Mount with index=3Don,nfs_export=3Do=
n and
> verify decodable handle requests fail with EOPNOTSUPP after overlayfs fal=
ls
> back to nfs_export=3Doff.
>
> Signed-off-by: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> ---
>  .../filesystems/overlayfs/idmapped_mounts.c   | 98 ++++++++++++++++++-
>  1 file changed, 94 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/filesystems/overlayfs/idmapped_mount=
s.c b/tools/testing/selftests/filesystems/overlayfs/idmapped_mounts.c
> index 44a75839f4ed..0e94bd464f1c 100644
> --- a/tools/testing/selftests/filesystems/overlayfs/idmapped_mounts.c
> +++ b/tools/testing/selftests/filesystems/overlayfs/idmapped_mounts.c
> @@ -159,8 +159,16 @@ static int idmapped_layer_fd(const char *path, int n=
sid, int hostid, int range)
>         return fd_tree;
>  }
>
> -/* Overlay with a layer passed by fd (idmapped) plus a plain upper/work.=
 */
> -static int ovl_mount_lower_fd(const char *upper, const char *work, int f=
d_lower)
> +static int layer_fd(const char *path)
> +{
> +       return sys_open_tree(AT_FDCWD, path,
> +                            OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
> +}
> +
> +/* Overlay with lower layers passed by fd plus a plain upper/work. */
> +static int ovl_mount_lower_fds(const char *upper, const char *work,
> +                              int fd_lower1, int fd_lower2,
> +                              const char *index, const char *nfs_export)
>  {
>         int fsfd, ovl;
>
> @@ -171,8 +179,19 @@ static int ovl_mount_lower_fd(const char *upper, con=
st char *work, int fd_lower)
>         if (sys_fsconfig(fsfd, FSCONFIG_SET_STRING, "source", "test", 0) =
||
>             sys_fsconfig(fsfd, FSCONFIG_SET_STRING, "upperdir", upper, 0)=
 ||
>             sys_fsconfig(fsfd, FSCONFIG_SET_STRING, "workdir", work, 0) |=
|
> -           sys_fsconfig(fsfd, FSCONFIG_SET_FD, "lowerdir+", NULL, fd_low=
er) ||
> -           sys_fsconfig(fsfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0))
> +           sys_fsconfig(fsfd, FSCONFIG_SET_FD, "lowerdir+", NULL, fd_low=
er1))
> +               goto err;
> +       if (fd_lower2 >=3D 0 &&
> +           sys_fsconfig(fsfd, FSCONFIG_SET_FD, "lowerdir+", NULL, fd_low=
er2))
> +               goto err;
> +       if (index &&
> +           sys_fsconfig(fsfd, FSCONFIG_SET_STRING, "index", index, 0))
> +               goto err;
> +       if (nfs_export &&
> +           sys_fsconfig(fsfd, FSCONFIG_SET_STRING, "nfs_export",
> +                        nfs_export, 0))
> +               goto err;
> +       if (sys_fsconfig(fsfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0))
>                 goto err;
>
>         ovl =3D sys_fsmount(fsfd, 0, 0);
> @@ -183,6 +202,23 @@ static int ovl_mount_lower_fd(const char *upper, con=
st char *work, int fd_lower)
>         return -1;
>  }
>
> +static int ovl_mount_lower_fd(const char *upper, const char *work, int f=
d_lower)
> +{
> +       return ovl_mount_lower_fds(upper, work, fd_lower, -1, NULL, NULL)=
;
> +}
> +
> +static int setup_extra_layer(const char *base, const char *name)
> +{
> +       char path[PATH_MAX];
> +
> +       snprintf(path, sizeof(path), "%s/%s", base, name);
> +       if (mkdir(path, 0755) && errno !=3D EEXIST)
> +               return -1;
> +       if (chown(path, ID_HOST, ID_HOST))
> +               return -1;
> +       return 0;
> +}
> +
>  /*
>   * Mount an overlay inside user namespace @u1 (so the overlay sb's s_use=
r_ns is
>   * not the initial namespace) and idmap that overlay mount with @u2.  Ru=
ns in a
> @@ -498,4 +534,58 @@ TEST_F(idmapped_overlay, nfs_export_handles)
>         EXPECT_EQ(close(ovl), 0);
>  }
>
> +/*
> + * Lower file handles cannot be decoded safely when two lower layers sha=
re a
> + * superblock but use different idmaps.  nfs_export should be disabled f=
or that
> + * layout, so a normal decodable handle request must fail with EOPNOTSUP=
P.
> + */
> +TEST_F(idmapped_overlay, nfs_export_same_sb_mixed_idmaps)
> +{
> +       char lower1[PATH_MAX], lower2[PATH_MAX], upper[PATH_MAX], work[PA=
TH_MAX];
> +       char path[PATH_MAX], mnt[128];
> +       union {
> +               struct file_handle fh;
> +               char buf[sizeof(struct file_handle) + MAX_HANDLE_SZ];
> +       } fhu;
> +       struct file_handle *fh =3D &fhu.fh;
> +       int fd_lower1, fd_lower2, ovl, mount_id;
> +
> +       if (!ovl_supported())
> +               SKIP(return, "overlayfs not supported");
> +
> +       snprintf(lower1, sizeof(lower1), "%s/l", self->base);
> +       snprintf(lower2, sizeof(lower2), "%s/l2", self->base);
> +       snprintf(upper, sizeof(upper), "%s/u", self->base);
> +       snprintf(work, sizeof(work), "%s/w", self->base);
> +       ASSERT_EQ(setup_extra_layer(self->base, "l2"), 0);
> +
> +       snprintf(path, sizeof(path), "%s/l2/file", self->base);
> +       ASSERT_EQ(mknod(path, S_IFREG | 0644, 0), 0);
> +       ASSERT_EQ(chown(path, ID_HOST + 7, ID_HOST + 7), 0);
> +
> +       fd_lower1 =3D idmapped_layer_fd(lower1, ID_HOST, ID_NS, ID_RANGE)=
;
> +       ASSERT_GE(fd_lower1, 0);
> +       fd_lower2 =3D layer_fd(lower2);
> +       ASSERT_GE(fd_lower2, 0);
> +
> +       ovl =3D ovl_mount_lower_fds(upper, work, fd_lower1, fd_lower2, "o=
n", "on");
> +       if (ovl < 0)
> +               SKIP(return, "overlayfs nfs_export not supported");
> +       EXPECT_EQ(close(fd_lower1), 0);
> +       EXPECT_EQ(close(fd_lower2), 0);
> +
> +       snprintf(mnt, sizeof(mnt), "%s/mnt", self->base);
> +       ASSERT_EQ(mkdir(mnt, 0755), 0);
> +       ASSERT_EQ(sys_move_mount(ovl, "", AT_FDCWD, mnt,
> +                                MOVE_MOUNT_F_EMPTY_PATH), 0);
> +
> +       snprintf(path, sizeof(path), "%s/file", mnt);
> +       fh->handle_bytes =3D MAX_HANDLE_SZ;
> +       errno =3D 0;
> +       EXPECT_EQ(name_to_handle_at(AT_FDCWD, path, fh, &mount_id, 0), -1=
);
> +       EXPECT_EQ(errno, EOPNOTSUPP);
> +
> +       EXPECT_EQ(close(ovl), 0);
> +}
> +
>  TEST_HARNESS_MAIN

The expected behavior depends on whether Christian says this
setup is legit in production.

Apart from the that you may add:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
