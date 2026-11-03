Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793717212;
	b=mGYr4z60LIXEekdH9gByFprZdxDcLouvmy0BxW7vuyysOfZzw7yAwBZ0zFTa6YOvg+Kh
	 0CJZ3DAUbZowoI05QDaAYCy0PYUhaFohJUzLF7aPAzIG9RCfvUyIDyo0YqONE2ZQJgzD+
	 fQ4tpuyTALd4eyNV1nXfTdszDMA+xgreAEOkt2UXEAJ6NQCMdVBwSE9Ph+CAoqeoTt8Ct
	 W6yGjbJjysIfKcYQrWbgJZFFQCrF8x3pqePUdK9z9zi9pzx6sLqBU0H4oJDCeLVHZoE+T
	 aKm7vhbSomhBgImmN3pXjoIkLhLhgy9JLIW353Ek0TV+8E+b1Nevt+9KiA2PJDAmOPQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717212;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=m4ubhwdD7xWNz1fIp4dSNo/j/2+5i9zC1GJT/QlqxwA=;
	b=TSb4mXIKjQGA0BsztzV8k7ygstPsZ85i6DGWQ6XJDA38gT90oLqERZgZmp8o4rsKDYDF
	 UjBnCx5/F4N/IyX1X4R+XSheKSZC56BuEMrrUfPc160y8yG2X/icQj4rcAhJD+PZrGlWV
	 oo0VOjlFS+DOiIAYEUxWM66+KRX4frLN863uJZTuSZfhgU+4TEKr5LWz47hwk6vypQwOq
	 JSFfTc0HiIl3ku2w+wmYaeYOQ+C7AlmPXUd505KHc7XMGpzg4vd+yWrLuay89gTUR07SE
	 q3hAL+6U4VLgQvI3oIF6/GvAr8iyqhv6YhwnPbA1WjDGFaZwDUNBO06ZOMtDu/6/Rjw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YbwMCgGj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831BE606D806
	for <linux-unionfs@vger.kernel.org>; Tue,  3 Nov 2026 14:46:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 831BE606D806
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YbwMCgGj
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4cdc606b47so329746366b.0
        for <linux-unionfs@vger.kernel.org>; Tue, 03 Nov 2026 06:46:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793717211; cv=none;
        d=google.com; s=arc-20260327;
        b=Emm9AECfP9NEVMXixBqumDx56Tagu5Q9tDRbApDpbvc5TelH+xhcmJAcdihEJ9x/QZ
         mYJKKv0PaaqDoWpmtqoH8b48Phpqq/zLmf42dH6iRtAAOWQmUk+isylPPk49BNlcvKBj
         PwuWZuNZq5SxQBYWNe8oIM9HTiDp8c/T/LqzjnN2EN4J6z9OPKncSjIUJ0/CPw6RmX/T
         lSfvHDsq/geHArZKD315Fq/qOU5b0e8PUFqFPtTgQjN8660qKPWzSSSF+GaLja5R3Z7F
         WpweyMAvyF6BU9wLbpH3rK61Uy6xjmbUPQPx9VUxGb2NFEejXZdRx8KsaNxMvBcsIpEg
         XPUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=m4ubhwdD7xWNz1fIp4dSNo/j/2+5i9zC1GJT/QlqxwA=;
        fh=zb20rJ2MGVGasXhlQJB9H8OfJt/dbicTniMFMniTyn0=;
        b=PFtwx5pwZGjTA2tMUxcrddAlXzkszslqpVd6MR57fr3ZK7IfNr9R+tcOooF6Qb4axm
         iyi4My6TD3LXKS/0mJEScMGJC0OMOyH7tdIK74ijq+bOjerw9EFN/lTW8byZXWTmE6uZ
         LF5LZ1UngsO2RYiu6n9zF8aCuv0Ix9ibFZjrKBQOybe4uk7YA3BcJ+PigSmjAaXNEZj/
         2WSh8Ow0LPXrhWSimcYKeGIg6Gwe7XpiUCGORT+knfx/CjjKj6wK6KbFK32yw5Zk9j6I
         ozPcO5aJIal0mWXD2wiLwO8L2zj8nnu5/Ml7mDm7mmhuIdyGi3M7MpAMCRf8IalAPxP+
         0Efg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793717211; x=1794322011; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=m4ubhwdD7xWNz1fIp4dSNo/j/2+5i9zC1GJT/QlqxwA=;
        b=YbwMCgGjapu2U4cW1LFSOzILIQ0bSem0oNun3PccpxdXy+Yp+l6dhte7Ey/vMaRasv
         mVCO5ZvXD+lirtIbu8AZKZDQWMWGre7XuicW2XukzMqcwRpWuHLWeib913i5htOazuvi
         zegXmhzyR9p6r9sL7PocqZX1FLzZlgRVDBjn/GvzVNnuon/fhKVuJ2MVF3sZvmpjzGvL
         o34ur4RGVmC5fGWdgDIAHxLYGYZoMSlbD6+ptfoVla9YKX+loStLyPGsoe+0FmT/9r3l
         2rDUfS9GmVdLWZttUWzZBfO1l2Er+tumP46uZi2ywLaQJcbLikbfrzHH8FHw7JPMWAOM
         Vz7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793717211; x=1794322011;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m4ubhwdD7xWNz1fIp4dSNo/j/2+5i9zC1GJT/QlqxwA=;
        b=cs1p5sSxIKxw69bkNaU4cFgjZc4pZ4iglj1dcEgHTqIkR1C0RiSRSgalK/GbmI6Btj
         iTcPiK4nWW/M8gUIR2hQ8Y3jBtAGA8tHqCHQS/7neJnqPRs9Zf85nKKEeMfs5VN/ytXx
         +sWbQk6O0zYRJULrQdaYqT6cjP0NYxEFCMLOSknbA2SsRgYhE5LD8gCD0tshZrzT8jHt
         6eVQpwFDUSQSKBFv8ym2/7WNVF/yjluNVeOHjwsxQeMU9cADd/uvvyw9OXrxjEAicVzL
         qcCry/+AQN/SJpKhn3/b6S6XmizYt5RdjylXXZyZzIdL6eKyFdGlrmBXUF3xekW3ICh0
         NYFw==
X-Forwarded-Encrypted: i=1; AKwUvBwiEXLnm77ylzzA47H7v2zqmBPFGAExqXaI1KSyTOf2LUtpKkwrDiFK4saSKY/GQgdzZPpFG+G7A65xnFdi@vger.kernel.org
X-Gm-Message-State: APuU4Z9g4S/xq3ItFE5EYHRzNS/N4nCmOdrioh7SKkAPgWM3VFRU8W2b
	empFyix0/2xtT3cLjW1ZNsvkdXUrwrl/EYaVFhS8eOOUWqMYa/DL6vdNKvLkxwJMcdFuFPnTJx9
	HB5z8kocIFsBwBBvl8eTj2iIlDf7UMmM=
X-Gm-Gg: AYBFou2JFwWJzOKoxmawatp6y0UiwZeS/QRFmI2cYYF39nz1z7aKrfuHnXIN2TI/ro7
	cw/9m0i4laoUIxhw2R4NKOXBdTtrxQtz0cveSpWPbWtqXqhiF27SnWSg19MceOsFQWdLW0+9999
	IIuKj4snpVrxN1S9mxpHgR2Vv7s6IRnZiaNDpSCNhXkRa0mtghWEKHduaQY3CezaJY2jfmnBepU
	vrwxo9IWcJKoC6VYrhlZQ2J9Crr9qme3C1X/eZRSZliiw9bb1K2pFyeauMzP2Q/EPpbniD+tFZw
	epCqdygAtO6GvZ745xNWTrbXmSdjbFDg+vJTa2UkdQKt8F0vjBJ8mOmn6xC3XDzuOrJ5twN+1lH
	02N8irI7CCV2TNrJUmzb8NOqPwIkZxZYrWyxkErwL7/iUtGz8BQ4XRm+9hAE6IytedqD7Sw==
X-Received: by 2002:a17:907:1c89:b0:c46:8b51:c17c with SMTP id
 a640c23a62f3a-c4ca7a4e4b9mr1032689066b.17.1793717210181; Tue, 03 Nov 2026
 06:46:50 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <P58Wrer--F-9@tuta.io> <20261030-welpen-anbinden-nullen-b2432cee1d10@brauner>
 <CAOQ4uxjm=cGPnug18VuhKqiMvkWwLPNLO_TE3KxO8iLZG+veYQ@mail.gmail.com>
 <P5Qu3co--N-9@tuta.io> <CAOQ4uxh67+vs0mr-Lxmwz9-N+F8m29WUNz+8qFLLDpOVYB7=vg@mail.gmail.com>
 <P5WV0VL--F-9@tuta.io>
In-Reply-To: <P5WV0VL--F-9@tuta.io>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 3 Nov 2026 15:46:38 +0100
X-Gm-Features: AclHuK-AkbE76i1M2E19O6SFPWAt7p_ENORS0HKIxbE5f-oUtF7Cy50LrWBo2WE
Message-ID: <CAOQ4uxjYX+A_xRBmfj40hmAcuQXwW4JPUmhJ9bx5ymSr0QoDnw@mail.gmail.com>
Subject: Re: [PATCH v3] fs: let backing files inherit FMODE_NONOTIFY from the
 user file
To: Edvard Conrad <edvard@tuta.io>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 3, 2026 at 2:01=E2=80=AFPM Edvard Conrad <edvard@tuta.io> wrote=
:
>
> On Mon, Nov 2, 2026 at 1:34 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > Good catch!
> > Please test the attached v2 patch and post the new test cases.
>
> v2 fixes the merged directory. An impure directory still deadlocks the
> same way: ovl_iterate_real() reads it through ovl_cache_get_impure() and
> ovl_dir_read_impure(), which v2 leaves without the user file, so
> ovl_dir_read() opens the upper directory with plain ovl_path_open():
>
>   fanotify_handle_event
>   fsnotify
>   fsnotify_open_perm_and_set_mode
>   do_dentry_open
>   vfs_open
>   dentry_open
>   ovl_iterate_real
>   ovl_iterate
>   iterate_dir
>   __x64_sys_getdents64
>
> That takes an upper-only directory that a lower file was renamed into,
> on layers that share a filesystem, so ovl_need_adjust_d_ino() sends it
> to ovl_iterate_real(). Passing the file down the same way v2 does for
> the merged case fixes it for me, on top of v2:
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -670,7 +670,7 @@ static bool ovl_fill_plain(struct dir_context *ctx, c=
onst char *name,
>  }
>
>  static int ovl_dir_read_impure(const struct path *path,  struct list_hea=
d *list,
> -                              struct rb_root *root)
> +                              struct rb_root *root, const struct file *u=
ser_file)
>  {
>         int err;
>         struct path realpath;
> @@ -678,6 +678,7 @@ static int ovl_dir_read_impure(const struct path *pat=
h,  struct list_head *list,
>         struct ovl_readdir_data rdd =3D {
>                 .ctx.actor =3D ovl_fill_plain,
>                 .ctx.count =3D INT_MAX,
> +               .user_file =3D user_file,
>                 .list =3D list,
>                 .root =3D root,
>         };
> @@ -714,9 +715,10 @@ static int ovl_dir_read_impure(const struct path *pa=
th,  struct list_head *list,
>         return 0;
>  }
>
> -static struct ovl_dir_cache *ovl_cache_get_impure(const struct path *pat=
h)
> +static struct ovl_dir_cache *ovl_cache_get_impure(struct file *file)
>  {
>         int res;
> +       const struct path *path =3D &file->f_path;
>         struct dentry *dentry =3D path->dentry;
>         struct inode *inode =3D d_inode(dentry);
>         struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
> @@ -735,7 +737,7 @@ static struct ovl_dir_cache *ovl_cache_get_impure(con=
st struct path *path)
>                 return ERR_PTR(-ENOMEM);
>
>         cache->is_refcounted =3D false;
> -       res =3D ovl_dir_read_impure(path, &cache->entries, &cache->root);
> +       res =3D ovl_dir_read_impure(path, &cache->entries, &cache->root, =
file);
>         if (res) {
>                 ovl_cache_free(&cache->entries);
>                 kfree(cache);
> @@ -856,7 +858,7 @@ static int ovl_iterate_real(struct file *file, struct=
 dir_context *ctx)
>         dput(parent);
>
>         if (ovl_is_impure_dir(file)) {
> -               rdt.cache =3D ovl_cache_get_impure(&file->f_path);
> +               rdt.cache =3D ovl_cache_get_impure(file);
>                 if (IS_ERR(rdt.cache))
>                         return PTR_ERR(rdt.cache);
>         }
>

Right, I was being sloppy.
Thanks for the fixes.
I added Co-developed-by to attribute your contributions to this fix.

> Results in a VM on 6b4b543fa18, each kernel run once and with -i 2,
> with the backing filesystem marked:
>
>                                 file  dir   merged dir  impure dir
>                                             listed      listed
>   + c3d355f427ce                PASS  FAIL  FAIL        FAIL
>   + your v1                     PASS  PASS  FAIL        FAIL
>   + your v2                     PASS  PASS  PASS        FAIL
>   + v2 and the diff above       PASS  PASS  PASS        PASS
>
> The new cases are posted on top of the directory cases:
>   https://lore.kernel.org/ltp/P5WKBbq--F-9@tuta.io/

Thanks again!
Amir.
