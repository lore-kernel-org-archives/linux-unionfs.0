Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9178B2673B0
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 21:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778967185; cv=pass; b=WVozliJbDamXvtHiTwSBFaNiWaBPaJlmCOfeExXnpbRgFPYPn85awjHotzdwXfYQc0ije2rDJUp8aL3mRFyctnnM1PxunEiH8dUz71LmlrzBJHff3LcVCsQ9gtM0B3Lgujg/gGRj1kLqUHJfPryqjXTLqjSfAXJqajnduSuv/KI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778967185; c=relaxed/simple;
	bh=BXsZV79c366UnjUfakh8gqRbmjrjBqz6w7KMJevok3o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G1/mYDmu3efEgTbWnBMH2okliTNaiVBuT4mEZuRBgDeCbB2n9GtVBMDow4Qspv0I5uOsKphlmKQ5k88k4wWiA9cEOjx1F+qK34ujasvSCfjDBSv+BQ1+dZovOFOOjvnRpP4ULJjEk0/7aVACrfaoUdTxny9WOnQoLHmYA00bl0Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NDIrtx+M; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NDIrtx+M"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-67e24b8ef55so2047563a12.1
        for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 14:33:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778967182; cv=none;
        d=google.com; s=arc-20240605;
        b=OgnY1fJp6wVUh2UvmPCfPsHXT4uIaUvCptfSXLFQX6KIjTfOaZxGIP5k5u/FCFQ2h6
         WffBdYTmWMJ3hI2TklTHawMnbaB70tqweWNDU4BawFDCYQSADicl0PZoUXgNkKO33L6F
         cUlfT/VRJjETjeZoZ5M2TDVKdJepzhbTEBqgWOeusbHRaer6Xkj9nDCISwR4FnQiR1Ci
         T/VQQjh7XyF/GlEEiidb8i/lztuvKXIBRc+riE/WUDOtkTb3iqo9eX3tBAkdqkYvlXOH
         RoVO/7DYs7SysNLj9eLY7kHRGkTUju2GeQuDHRL1FonZXuw/QbUCjHUntAPIdSlb6Sc9
         IK+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BWaazyZYsXIJpOKmeh9IchbhFNxJQGeaPQHbFURAAAI=;
        fh=woGTdxYAafmWtvyqkeByWa8+BsvgfjswpM1jACAVO/o=;
        b=lkIfKnGDjJG6UDtmJuiRQa28WHfxezzRXxV/QpgprDKUHcom9Gxqf0dSSimcYi1o/B
         Jbf3jAYzSS5SZxZKRWLyMIptBQZHCfk2wJFNJsAjIXlATIUp6XxiA675wuPLaq4mcMmK
         ZVDqWXITiBdLULIbKu+7oVDDAarX2QKMNapC5ZO80/P9wI0hGH/xmzjgvbnvy7VixUzL
         0Fr4Ht+veg44Ci6LXYWTM/kmxkswZylQFt6aOgdeWk6J8EWxjoEiWUJSjKI2AfB4AA7v
         iOzQmOSk6XK2M44unXUG5py7+t6U1X/sEY7D4rAiyG/SE4ZGgKDuPMhIZ3if/fAsmLn/
         lLAw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778967182; x=1779571982; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BWaazyZYsXIJpOKmeh9IchbhFNxJQGeaPQHbFURAAAI=;
        b=NDIrtx+MGg7ifyu5vcmqYmbvuyRt7b8Ea3hyMV6Es/1/EnxBok0xC6B1gxwLhx0O1J
         qG54YP1LvRz/gm0e7Vcxwe5FpHsaVa7l6RdcBgtQsN6QiIwxMb5wFq5M948zNBsVzDZZ
         kzQNPVB2wM+t3YTrGlUCURdv5TVbwdNRXNb3uEInXGcT4caKMJKt8kFbp9gzhaJx/RNQ
         f5dBPvNH9lbkun7MaJqdzi5krwVMNDq0NVOH1tYcfzpEFnjM7lme6zBT2xi+YGKuEnBM
         3UcRFZ/ZCvru4AcP3EoxWxpjJ0EzlC4EDWEBx37MVBT3GYJIcr4x71tz6Jbhut5v/RQE
         PGJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778967182; x=1779571982;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BWaazyZYsXIJpOKmeh9IchbhFNxJQGeaPQHbFURAAAI=;
        b=WARDMAJsA8lj++ZCFYcpQtOkPaI9MY3wmJWCFONQZXEELdNL/ZGiCtMn0G4hUed4SU
         AfRNKdDioxzr7Rc6A82iXp4yssYu3ZjvAUYCRn9ZSRrDXerVI7j4BulNR5WZff9ZJCi/
         nFIrtTKFRIMh7/ybA26IehSNmuBbAMjS7hO/uYLRPCVBDN7NqFXcN86B52pWtZVqNjWo
         QRoE/Nt0M3HOK44+JfK1v/c2Fu4bXCU+n6iBnjpQFNXPs4k89wR7FUyajeJK0+orbE51
         EL5u94nTqsG5nyCV84zs1I5TlmASzI3taqV1Zlyug0CRIRTBLZnPS7Rtqq03C/bA++cs
         K5Dw==
X-Forwarded-Encrypted: i=1; AFNElJ/Z5eBqpOkELnI/v1gRruvrGkz+7nDasCh+kssh4T61vZgMd2p+gLMhrAp74UkEqMeKJE5mCOvHfXHAAoK+@vger.kernel.org
X-Gm-Message-State: AOJu0YzZb0k6hZsLxd+pqHFIwKI1su9osUFXIqdgdPJASkZeiP5UIil3
	fbk3Pth1lCdyNYJ+AaBmWWm0RCF44JVCdTGNhQmux4lPX86WG/ZzqzwuVbsMTmwEvVHrwr/zCDu
	L4Duh75OO3hpPlhuaVzquhPzqwjrEuCw=
X-Gm-Gg: Acq92OF84wwL9jOci5E4JZEtwiMLvdPrVYNHN6N17iqwF+53ve+vfips2RfEtB8SDPE
	uMDg/XdxGMTy0/u09IncTcNIM1lD2olpk8UwghRSke/Doyma0YVuU6VlFuMsSt9vkNkGh0tftf2
	DZlrEex5RUtl49OVEEQ5q5cOI5VAHbXryZrdTWrq2O8vKMz0OaDR4nOmQg9ZjMlorMO1AUSE0sE
	6L2J1N6cVIa5Du9NYacp+OwrgouLfjLaJ7PPWO4uhT83Zo50rbZetJyeMblNkBZTv+X6ENJKpzi
	IF7qNX8/AyGAnm9uAhiTTzuLIqo6+updWU8e1GFqAg==
X-Received: by 2002:a05:6402:2742:b0:67f:e9d0:d819 with SMTP id
 4fb4d7f45d1cf-683bd1955e1mr4542144a12.22.1778967181731; Sat, 16 May 2026
 14:33:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com> <20260516004004.1455526-18-joannelkoong@gmail.com>
In-Reply-To: <20260516004004.1455526-18-joannelkoong@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 16 May 2026 23:32:50 +0200
X-Gm-Features: AVHnY4KyU_ETmuYR2EQLjVCx9XjHFDk7vSclSGbQvJrWsgZeZqCv4aF_-JCdWyI
Message-ID: <CAOQ4uxg9WT7WmJqQezgiCB1jOX_heW+=UJbbFntbfDUdm0H=tQ@mail.gmail.com>
Subject: Re: [PATCH v2 17/21] backing-inode: add backing_inode_copyattr()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org, Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 2:53=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Move logic in ovl_copyattr() to a generic backing_inode_copyattr()
> function in a new fs/backing-inode.c, which other filesystems that use
> backing inodes (eg fuse passthrough) will use.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/Makefile                   |  2 +-
>  fs/backing-inode.c            | 43 +++++++++++++++++++++++++++++++++++
>  fs/overlayfs/util.c           | 33 +++------------------------
>  include/linux/backing-inode.h | 14 ++++++++++++


Nice!

Please add these files to
FILESYSTEMS [STACKABLE]
section in MAINTAINERS.

Otherwise, feel free to add:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

There is one more cleanup patch required, now or later, to get rid of
some awkwardness in kernel fs code.
If you don't want to deal with it, I can take this cleanup later.

d_backing_inode() is a noop from the day it was added and has 177
call sites. Those call sites should be converted to d_inode() and
d_backing_inode() should go away.

backing_inode_security{,_novalidate}() are likewise unneeded
dups of inode_security{,_novalidate}() and should be removed.

Thanks,
Amir.

>  4 files changed, 61 insertions(+), 31 deletions(-)
>  create mode 100644 fs/backing-inode.c
>  create mode 100644 include/linux/backing-inode.h
>
> diff --git a/fs/Makefile b/fs/Makefile
> index cf4a745e9679..3f8a227d4938 100644
> --- a/fs/Makefile
> +++ b/fs/Makefile
> @@ -40,7 +40,7 @@ obj-$(CONFIG_COMPAT_BINFMT_ELF)       +=3D compat_binfm=
t_elf.o
>  obj-$(CONFIG_BINFMT_ELF_FDPIC) +=3D binfmt_elf_fdpic.o
>  obj-$(CONFIG_BINFMT_FLAT)      +=3D binfmt_flat.o
>
> -obj-$(CONFIG_FS_STACK)         +=3D backing-file.o
> +obj-$(CONFIG_FS_STACK)         +=3D backing-file.o backing-inode.o
>  obj-$(CONFIG_FS_MBCACHE)       +=3D mbcache.o
>  obj-$(CONFIG_FS_POSIX_ACL)     +=3D posix_acl.o
>  obj-$(CONFIG_NFS_COMMON)       +=3D nfs_common/
> diff --git a/fs/backing-inode.c b/fs/backing-inode.c
> new file mode 100644
> index 000000000000..474770a1fa9d
> --- /dev/null
> +++ b/fs/backing-inode.c
> @@ -0,0 +1,43 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Common helpers for stackable filesystems and backing inodes.
> + */
> +
> +#include <linux/backing-inode.h>
> +
> +/*
> + * backing_inode_copyattr - copy inode attributes from a backing inode
> + *
> + * When a filesystem copies inode information from a backing layer to it=
s own
> + * inode, it applies the idmapping of the backing mount, ensuring that
> + * the inode ownership will correctly reflect the ownership of the idmap=
ped
> + * backing mount. For example, an idmapped backing mount mapping id 1001=
 to id
> + * 1000 will take care to map any backing inode owned by id 1001 to id 1=
000.
> + * These mapping helpers are nops when the backing mount isn't idmapped.
> + */
> +void backing_inode_copyattr(struct inode *inode,
> +                           const struct path *backing_path)
> +{
> +       struct inode *realinode;
> +       struct mnt_idmap *real_idmap;
> +       vfsuid_t vfsuid;
> +       vfsgid_t vfsgid;
> +
> +       realinode =3D d_inode_rcu(backing_path->dentry);
> +       real_idmap =3D mnt_idmap(backing_path->mnt);
> +
> +       spin_lock(&inode->i_lock);
> +       vfsuid =3D i_uid_into_vfsuid(real_idmap, realinode);
> +       vfsgid =3D i_gid_into_vfsgid(real_idmap, realinode);
> +
> +       inode->i_uid =3D vfsuid_into_kuid(vfsuid);
> +       inode->i_gid =3D vfsgid_into_kgid(vfsgid);
> +       inode->i_mode =3D realinode->i_mode;
> +       inode_set_atime_to_ts(inode, inode_get_atime(realinode));
> +       inode_set_mtime_to_ts(inode, inode_get_mtime(realinode));
> +       inode_set_ctime_to_ts(inode, inode_get_ctime(realinode));
> +       i_size_write(inode, i_size_read(realinode));
> +       spin_unlock(&inode->i_lock);
> +}
> +EXPORT_SYMBOL_GPL(backing_inode_copyattr);
> +
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 3f1b763a8bb4..3e7d66c26c10 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -16,6 +16,7 @@
>  #include <linux/namei.h>
>  #include <linux/ratelimit.h>
>  #include <linux/overflow.h>
> +#include <linux/backing-inode.h>
>  #include "overlayfs.h"
>
>  /* Get write access to upper mnt - may fail if upper sb was remounted ro=
 */
> @@ -1503,38 +1504,10 @@ int ovl_sync_status(struct ovl_fs *ofs)
>         return errseq_check(&mnt->mnt_sb->s_wb_err, ofs->errseq);
>  }
>
> -/*
> - * ovl_copyattr() - copy inode attributes from layer to ovl inode
> - *
> - * When overlay copies inode information from an upper or lower layer to=
 the
> - * relevant overlay inode it will apply the idmapping of the upper or lo=
wer
> - * layer when doing so ensuring that the ovl inode ownership will correc=
tly
> - * reflect the ownership of the idmapped upper or lower layer. For examp=
le, an
> - * idmapped upper or lower layer mapping id 1001 to id 1000 will take ca=
re to
> - * map any lower or upper inode owned by id 1001 to id 1000. These mappi=
ng
> - * helpers are nops when the relevant layer isn't idmapped.
> - */
>  void ovl_copyattr(struct inode *inode)
>  {
>         struct path realpath;
> -       struct inode *realinode;
> -       struct mnt_idmap *real_idmap;
> -       vfsuid_t vfsuid;
> -       vfsgid_t vfsgid;
>
> -       realinode =3D ovl_i_path_real(inode, &realpath);
> -       real_idmap =3D mnt_idmap(realpath.mnt);
> -
> -       spin_lock(&inode->i_lock);
> -       vfsuid =3D i_uid_into_vfsuid(real_idmap, realinode);
> -       vfsgid =3D i_gid_into_vfsgid(real_idmap, realinode);
> -
> -       inode->i_uid =3D vfsuid_into_kuid(vfsuid);
> -       inode->i_gid =3D vfsgid_into_kgid(vfsgid);
> -       inode->i_mode =3D realinode->i_mode;
> -       inode_set_atime_to_ts(inode, inode_get_atime(realinode));
> -       inode_set_mtime_to_ts(inode, inode_get_mtime(realinode));
> -       inode_set_ctime_to_ts(inode, inode_get_ctime(realinode));
> -       i_size_write(inode, i_size_read(realinode));
> -       spin_unlock(&inode->i_lock);
> +       ovl_i_path_real(inode, &realpath);
> +       backing_inode_copyattr(inode, &realpath);
>  }
> diff --git a/include/linux/backing-inode.h b/include/linux/backing-inode.=
h
> new file mode 100644
> index 000000000000..6b43cba9fabd
> --- /dev/null
> +++ b/include/linux/backing-inode.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Common helpers for stackable filesystems and backing inodes.
> + */
> +
> +#ifndef _LINUX_BACKING_INODE_H
> +#define _LINUX_BACKING_INODE_H
> +
> +#include <linux/fs.h>
> +
> +void backing_inode_copyattr(struct inode *inode,
> +                           const struct path *backing_path);
> +
> +#endif /* _LINUX_BACKING_INODE_H */
> --
> 2.52.0
>
