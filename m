Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A88D4071D1
	for <linux-unionfs@vger.kernel.org>; Wed, 17 Jun 2026 13:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781702933; cv=pass; b=H6GQkCwbKYloe6vDCwPhh8L6A0a2syRfIsiOPgfmTvoTk3s69E7Tue8m7RDN+ziGE11IqJSwpS580j2Lt0EbTsU0khljn3kfckUg12L5kYi6bLIV7A/1gJvMrUuzHHv8mAVNWMfsGm6b0iSR7C0wPkJYg3b9iBHH1Ve1vmGMRgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781702933; c=relaxed/simple;
	bh=JzP7A2/9YgTyWuNY8MfP/ifkGryLgJJMSfcmTLVpKjs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BSl6Aty56U4lMoAHFWnKJ5qnBOaxh/37jEIvMlIWYI4TeNQSv/qEcYcqbIWy1DHxyjpYXSFmU7bAjkn6cpEiCRzfIplodNNv7Rv7uPU+44OHh96J1UQ74OCoqI7ELwaBQZP2O1+OZ+zaOGcJQT5+55UFUUoOJYjQzEapc8aW2Co=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=buMmWZaa; arc=pass smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="buMmWZaa"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-bec43ee8ff0so154609066b.1
        for <linux-unionfs@vger.kernel.org>; Wed, 17 Jun 2026 06:28:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781702925; cv=none;
        d=google.com; s=arc-20240605;
        b=bsrFce7VX7y6J8PQK+RBbcYXA7amJaSOtcla8CY9e8Gzoht+Y0K3xEUQom3nq0wteG
         8FJAv4dS/lJeeiOJsn9r/rKD1pOcp5eCZoOEn/Y47uO4KGP3FXhAYZyFgyH8xEntdRyI
         x6WTVGwfuxFXcb6h/NdlDUJsX45fo5yNZU3e4TA041Uicvride5zt5aj2nVbmFweyM3r
         d+WRrVXkVH4LJO/FUOWUhhx7Bub/1hjIUy9ZE3Krh+p2VBh33neddL4WIKqgaApWuYgF
         ispxvDPyJl1uhl76ElRAdkquRb/Lq9WCUpoUCqy8lh+ynwbs3JaTuyfEOTofrpKEHQLM
         EbHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2qrwmjhfUJon6rUu1uGxbuQGjZP7VBLwryKQPVR8JDY=;
        fh=450Xuhgt1qmbfpf5dD/I6L47f5l5JLwPEQzGhrMjpBo=;
        b=Z7kQK0L3nEcL+BQoTGU99TYVjTs1IiEg7UrwrfUHgbqeX59YG9bOJE1FI7Tzpu2sMa
         VAowrazys1SI883v34dAix3hGffDwQKRWtO5CHem2X5w7vzsL/GqukcO1qFJkFIeRxzS
         0zw0u52XCs7QcwRLXx4aH1Ocl/zzJ+O96A8iREfM1SEtSMefYtgpJ0PbuXb4g6u+h6LP
         JxAAkPAmwnOuuuRQeqNIDR7jm8nL8btu0/iLJXBNHbk7+7usJ+koeOmcEKqZRp6AWwqT
         jn5p1InG/MfxVDl4DKrxH3gQ6Gg8FzYvt8oi7bHw/WaBQKw+i3Ryu4kqy0EOcuDswlh3
         13Aw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781702925; x=1782307725; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2qrwmjhfUJon6rUu1uGxbuQGjZP7VBLwryKQPVR8JDY=;
        b=buMmWZaaxhzECjDerTGbEYHN+liG7EewpPntZexcMYnJ/X1VtiS9zYrudsDhUpfPRT
         dYULcG0iNnwTwIyXNdaAaAmO3OUi5oMEjHcHQUvDmjeZM3ypjAi2fx0K0mOgmx+l4C9P
         Q0i6/sIJs1zaJYElNyk1GHV++BP3io3LjdjAEgBZ2HdSvmxJ9FQC9rXW7Vtp4A3kG8A8
         qoip7+v2c2Ha7F8iJgXL6tGdznLiC+uvY7Jdju3tzXy0Au8vGoWV9mPMk4toyOuSlSVW
         IhwuC+cjyBLvCctlaYt1og5e6T2+uOWZDUJJVvZKpypVhI+34abH1RP/QmWVrN65ZG+V
         7Svg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781702925; x=1782307725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2qrwmjhfUJon6rUu1uGxbuQGjZP7VBLwryKQPVR8JDY=;
        b=IDZ5h47/P3rCga+Dew8Jx0amM/VgUwvIVyGgpvigsa7bwYj5CHOtoRy3B8GkWcHG0w
         t98PgC5qr9qMeAh1UNzl/UL0iqG2bbEUOM+8EvNAcvala3utJnvMrABaGC0vse53lSZr
         U9G40gcJ1M1CmmqQ6nQGxrKNyt3doIoRCaFos1LiafbYcZEpNKveS07BL1gcX60dUSqq
         s58wz3Z8YE1HQb1GyGRcH1r5ZCGGjGJwXsAHuLihBEc63c2CIXVz1rmOMNeTRw3ri2dj
         EnEXkrESbPcnme5ro+CfzkF680Fa+FCjZNZpGrZsyZxLK435iH+cYcBLPfNg5JfFnryZ
         9Hhw==
X-Forwarded-Encrypted: i=1; AFNElJ9k5rXkuMsxIr08p/rLE9mvY3sOIIxYuGzCyJSGB4OhLjHPHWoN6Zm4EziRqjpbxN73u0CT5lRiGTKemc4w@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9xICWeIRVbr2iOu9fvIte+BJHYmDslPiOmFRnUY2oJFkZ8xwz
	baMIKzmOU1RGXCtgrC//0Ww2MJStQR4wZdwyQ6uI09+ASUD/ITXyRidgGhuotY9LySPJG+QO+Qh
	MOXZXUKHkMavMgaY57jPtzUcJfzYTu1TptW+7ZqA=
X-Gm-Gg: Acq92OENzjW0TTjthU0XEa2EYLpu0BdJqbH+ys0fF91Xyyb7y2lWAlcG7uuCaFcOxSw
	JtzOLzvIutIWvM+5Z2m/F6GHFvKquQOtzztZ65mad3Rj3NxdYj98N24AVtUuDkVX5HOaR+ztXav
	fq7qceXeq/tgCmD/70pDN5i6Xpmrjk7RZ9S5RefBgms45F99s5ZNOn7H5ak+3U7Ec3lymgyfzRY
	A+5KwfymlU3T36c5epZVJkETeE8MyaqAdiKnJxgfFS38xlAHBYOViHbro2lzYhgHx6Zo5orZ9bS
	8JwqvgUnSn5xW0R4E5hUSd8uC8Prr5Y=
X-Received: by 2002:a17:907:9615:b0:bee:7c9b:fbd1 with SMTP id
 a640c23a62f3a-c05d6c4b5d7mr141792166b.1.1781702924666; Wed, 17 Jun 2026
 06:28:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org> <20260615-work-idmapped-overlayfs-v1-9-7381632aa402@kernel.org>
In-Reply-To: <20260615-work-idmapped-overlayfs-v1-9-7381632aa402@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 17 Jun 2026 15:28:33 +0200
X-Gm-Features: AVVi8Cer57HyAxnJ-W502scD_1gtdKEdcH95YA5--hpIyVIQiguDwTer-zFOaeA
Message-ID: <CAOQ4uxjPmHrfkHx55dDcFTkfoCD3s=AvBjg2b-4hOCd26g-bjQ@mail.gmail.com>
Subject: Re: [PATCH 09/10] selftests/filesystems/overlayfs: test idmapped
 overlay mounts
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2026 at 3:20=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> Add a selftest for idmapping the merged overlay mount itself.  It
> applies an idmapping to a freshly created (still detached) overlay
> mount with mount_setattr(MOUNT_ATTR_IDMAP) and checks that:
>
>   - getattr reports ownership mapped through the mount idmap;
>   - a file created through the idmapped mount is stored on the upper
>     layer with the corresponding overlay-final id;
>   - chown through the idmapped mount round-trips;
>   - an nfs_export overlay can be idmapped and decodable file handles
>     round-trip through it with correctly mapped ownership.
>
> The layers live on a private tmpfs and are owned by the host id so that
> they map to id 0 through the test idmapping, allowing the root caller
> to operate on them.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  .../selftests/filesystems/overlayfs/.gitignore     |   1 +
>  .../selftests/filesystems/overlayfs/Makefile       |   2 +
>  .../filesystems/overlayfs/idmapped_mounts.c        | 501 +++++++++++++++=
++++++
>  3 files changed, 504 insertions(+)
>
> diff --git a/tools/testing/selftests/filesystems/overlayfs/.gitignore b/t=
ools/testing/selftests/filesystems/overlayfs/.gitignore
> index e23a18c8b37f..077f7a128168 100644
> --- a/tools/testing/selftests/filesystems/overlayfs/.gitignore
> +++ b/tools/testing/selftests/filesystems/overlayfs/.gitignore
> @@ -1,3 +1,4 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  dev_in_maps
>  set_layers_via_fds
> +idmapped_mounts
> diff --git a/tools/testing/selftests/filesystems/overlayfs/Makefile b/too=
ls/testing/selftests/filesystems/overlayfs/Makefile
> index d3ad4a77db9b..b3185f684add 100644
> --- a/tools/testing/selftests/filesystems/overlayfs/Makefile
> +++ b/tools/testing/selftests/filesystems/overlayfs/Makefile
> @@ -8,7 +8,9 @@ LOCAL_HDRS +=3D ../wrappers.h log.h
>
>  TEST_GEN_PROGS :=3D dev_in_maps
>  TEST_GEN_PROGS +=3D set_layers_via_fds
> +TEST_GEN_PROGS +=3D idmapped_mounts
>
>  include ../../lib.mk
>
>  $(OUTPUT)/set_layers_via_fds: ../utils.c
> +$(OUTPUT)/idmapped_mounts: ../utils.c
> diff --git a/tools/testing/selftests/filesystems/overlayfs/idmapped_mount=
s.c b/tools/testing/selftests/filesystems/overlayfs/idmapped_mounts.c
> new file mode 100644
> index 000000000000..44a75839f4ed
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/overlayfs/idmapped_mounts.c
> @@ -0,0 +1,501 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +
> +#include <fcntl.h>
> +#include <limits.h>
> +#include <sched.h>
> +#include <stdio.h>
> +#include <unistd.h>
> +#include <sys/stat.h>
> +#include <sys/syscall.h>
> +
> +#include <linux/mount.h>
> +#include <linux/types.h>
> +
> +#include "kselftest_harness.h"
> +#include "../wrappers.h"
> +#include "../utils.h"
> +
> +/*
> + * An idmapping that maps the mount-visible id range [0, ID_RANGE) onto =
the
> + * host/overlay-final id range [ID_HOST, ID_HOST + ID_RANGE).  Through s=
uch an
> + * idmapped overlay mount, an overlay-final id of ID_HOST + n is reporte=
d as n,
> + * and an id of n requested through the mount is stored as ID_HOST + n.
> + */
> +#define ID_NS   0
> +#define ID_HOST         10000
> +#define ID_RANGE 10000
> +
> +/*
> + * For the composition test the lower layer's on-disk ids live in a
> + * separate range and are mapped by an idmapped lower layer onto the
> + * overlay-final range [ID_HOST, ID_HOST + ID_RANGE).
> + */
> +#define LAYER_HOST 20000
> +
> +#ifndef MOUNT_ATTR_IDMAP
> +#define MOUNT_ATTR_IDMAP 0x00100000
> +#endif
> +
> +#ifndef __NR_mount_setattr
> +#define __NR_mount_setattr 442
> +#endif
> +
> +static inline int sys_mount_setattr(int dfd, const char *path,
> +                                   unsigned int flags,
> +                                   struct mount_attr *attr, size_t size)
> +{
> +       return syscall(__NR_mount_setattr, dfd, path, flags, attr, size);
> +}
> +
> +static bool ovl_supported(void)
> +{
> +       int fd =3D sys_fsopen("overlay", 0);
> +
> +       if (fd < 0)
> +               return false;
> +       close(fd);
> +       return true;
> +}
> +
> +/* base/{l,u,w} owned by ID_HOST so they map to ID_NS through the idmap.=
 */
> +static int setup_layers(const char *base)
> +{
> +       static const char *sub[] =3D { "", "/l", "/u", "/w" };
> +       char path[PATH_MAX];
> +
> +       for (size_t i =3D 0; i < ARRAY_SIZE(sub); i++) {
> +               snprintf(path, sizeof(path), "%s%s", base, sub[i]);
> +               if (mkdir(path, 0755) && errno !=3D EEXIST)
> +                       return -1;
> +               if (i && chown(path, ID_HOST, ID_HOST))
> +                       return -1;
> +       }
> +       return 0;
> +}
> +
> +static int ovl_mount(const char *base, bool nfs_export)
> +{
> +       char lower[PATH_MAX], upper[PATH_MAX], work[PATH_MAX];
> +       int fsfd, ovl;
> +
> +       snprintf(lower, sizeof(lower), "%s/l", base);
> +       snprintf(upper, sizeof(upper), "%s/u", base);
> +       snprintf(work, sizeof(work), "%s/w", base);
> +
> +       fsfd =3D sys_fsopen("overlay", 0);
> +       if (fsfd < 0)
> +               return -1;
> +
> +       if (sys_fsconfig(fsfd, FSCONFIG_SET_STRING, "source", "test", 0) =
||
> +           sys_fsconfig(fsfd, FSCONFIG_SET_STRING, "lowerdir", lower, 0)=
 ||
> +           sys_fsconfig(fsfd, FSCONFIG_SET_STRING, "upperdir", upper, 0)=
 ||
> +           sys_fsconfig(fsfd, FSCONFIG_SET_STRING, "workdir", work, 0))
> +               goto err;
> +       if (nfs_export &&
> +           (sys_fsconfig(fsfd, FSCONFIG_SET_STRING, "index", "on", 0) ||

index is implied by nfs_export.

> +            sys_fsconfig(fsfd, FSCONFIG_SET_STRING, "nfs_export", "on", =
0)))
> +               goto err;
> +       if (sys_fsconfig(fsfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0))
> +               goto err;
> +
> +       ovl =3D sys_fsmount(fsfd, 0, 0);
> +       close(fsfd);
> +       return ovl;
> +err:
> +       close(fsfd);
> +       return -1;
> +}
> +
> +/* Idmap the (still detached, not yet visible) overlay mount @mfd. */
> +static int ovl_idmap(int mfd)
> +{
> +       struct mount_attr attr =3D {
> +               .attr_set =3D MOUNT_ATTR_IDMAP,
> +       };
> +       int ret, userns_fd;
> +
> +       /*
> +        * get_userns_fd(fs_id, mount_id, range): a file whose filesystem=
 id
> +        * is fs_id + n is shown through the idmapped mount as mount_id +=
 n.
> +        * Here the overlay-final (fs side) range is [ID_HOST, ..) and th=
e
> +        * caller-visible (mount side) range is [ID_NS, ..).
> +        */
> +       userns_fd =3D get_userns_fd(ID_HOST, ID_NS, ID_RANGE);
> +       if (userns_fd < 0)
> +               return -1;
> +
> +       attr.userns_fd =3D userns_fd;
> +       ret =3D sys_mount_setattr(mfd, "", AT_EMPTY_PATH, &attr, sizeof(a=
ttr));
> +       close(userns_fd);
> +       return ret;
> +}
> +
> +/* Clone @path into a detached, idmapped mount usable as an overlay laye=
r. */
> +static int idmapped_layer_fd(const char *path, int nsid, int hostid, int=
 range)
> +{
> +       struct mount_attr attr =3D {
> +               .attr_set =3D MOUNT_ATTR_IDMAP,
> +       };
> +       int fd_tree, userns_fd;
> +
> +       fd_tree =3D sys_open_tree(AT_FDCWD, path,
> +                              OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
> +       if (fd_tree < 0)
> +               return -1;
> +       userns_fd =3D get_userns_fd(nsid, hostid, range);
> +       if (userns_fd < 0) {
> +               close(fd_tree);
> +               return -1;
> +       }
> +       attr.userns_fd =3D userns_fd;
> +       if (sys_mount_setattr(fd_tree, "", AT_EMPTY_PATH, &attr,
> +                             sizeof(attr))) {
> +               close(userns_fd);
> +               close(fd_tree);
> +               return -1;
> +       }
> +       close(userns_fd);
> +       return fd_tree;
> +}
> +
> +/* Overlay with a layer passed by fd (idmapped) plus a plain upper/work.=
 */
> +static int ovl_mount_lower_fd(const char *upper, const char *work, int f=
d_lower)
> +{
> +       int fsfd, ovl;
> +
> +       fsfd =3D sys_fsopen("overlay", 0);
> +       if (fsfd < 0)
> +               return -1;
> +
> +       if (sys_fsconfig(fsfd, FSCONFIG_SET_STRING, "source", "test", 0) =
||
> +           sys_fsconfig(fsfd, FSCONFIG_SET_STRING, "upperdir", upper, 0)=
 ||
> +           sys_fsconfig(fsfd, FSCONFIG_SET_STRING, "workdir", work, 0) |=
|
> +           sys_fsconfig(fsfd, FSCONFIG_SET_FD, "lowerdir+", NULL, fd_low=
er) ||
> +           sys_fsconfig(fsfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0))
> +               goto err;
> +
> +       ovl =3D sys_fsmount(fsfd, 0, 0);
> +       close(fsfd);
> +       return ovl;
> +err:
> +       close(fsfd);
> +       return -1;
> +}
> +
> +/*
> + * Mount an overlay inside user namespace @u1 (so the overlay sb's s_use=
r_ns is
> + * not the initial namespace) and idmap that overlay mount with @u2.  Ru=
ns in a
> + * child that joins @u1; returns 0 on success.
> + */
> +static int userns_overlay_child(int u1)
> +{
> +       struct mount_attr attr =3D {
> +               .attr_set =3D MOUNT_ATTR_IDMAP,
> +       };
> +       struct stat st;
> +       int ovl, u2;
> +
> +       /* Become root in the overlay sb's user namespace u1. */
> +       if (!switch_userns(u1, 0, 0, false))
> +               return fprintf(stderr, "userns: switch_userns: %m\n"), -1=
;
> +       if (unshare(CLONE_NEWNS) ||
> +           sys_mount(NULL, "/", NULL, MS_SLAVE | MS_REC, NULL))
> +               return fprintf(stderr, "userns: unshare/slave: %m\n"), -1=
;
> +       if (sys_mount("tmpfs", "/tmp", "tmpfs", 0, NULL))
> +               return fprintf(stderr, "userns: mount tmpfs: %m\n"), -1;
> +       if (setup_layers("/tmp/ovl"))
> +               return fprintf(stderr, "userns: setup_layers: %m\n"), -1;
> +       if (mknod("/tmp/ovl/l/file", S_IFREG | 0644, 0) ||
> +           chown("/tmp/ovl/l/file", ID_HOST + 5, ID_HOST + 5))
> +               return fprintf(stderr, "userns: lower file: %m\n"), -1;
> +
> +       ovl =3D ovl_mount("/tmp/ovl", false);
> +       if (ovl < 0)
> +               return fprintf(stderr, "userns: ovl_mount: %m\n"), -1;
> +
> +       /*
> +        * mount_setattr() requires CAP_SYS_ADMIN over the idmap user
> +        * namespace, so it must be a child of u1.  Create it now, from
> +        * inside u1.
> +        */
> +       u2 =3D get_userns_fd(ID_HOST, ID_NS, ID_RANGE);
> +       if (u2 < 0)
> +               return fprintf(stderr, "userns: get_userns_fd: %m\n"), -1=
;
> +       attr.userns_fd =3D u2;
> +       if (sys_mount_setattr(ovl, "", AT_EMPTY_PATH, &attr, sizeof(attr)=
))
> +               return fprintf(stderr, "userns: mount_setattr: %m\n"), -1=
;
> +       close(u2);
> +
> +       if (fstatat(ovl, "file", &st, 0))
> +               return fprintf(stderr, "userns: fstatat: %m\n"), -1;
> +       if (st.st_uid !=3D ID_NS + 5 || st.st_gid !=3D ID_NS + 5) {
> +               fprintf(stderr, "userns: got %u:%u expected %u:%u\n",
> +                       st.st_uid, st.st_gid, ID_NS + 5, ID_NS + 5);
> +               return -1;
> +       }
> +       return 0;
> +}
> +
> +FIXTURE(idmapped_overlay) {
> +       char base[64];
> +};
> +
> +FIXTURE_SETUP(idmapped_overlay)
> +{
> +       /* Private mount namespace so test mounts need no cleanup. */
> +       ASSERT_EQ(unshare(CLONE_NEWNS), 0);
> +       ASSERT_EQ(sys_mount(NULL, "/", NULL, MS_SLAVE | MS_REC, NULL), 0)=
;
> +
> +       /* tmpfs for the layers so we can chown them to arbitrary ids. */
> +       ASSERT_EQ(sys_mount("tmpfs", "/tmp", "tmpfs", 0, NULL), 0);
> +
> +       snprintf(self->base, sizeof(self->base), "/tmp/ovl");
> +       ASSERT_EQ(setup_layers(self->base), 0);
> +}
> +
> +FIXTURE_TEARDOWN(idmapped_overlay)
> +{
> +}
> +
> +/* A file owned by ID_HOST + 5 is reported as ID_NS + 5 through the idma=
p. */
> +TEST_F(idmapped_overlay, getattr)
> +{
> +       char path[PATH_MAX];
> +       struct stat st;
> +       int ovl;
> +
> +       if (!ovl_supported())
> +               SKIP(return, "overlayfs not supported");
> +
> +       snprintf(path, sizeof(path), "%s/l/file", self->base);
> +       ASSERT_EQ(mknod(path, S_IFREG | 0644, 0), 0);
> +       ASSERT_EQ(chown(path, ID_HOST + 5, ID_HOST + 5), 0);
> +
> +       ovl =3D ovl_mount(self->base, false);
> +       ASSERT_GE(ovl, 0);
> +       ASSERT_EQ(ovl_idmap(ovl), 0);
> +
> +       ASSERT_EQ(fstatat(ovl, "file", &st, 0), 0);
> +       EXPECT_EQ(st.st_uid, ID_NS + 5);
> +       EXPECT_EQ(st.st_gid, ID_NS + 5);
> +
> +       EXPECT_EQ(close(ovl), 0);
> +}
> +
> +/*
> + * Every creation path initializes the new owner through the mount idmap=
:
> + * created as caller id ID_NS, stored on the upper layer as overlay-fina=
l
> + * ID_HOST.  Covers ovl_create() (regular file), ovl_mkdir(), ovl_mknod(=
)
> + * and ovl_symlink() (which share ovl_create_object()), plus the separat=
e
> + * ovl_tmpfile() path.
> + */
> +TEST_F(idmapped_overlay, create)
> +{
> +       static const char *names[] =3D { "reg", "dir", "fifo", "lnk" };
> +       char path[PATH_MAX];
> +       struct stat st;
> +       int ovl, fd;
> +
> +       if (!ovl_supported())
> +               SKIP(return, "overlayfs not supported");
> +
> +       ovl =3D ovl_mount(self->base, false);
> +       ASSERT_GE(ovl, 0);
> +       ASSERT_EQ(ovl_idmap(ovl), 0);
> +
> +       /* One object per creation operation, all as caller id ID_NS. */
> +       fd =3D openat(ovl, "reg", O_CREAT | O_WRONLY | O_EXCL, 0644);
> +       ASSERT_GE(fd, 0);
> +       EXPECT_EQ(close(fd), 0);
> +       ASSERT_EQ(mkdirat(ovl, "dir", 0755), 0);
> +       ASSERT_EQ(mknodat(ovl, "fifo", S_IFIFO | 0644, 0), 0);
> +       ASSERT_EQ(symlinkat("target", ovl, "lnk"), 0);
> +
> +       for (size_t i =3D 0; i < ARRAY_SIZE(names); i++) {
> +               /* Reported as ID_NS through the idmapped mount ... */
> +               ASSERT_EQ(fstatat(ovl, names[i], &st, AT_SYMLINK_NOFOLLOW=
), 0);
> +               EXPECT_EQ(st.st_uid, ID_NS);
> +               EXPECT_EQ(st.st_gid, ID_NS);
> +               /* ... and stored as ID_HOST on the upper layer. */
> +               snprintf(path, sizeof(path), "%s/u/%s", self->base, names=
[i]);
> +               ASSERT_EQ(lstat(path, &st), 0);
> +               EXPECT_EQ(st.st_uid, ID_HOST);
> +               EXPECT_EQ(st.st_gid, ID_HOST);
> +       }
> +
> +       /* O_TMPFILE goes through the separate ovl_tmpfile() path. */
> +       fd =3D openat(ovl, ".", O_TMPFILE | O_WRONLY, 0644);
> +       ASSERT_GE(fd, 0);
> +       /* Inside the mount: caller id ID_NS. */
> +       ASSERT_EQ(fstat(fd, &st), 0);
> +       EXPECT_EQ(st.st_uid, ID_NS);
> +       EXPECT_EQ(st.st_gid, ID_NS);
> +       /* Link it in so the upper backing file can be inspected too. */
> +       ASSERT_EQ(linkat(fd, "", ovl, "tmp", AT_EMPTY_PATH), 0);
> +       EXPECT_EQ(close(fd), 0);
> +       snprintf(path, sizeof(path), "%s/u/tmp", self->base);
> +       ASSERT_EQ(lstat(path, &st), 0);
> +       EXPECT_EQ(st.st_uid, ID_HOST);
> +       EXPECT_EQ(st.st_gid, ID_HOST);
> +
> +       EXPECT_EQ(close(ovl), 0);
> +}
> +
> +/* chown through the idmapped mount round-trips: ID_NS + 5 <-> ID_HOST +=
 5. */
> +TEST_F(idmapped_overlay, chown)
> +{
> +       char path[PATH_MAX];
> +       struct stat st;
> +       int ovl, fd;
> +
> +       if (!ovl_supported())
> +               SKIP(return, "overlayfs not supported");
> +
> +       ovl =3D ovl_mount(self->base, false);
> +       ASSERT_GE(ovl, 0);
> +       ASSERT_EQ(ovl_idmap(ovl), 0);
> +
> +       fd =3D openat(ovl, "f", O_CREAT | O_WRONLY | O_EXCL, 0644);
> +       ASSERT_GE(fd, 0);
> +       EXPECT_EQ(close(fd), 0);
> +
> +       ASSERT_EQ(fchownat(ovl, "f", ID_NS + 5, ID_NS + 5, 0), 0);
> +
> +       ASSERT_EQ(fstatat(ovl, "f", &st, 0), 0);
> +       EXPECT_EQ(st.st_uid, ID_NS + 5);
> +       EXPECT_EQ(st.st_gid, ID_NS + 5);
> +
> +       snprintf(path, sizeof(path), "%s/u/f", self->base);
> +       ASSERT_EQ(stat(path, &st), 0);
> +       EXPECT_EQ(st.st_uid, ID_HOST + 5);
> +       EXPECT_EQ(st.st_gid, ID_HOST + 5);
> +
> +       EXPECT_EQ(close(ovl), 0);
> +}
> +
> +/*
> + * Composition: an idmapped lower layer underneath an idmapped overlay m=
ount.
> + * An on-disk id is mapped by the layer idmap into the overlay-final ran=
ge and
> + * then by the mount idmap into the caller's range:
> + *
> + *   on-disk LAYER_HOST+7  --layer-->  ID_HOST+7  --mount-->  ID_NS+7
> + */
> +TEST_F(idmapped_overlay, composition)
> +{
> +       char lower[PATH_MAX], upper[PATH_MAX], work[PATH_MAX], path[PATH_=
MAX];
> +       struct stat st;
> +       int ovl, fd_lower;
> +
> +       if (!ovl_supported())
> +               SKIP(return, "overlayfs not supported");
> +
> +       snprintf(lower, sizeof(lower), "%s/l", self->base);
> +       snprintf(upper, sizeof(upper), "%s/u", self->base);
> +       snprintf(work, sizeof(work), "%s/w", self->base);
> +
> +       /* Put the lower layer's ids in the on-disk [LAYER_HOST, ..) rang=
e. */
> +       ASSERT_EQ(chown(lower, LAYER_HOST, LAYER_HOST), 0);
> +       snprintf(path, sizeof(path), "%s/l/file", self->base);
> +       ASSERT_EQ(mknod(path, S_IFREG | 0644, 0), 0);
> +       ASSERT_EQ(chown(path, LAYER_HOST + 7, LAYER_HOST + 7), 0);
> +
> +       /* Idmapped lower: on-disk LAYER_HOST <-> overlay-final ID_HOST. =
*/
> +       fd_lower =3D idmapped_layer_fd(lower, LAYER_HOST, ID_HOST, ID_RAN=
GE);
> +       ASSERT_GE(fd_lower, 0);
> +
> +       ovl =3D ovl_mount_lower_fd(upper, work, fd_lower);
> +       ASSERT_GE(ovl, 0);
> +       EXPECT_EQ(close(fd_lower), 0);
> +
> +       /* Idmap the overlay mount: overlay-final ID_HOST <-> caller ID_N=
S. */
> +       ASSERT_EQ(ovl_idmap(ovl), 0);
> +
> +       ASSERT_EQ(fstatat(ovl, "file", &st, 0), 0);
> +       EXPECT_EQ(st.st_uid, ID_NS + 7);
> +       EXPECT_EQ(st.st_gid, ID_NS + 7);
> +
> +       EXPECT_EQ(close(ovl), 0);
> +}
> +
> +/* An idmapped overlay mount whose sb lives inside a user namespace. */
> +TEST_F(idmapped_overlay, userns)
> +{
> +       int u1;
> +       pid_t pid;
> +
> +       if (!ovl_supported())
> +               SKIP(return, "overlayfs not supported");
> +
> +       /* u1 backs the overlay sb: identity-mapped, but not the init ns.=
 */
> +       u1 =3D get_userns_fd(0, 0, 65536);
> +       if (u1 < 0)
> +               SKIP(return, "user namespaces not available");
> +
> +       pid =3D fork();
> +       ASSERT_GE(pid, 0);
> +       if (pid =3D=3D 0) {
> +               int ret =3D userns_overlay_child(u1);
> +
> +               _exit(ret ? EXIT_FAILURE : EXIT_SUCCESS);
> +       }
> +       EXPECT_EQ(wait_for_pid(pid), 0);
> +
> +       EXPECT_EQ(close(u1), 0);
> +}
> +
> +/*
> + * An nfs_export overlay can be idmapped, and decodable file handles rou=
nd-trip
> + * through the idmapped mount with correctly mapped ownership.  Overlay =
file
> + * handles encode object identity, not ownership, so the mount idmap doe=
s not
> + * affect them; it only maps the owner reported once a handle is reopene=
d.
> + */
> +TEST_F(idmapped_overlay, nfs_export_handles)
> +{
> +       char path[PATH_MAX], mnt[128];
> +       union {
> +               struct file_handle fh;
> +               char buf[sizeof(struct file_handle) + MAX_HANDLE_SZ];
> +       } fhu;
> +       struct file_handle *fh =3D &fhu.fh;
> +       struct stat st;
> +       int ovl, mfd, fd, mount_id;
> +
> +       if (!ovl_supported())
> +               SKIP(return, "overlayfs not supported");
> +
> +       snprintf(path, sizeof(path), "%s/l/file", self->base);
> +       ASSERT_EQ(mknod(path, S_IFREG | 0644, 0), 0);
> +       ASSERT_EQ(chown(path, ID_HOST + 7, ID_HOST + 7), 0);
> +
> +       /* nfs_export=3Don gives decodable overlay file handles. */
> +       ovl =3D ovl_mount(self->base, true);
> +       if (ovl < 0)
> +               SKIP(return, "overlayfs nfs_export not supported");
> +       ASSERT_EQ(ovl_idmap(ovl), 0);
> +
> +       /* Attach the idmapped mount so handles can be resolved against i=
t. */
> +       snprintf(mnt, sizeof(mnt), "%s/mnt", self->base);
> +       ASSERT_EQ(mkdir(mnt, 0755), 0);
> +       ASSERT_EQ(sys_move_mount(ovl, "", AT_FDCWD, mnt,
> +                                MOVE_MOUNT_F_EMPTY_PATH), 0);
> +
> +       snprintf(path, sizeof(path), "%s/file", mnt);
> +       fh->handle_bytes =3D MAX_HANDLE_SZ;
> +       ASSERT_EQ(name_to_handle_at(AT_FDCWD, path, fh, &mount_id, 0), 0)=
;
> +
> +       mfd =3D open(mnt, O_RDONLY | O_DIRECTORY);
> +       ASSERT_GE(mfd, 0);
> +       fd =3D open_by_handle_at(mfd, fh, O_RDONLY);

This is likely exercising the code path ovl_lookup_inode() =3D> d_find_any_=
alias()
I think it is more interesting for this patch set to exercising the code pa=
th of
ovl_obtain_alias() via ovl mount cycle or something.

Thanks,
Amir.
