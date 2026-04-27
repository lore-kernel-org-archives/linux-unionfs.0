Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD03370D7B
	for <linux-unionfs@vger.kernel.org>; Mon, 27 Apr 2026 07:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777276193; cv=pass; b=aZ3IjgGxsP6GNWz/RplciMy1x4so61eNz78/fuBxk10RoZ069Q5sZH1fAFks6BC+iOfG32/IM2yD52oUPwfsB/DoXZ907AozOomg6mc7vT8clV4jK6Nx+bZLds6wy52lm+7v4YoTCsA043kD24vQPvKl8m1b1IWToksVecrzAeA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777276193; c=relaxed/simple;
	bh=f7OgKalAyVt5gmyU2LJSzNsZnB4DtET7GNZ8+Zt9tWU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=seD5uKLa4oTua4W+oKEzNpy7uDv1MPKL85/l2naPnumkHH5h12lDlntWPIsM48Wq4cL9R23JLgQbBKmpMHaa16iBaRW+6oiksnCfFLQ5jRrMBoxscKUW4yFmvIPCMq1bBgUi15RWdE4IgxahiZ5zomomtmpu92H3Q90m5GjLvgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lf5ppi9A; arc=pass smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lf5ppi9A"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ba545100a13so1050956366b.2
        for <linux-unionfs@vger.kernel.org>; Mon, 27 Apr 2026 00:49:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777276190; cv=none;
        d=google.com; s=arc-20240605;
        b=PonOatN7BXWvFmNJ4FApI8U9xzpUdNoS2cs8wm3Zmw+w8ddU78PZG/f054JQtnEN0j
         oJqtWuqcFVtJY+NHVPsi9EXytr5qsPgDA1t917aZRRhd6RhYbt45syO6D0xCewsN1Ygt
         LCyqMiKdGj6r82/lgfwE53blGMIOhXfA+93nWmtxcyFPJNXf1BR22iq18bie9wSPmKgo
         ge0wnOFjb+IK37RDYzecfn1mdhoeO0ymmf9wmA9nbUXldz0Eb/ih0zZKyLOkLS0BTaUd
         JtC7NkRc4V5JA+UiPrgfFf7HzDoI4Wq0aJFxW41DYthGWPAklN1fCyBtLlcfsFMpsvop
         5v3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M+JJEH7a7ZgWwJ+BUNcwUv/jdbyBTQx+IMzVRjmXkV4=;
        fh=UxAh5xo3yaHSKPSfaDXUnF8hcaqT/arz7D8Xdmf5H/M=;
        b=Qfd4I81uhgFewozv1MmpjhvVjD9E465dDYv5pEZJTTDFFcqo2zdmhC031aZ62KpSuy
         l2YxJ9s8mVw0ECrPlXoWCXcGbe+t9MF8k/dAN7EV/h2wDYs3+EcalpQKBz0qQjS3Ctrh
         3LioZaiEbCd7tzRw8zHF1HKmTvGiw38KMh4OdK1hdVV97iak+Y9+85/nNLAbaPIurXFl
         S7S7b0yUY49jzi3hM/1lqvljYCuY4pxSymjMa9+Z9eQfU2b/96137HAml881TBkTLPJ4
         VZoz4212NHyPuy1mEQtopy0j53k2W+UybW6RY5L6tmfHh35UjW2zM2Qkh3HZpdNYtP4e
         orCQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777276190; x=1777880990; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M+JJEH7a7ZgWwJ+BUNcwUv/jdbyBTQx+IMzVRjmXkV4=;
        b=Lf5ppi9ArV3tMF4TQI1tAC9lpKfF6UauWPDSK4QmAzWkDz445wbNgYCno88v7X0XbD
         VT4/2UAahAj7BPtuPfPIDzL7dOadMKIyWTCT6rF/ukqMZAIGIckYT4HDod6oSGb2zDNv
         j3GQddJ5sDWomFGzwAmORYvdN8WC+CI+iQipilmJ6w/tMAVoXA8I3hjFRx159tHzYZnH
         hRp/l1FOVr6KBn4F4SiNWO6slthc373Hi9zhjcsloCwYmG8oiu9zTNbfegZCB8p7dV++
         VmVGiNU4Vs4aNhireAP3YhcditlXAX0/zuSWuMJEZ+f2idZ962Yk1+Zx6eB8ZgEQ1HBf
         i6hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777276190; x=1777880990;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M+JJEH7a7ZgWwJ+BUNcwUv/jdbyBTQx+IMzVRjmXkV4=;
        b=djL/cDERklnaXkbCB9ibynEnYH/TpcR6wTRf9PNLHo6K1/mUzFA+Cba0IXipXw34YK
         FRTguTXJ+MwG4ckQp8aPKIADeJHEhBllg1szaffg2WsEE/1ZgH8owKXISZA0B8zRCpC/
         OPm3Epmf0CYt4HB9aNIThy6RUx1eT8IVn30xjVP0WfGkvdaiwOEn67Dnl+d/dUj4yFai
         0BegEvUPmMUqxagVn5B/uVVKswwU+AJQk0eiUMsEVrOm9dAT/kK1LVSbVs/FItuexU+E
         gucDe9daD83JXcQ/xoTF2xc9wEjwiAucHxNulBROd/Q8DaTzeUjQnvGcm+Ms2S0n4XJL
         kENw==
X-Forwarded-Encrypted: i=1; AFNElJ9fV/rdNlmlbQIRLdyX+hADatAQlBYdpyWzTv4/lHwXgzN4CsQmdDWI9KhOUseum3j1tx/5PweCCSIO9sI6@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6kCDnp0F+zgeuv6Fiqt557oEgRyqKHM7FKy43OsL5iWY2xEKy
	TxdZU4YyqZyiyeBaJFsFjHDee9inMNp7yVsWfi+9i5yyngYAlDUhTA4h2YYuH29qZgiqBzN1xsY
	c0CSU2AvqJDjHYJkRu/CR5xN0vBb5dNI=
X-Gm-Gg: AeBDievQC/tuh1ZmfgPs7aOgdTEPjolO8Q83W3W9z/xY3IUFRibkZ/r3n1Tqf7vp0s3
	CD7fYO2d1oSzPQyyQdo2opA67qZuCU27+gtMpplCld+Kv5afXNzhU9z4tpKIwe3cCT9X3E3GbV0
	DYmd7tL4rAwcqA0YiaQmihp1nKN7mICUrE0sLhnwIicmzAWAQNhn7/za24CZrqtjmtpcJIq3A9+
	+/ElTzliFhsNgCbWYEEd1NlUfv+y191YHksTiuD+UkIhKwtHyrOmzAOBZUMpPAYK3eBTGhIWDsp
	rtPtYT861o45O11akLl6VPfUg0Ar6yY5f0rG/2hul1o6f4Cjtytm
X-Received: by 2002:a17:907:a604:b0:b9d:6a05:64ab with SMTP id
 a640c23a62f3a-ba41828cbb9mr1910538866b.8.1777276189333; Mon, 27 Apr 2026
 00:49:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427040517.828226-1-neilb@ownmail.net> <20260427040517.828226-9-neilb@ownmail.net>
In-Reply-To: <20260427040517.828226-9-neilb@ownmail.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 27 Apr 2026 09:49:36 +0200
X-Gm-Features: AVHnY4KLQlNudAoMusC5eQkonz2WBnBqsh6v2a9sQQCshqNF5gfekEomngG1TZA
Message-ID: <CAOQ4uxjj6iJNnwUqV+cRtqo4qRD4v-f-ct92=ofCZWPDATXM7g@mail.gmail.com>
Subject: Re: [PATCH v3 08/19] VFS/xfs/ntfs: drop parent lock across
 d_alloc_parallel() in d_add_ci()
To: NeilBrown <neil@brown.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2026 at 6:07=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrote=
:
>
> From: NeilBrown <neil@brown.name>
>
> A proposed change will invert the lock ordering between
> d_alloc_parallel() and inode_lock() on the parent.
> When that happens it will not be safe to call d_alloc_parallel() while
> holding the parent lock - even shared.
>
> We don't need to keep the parent lock held when d_add_ci() is run - the
> VFS doesn't need it as dentry is exclusively held due to
> DCACHE_PAR_LOOKUP and the filesystem has finished its work.
>
> So drop and reclaim the lock (shared or exclusive as determined by
> LOOKUP_SHARED) to avoid future deadlock.
>
> Signed-off-by: NeilBrown <neil@brown.name>
> ---
>  fs/dcache.c            | 18 +++++++++++++++++-
>  fs/ntfs/namei.c        |  4 +++-
>  fs/xfs/xfs_iops.c      |  3 ++-
>  include/linux/dcache.h |  3 ++-
>  4 files changed, 24 insertions(+), 4 deletions(-)
>
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 569a8ddf4c0d..a2ddfe811df3 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -2294,6 +2294,7 @@ EXPORT_SYMBOL(d_obtain_root);
>   * @dentry: the negative dentry that was passed to the parent's lookup f=
unc
>   * @inode:  the inode case-insensitive lookup has found
>   * @name:   the case-exact name to be associated with the returned dentr=
y
> + * @bool:   %true if lookup was performed with LOOKUP_SHARED

I do not understand the choice of API.
Seems better to pass the lookup flags and avoid exposing this very internal
logic in the call sites...

>   *
>   * This is to avoid filling the dcache with case-insensitive names to th=
e
>   * same inode, only the actual correct case is stored in the dcache for
> @@ -2306,7 +2307,7 @@ EXPORT_SYMBOL(d_obtain_root);
>   * the exact case, and return the spliced entry.
>   */
>  struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
> -                       struct qstr *name)
> +                       struct qstr *name, bool shared)
>  {
>         struct dentry *found, *res;
>
> @@ -2319,6 +2320,17 @@ struct dentry *d_add_ci(struct dentry *dentry, str=
uct inode *inode,
>                 iput(inode);
>                 return found;
>         }
> +       /*
> +        * We are holding parent lock and so don't want to wait for a
> +        * d_in_lookup() dentry.  We can safely drop the parent lock and
> +        * reclaim it as we have exclusive access to dentry as it is
> +        * d_in_lookup() (so ->d_parent is stable) and we are near the
> +        * end ->lookup() and will shortly drop the lock anyway.
> +        */
> +       if (shared)
> +               inode_unlock_shared(d_inode(dentry->d_parent));
> +       else
> +               inode_unlock(d_inode(dentry->d_parent));
>         if (d_in_lookup(dentry)) {
>                 found =3D d_alloc_parallel(dentry->d_parent, name);
>                 if (IS_ERR(found) || !d_in_lookup(found)) {
> @@ -2332,6 +2344,10 @@ struct dentry *d_add_ci(struct dentry *dentry, str=
uct inode *inode,
>                         return ERR_PTR(-ENOMEM);
>                 }
>         }
> +       if (shared)
> +               inode_lock_shared(d_inode(dentry->d_parent));
> +       else
> +               inode_lock_nested(d_inode(dentry->d_parent), I_MUTEX_PARE=
NT);
>         res =3D d_splice_alias(inode, found);
>         if (res) {
>                 d_lookup_done(found);
> diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
> index 10894de519c3..30dddef43300 100644
> --- a/fs/ntfs/namei.c
> +++ b/fs/ntfs/namei.c
> @@ -8,6 +8,7 @@
>
>  #include <linux/exportfs.h>
>  #include <linux/iversion.h>
> +#include <linux/namei.h> // for LOOKUP_SHARED

... this won't be needed

>
>  #include "ntfs.h"
>  #include "time.h"
> @@ -310,7 +311,8 @@ static struct dentry *ntfs_lookup(struct inode *dir_i=
no, struct dentry *dent,
>                 }
>                 nls_name.hash =3D full_name_hash(dent, nls_name.name, nls=
_name.len);
>
> -               dent =3D d_add_ci(dent, dent_inode, &nls_name);
> +               dent =3D d_add_ci(dent, dent_inode, &nls_name,
> +                               !!(flags & LOOKUP_SHARED));
>                 kfree(nls_name.name);
>                 return dent;
>
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 325c2200c501..f03d832f1468 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -35,6 +35,7 @@
>  #include <linux/security.h>
>  #include <linux/iversion.h>
>  #include <linux/fiemap.h>
> +#include <linux/namei.h> // for LOOKUP_SHARED
>
>  /*
>   * Directories have different lock order w.r.t. mmap_lock compared to re=
gular
> @@ -369,7 +370,7 @@ xfs_vn_ci_lookup(
>         /* else case-insensitive match... */
>         dname.name =3D ci_name.name;
>         dname.len =3D ci_name.len;
> -       dentry =3D d_add_ci(dentry, VFS_I(ip), &dname);
> +       dentry =3D d_add_ci(dentry, VFS_I(ip), &dname, !!(flags & LOOKUP_=
SHARED));


... and this ugliness could be avoided.

Thanks,
Amir.
