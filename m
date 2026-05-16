Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECF2309F1D
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 21:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778965883; cv=pass; b=lZ8jIuAXifI8lhNVhc3pdSEk+Uv7Xo2maP/NEigzSRklZY3/0NcRhSXKR27HWld4C8ReFm5YxrOf2G7+CK0p9DPD8UVlMv/1ikqx2dXUc2bYUES61Qvum07ySEBJkrS7vlUM0lv8dagEoXRb1PIOsrIPYAi2H3rvHGQf5DlItjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778965883; c=relaxed/simple;
	bh=9T8MAV/Z2BYbzVEpWDGwPL5OUR1k3CrVy9RXTdnURcw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fWtzbxh2bmhKQR8350Svv4J0qdlDHphzwJzr3w5aLHIkN3SvzVERB9/BQieILUHPW9msB6wnb5fJs4DfhwKKFloZ7mEKLgWOSGmTXv6TECrixPRKACsQzdZKbGq+a4XXeeuUw858dy3+H9j2jSOmIL1zYcllcgVlk91VbvFokwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=emlDZKTK; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="emlDZKTK"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-67e9b3037dcso2440970a12.0
        for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 14:11:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778965880; cv=none;
        d=google.com; s=arc-20240605;
        b=iAR9EPBCK2xsZzVlulXqyef3k+2T+92EX8lYUSwAvdv3jmZGprsLndwi+0jeMRJm8A
         Gi7osZN4105kpBkQ++Grd3TjdiRJk6V7Hu6EUPGNTEkgb1s49aEG/l7TbOjCqbS9q89/
         4tiI3fHTTqol4Dr/JXDYRdr3/HJfzdWt7LaBU8J2Jur1VloQdK3Dgb1SKmdTlZ/6Srg0
         iS8/mjc/CuZliyUswLXkGoFoJYcMFBzO7mxaHUiX7B4FsEBKHop82kYJFU7tXOTLQa4i
         bF5YTdKVct6RX8tgd6nNqWkFlkj9EnaW+mQLkAEDxsmRCX4Ah9+RR6s1w68Gxc5d7THY
         TVUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A67ysE5XxeeBf0jTTxAj4hj+KgoULsWJJUl85Gg0jXc=;
        fh=m7U2RKpxYComumi5/+QvEiNdn84QZdNzCd2r8FBbHd4=;
        b=W1Qb9aTpJgTThyTW4K82gTUdCZ1GQ5gyrhwUfDQbPQVzn+gKFGt9cvqvvfTUXIsaSo
         3FGdzakmGSUtJwGm+mM71WtnSCx9fNfbWRVG6E3st5Vp73Om6VrVi9GZT5fiLj/BU/cR
         Wl4orzCtinpULyl7xblq4yiTsp1gYNGOzpoKh08Fgc8xsaLDopbBQTGV9FSHbvHg+i8W
         0CkEizJD7zQlAy4jlc5tQU1EN62TVr2jgUPVjKzaMzvIQcfJJqXKOh+phjpWsjZ4z8Jf
         gaQjyoPPyloeT4jFXjIA9NXo0dSlzPxc21HgqQoIf4zSTio7SR/BxxwiSNbWDBZva0ot
         bgLg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778965880; x=1779570680; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A67ysE5XxeeBf0jTTxAj4hj+KgoULsWJJUl85Gg0jXc=;
        b=emlDZKTKmX1N+XMK1eMLp6g2FFUr27TI4v0UlOKxljwdXgn6GAVWR0y5vrlQVxVvo+
         tlx2HgRw+aygkd2LLW1d5xogJcGD55yNwlZge1rxjVIlY4/6Rcn7i+lADChIu16Ai1zR
         DV4ImeNk8wOqBy/OdKUJhKRKkSgOuS4uaeQlyHeFah781Bebrc2J2x5tv3Gta4PqiBf1
         3vR97243DpXcnizJgmHdTfK5J+mWhjvtObHWrjc6BegqIgl0kzw+2kkdiE5/HRFFPlF5
         ktBRNyfVOr31csh9hZWmxIF7QRciwCQa7KS1Llbh/hglSWxR/RxgjQ32yY+zcWq94kxD
         BPWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778965880; x=1779570680;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A67ysE5XxeeBf0jTTxAj4hj+KgoULsWJJUl85Gg0jXc=;
        b=MlNjCjowN05mu7/NtIS4igMmFO/1RNo1KOM8hMINmTfHAlvagSQTWtqzJtHXMTbAw4
         RKz+cVHYi/D1CCQRLHcyvlA0qqr1bfuJyTcggBn+gZEYLyinFGTk96KZ2g/9sE6H4PiA
         3DiUVoIap5yRzKZdf1eeBP7zjNQ3sckIl5mNDnBp5UlTUWqRfve7uBdD0alFy+SBTznl
         iRnaMNBizG8DL4+uNenD9RhwJ3SY4vMZmmM00btjgx1G4HnsD96I9SUVZx+tu1QMnr2p
         YQVd5bxW5hgzPXtWc4etd8VnCQu8vsYWMERM/NQAmmXtQYGqYUE3X34dlcbrRQvEOH0a
         QkbA==
X-Forwarded-Encrypted: i=1; AFNElJ+ZWCx4RRN7VtuGdNsmqJOU3nAQ85pdHWluCOikbguXj2TDOweYqImm7JJMAeKqONDqN3nWYkMTHlebeI9/@vger.kernel.org
X-Gm-Message-State: AOJu0Yym3yYyT1BDmBUB2zE8x4HDJ0y/QJE3QRcdB1iSJDlvHmCmBN3t
	XbUfYwdZ3G1k09baJGAoipQGZnGX4FMzr78o16gQ4hr1MqorHVewp4hswNnQytyPrtVEXTKLwIO
	qVlI2cyt+W4G+gJGxH+85OLRlkPx+/gQ=
X-Gm-Gg: Acq92OFlJZm09HgaDaNfhL6cEW3qmuVLRKQBPo9evcop5MhiBfrOt7xXDGd9yBaXFYl
	hSa6F2cijCS61PR7MOk7FYK9wgBPz+biybPqv4DA2QDY5yLToAnA4JNEwlwuKl0x50B9xFDmHSc
	H7D2Wb6VM/AmO3jb2zx5eEmbrLdyldRgwi7Bo+9HZ+owcPTYZKBwi4JbEk3eJahfZajN4uWw9BA
	yX5TR37rSWbiBtsXAiouvUfzN9zc1lTeQs0/1Gp0HEyUCah7vLpKRp3LV9NcPxn/Dj/b5CIKpPS
	5E0SmcumtNpyk+uBYmqAqb3kARBl9ziJetZaU/vMPQ==
X-Received: by 2002:aa7:c4e7:0:b0:670:8b38:5717 with SMTP id
 4fb4d7f45d1cf-683bd581a49mr3172816a12.24.1778965880352; Sat, 16 May 2026
 14:11:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com> <20260516004004.1455526-14-joannelkoong@gmail.com>
In-Reply-To: <20260516004004.1455526-14-joannelkoong@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 16 May 2026 23:11:09 +0200
X-Gm-Features: AVHnY4LCjD0_KqRUS8AYSJ6OzCvtLsjxvgjLkCCJMTZAdXldvCwAbtEG5cVDU24
Message-ID: <CAOQ4uxhTzoDwrzf-7Zjg+NMO=m2Zqm4du83endsNzejbt1iHqA@mail.gmail.com>
Subject: Re: [PATCH v2 13/21] fuse: add passthrough lookup
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 2:52=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Use the new/extended struct fuse_entry2_out for lookups. If a backing id
> is set, associate the fuse inode with the backing inode that should be
> used for passthrough operations.
>
> If no backing id was set, cache the statx attributes from the reply.

The 3 lookup patches look fine in general, but I will review them more
closely after I have a clear understanding on the desired protocol.

Thanks,
Amir.

>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/fuse/dir.c | 66 ++++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 52 insertions(+), 14 deletions(-)
>
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index b7a9d2b0476a..3a6adae530da 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -420,10 +420,10 @@ static void fuse_entry2_to_entry(struct fuse_entry2=
_out *outarg2,
>         outarg->attr.flags =3D outarg2->flags;
>  }
>
> -static __maybe_unused int fuse_process_entry2(struct fuse_conn *fc,
> -                                             struct fuse_entry2_out *out=
arg2,
> -                                             struct fuse_entry_out *outa=
rg,
> -                                             struct fuse_statx **sxp)
> +static int fuse_process_entry2(struct fuse_conn *fc,
> +                              struct fuse_entry2_out *outarg2,
> +                              struct fuse_entry_out *outarg,
> +                              struct fuse_statx **sxp)
>  {
>         if (!fuse_use_entry2(fc))
>                 return 0;
> @@ -469,7 +469,9 @@ static int fuse_dentry_revalidate(struct inode *dir, =
const struct qstr *name,
>         struct fuse_entry_out outarg;
>         struct fuse_entry2_out outarg2;
>         struct fuse_forget_link *forget;
> +       struct fuse_statx *sx =3D NULL;
>         FUSE_ARGS(args);
> +       int backing_id =3D 0;
>         u64 attr_version;
>         bool need_reval;
>         int ret;
> @@ -512,15 +514,27 @@ static int fuse_dentry_revalidate(struct inode *dir=
, const struct qstr *name,
>
>         fuse_lookup_init(fc, &args, get_node_id(dir), name, &outarg, &out=
arg2);
>         ret =3D fuse_simple_request(get_fuse_mount(inode), &args);
> +       if (!ret)
> +               backing_id =3D fuse_process_entry2(fc, &outarg2, &outarg,=
 &sx);
>         if (ret || !outarg.nodeid) {
>                 kfree(forget);
>                 return (ret =3D=3D -ENOMEM || ret =3D=3D -EINTR) ? ret : =
0;
>         }
>
> +       if (backing_id < 0) {
> +               ret =3D backing_id;
> +               goto forget;
> +       }
> +
> +       ret =3D 0;
>         if (outarg.nodeid !=3D get_node_id(inode) ||
> -           !!IS_AUTOMOUNT(inode) !=3D !!(outarg.attr.flags & FUSE_ATTR_S=
UBMOUNT)) {
> -               fuse_chan_queue_forget(fc->chan, forget, outarg.nodeid, 1=
);
> -               return 0;
> +           !!IS_AUTOMOUNT(inode) !=3D !!(outarg.attr.flags & FUSE_ATTR_S=
UBMOUNT))
> +               goto forget;
> +
> +       if (backing_id) {
> +               ret =3D fuse_inode_set_passthrough(inode, backing_id);
> +               if (ret)
> +                       goto forget;
>         }
>
>         kfree(forget);
> @@ -534,10 +548,14 @@ static int fuse_dentry_revalidate(struct inode *dir=
, const struct qstr *name,
>                 return 0;
>
>         forget_all_cached_acls(inode);
> -       fuse_change_attributes(inode, &outarg.attr, NULL, ATTR_TIMEOUT(&o=
utarg),
> +       fuse_change_attributes(inode, &outarg.attr, sx, ATTR_TIMEOUT(&out=
arg),
>                                attr_version);
>         fuse_change_entry_timeout(entry, &outarg);
>         return 1;
> +
> +forget:
> +       fuse_chan_queue_forget(fc->chan, forget, outarg.nodeid, 1);
> +       return ret;
>  }
>
>  static int fuse_dentry_init(struct dentry *dentry)
> @@ -631,6 +649,8 @@ int fuse_lookup_name(struct super_block *sb, u64 node=
id, const struct qstr *name
>         struct fuse_forget_link *forget;
>         u64 attr_version, evict_ctr;
>         struct fuse_entry2_out outarg2;
> +       struct fuse_statx *sx =3D NULL;
> +       int backing_id;
>         int err;
>
>         *inode =3D NULL;
> @@ -649,9 +669,18 @@ int fuse_lookup_name(struct super_block *sb, u64 nod=
eid, const struct qstr *name
>
>         fuse_lookup_init(fm->fc, &args, nodeid, name, outarg, &outarg2);
>         err =3D fuse_simple_request(fm, &args);
> +       if (err)
> +               goto out_put_forget;
> +
> +       backing_id =3D fuse_process_entry2(fm->fc, &outarg2, outarg, &sx)=
;
> +
>         /* Zero nodeid is same as -ENOENT, but with valid timeout */
> -       if (err || !outarg->nodeid)
> +       if (!outarg->nodeid)
>                 goto out_put_forget;
> +       if (backing_id < 0) {
> +               err =3D backing_id;
> +               goto out_send_forget;
> +       }
>
>         err =3D -EIO;
>         if (fuse_invalid_attr(&outarg->attr))
> @@ -662,19 +691,28 @@ int fuse_lookup_name(struct super_block *sb, u64 no=
deid, const struct qstr *name
>         }
>
>         *inode =3D fuse_iget(sb, outarg->nodeid, outarg->generation,
> -                          &outarg->attr, NULL, ATTR_TIMEOUT(outarg),
> +                          &outarg->attr, sx, ATTR_TIMEOUT(outarg),
>                            attr_version, evict_ctr);
>         err =3D -ENOMEM;
> -       if (!*inode) {
> -               fuse_chan_queue_forget(fm->fc->chan, forget, outarg->node=
id, 1);
> -               goto out;
> -       }
> +       if (!*inode)
> +               goto out_send_forget;
> +
>         err =3D 0;
> +       if (backing_id) {
> +               err =3D fuse_inode_set_passthrough(*inode, backing_id);
> +               if (err) {
> +                       iput(*inode);
> +                       *inode =3D NULL;
> +               }
> +       }
>
>   out_put_forget:
>         kfree(forget);
>   out:
>         return err;
> + out_send_forget:
> +       fuse_chan_queue_forget(fm->fc->chan, forget, outarg->nodeid, 1);
> +       return err;
>  }
>
>  static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entr=
y,
> --
> 2.52.0
>
