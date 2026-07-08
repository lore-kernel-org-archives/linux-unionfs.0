Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C6E425CCE
	for <linux-unionfs@vger.kernel.org>; Wed,  8 Jul 2026 10:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783507262; cv=pass; b=Esa7sC9rVScpU55RtlD+1HeLrlPdN2+EQwFEW4A0uvLMXMr8qx8RnlyTpkz2SVMQhq/FDiPmPLaLGuF6/eb0OKKzydJY7JR5e4FS2xxbheMOO5sLSthl0ywOUwtQ/StqHbH6t+O10y8M/AFGvfLjSM6tWn5N5W0q9WnJtZ6UxK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783507262; c=relaxed/simple;
	bh=YkkGe5+JQA+vJObF5DUbAYhqbFN0cqoNHaJUhIWNGZg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oU/LEMUln7ib2dTIaGt5nELsoMYYIy+B7Mm154TJ5GGDoWOHy6uLmrwAq8OgITEBA/UjA+FRPqjlRcDaB+EfVgx1s+Tf+5f1UmzFnSSGSAH1jRGk171K80EvM2VOlO8uDhFxmaBjMqXyyvYkgj3T6F3j91BdpZj8wyzjAAalOQ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JWPgTIBj; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JWPgTIBj"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c15d5468673so42598966b.0
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Jul 2026 03:40:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783507244; cv=none;
        d=google.com; s=arc-20260327;
        b=M7SkMF1lqeDcyuvqF7tcmOCRSQ7RC5q5igPM8AC3bWCJFyslzmCWPb0agGQbr6sV6J
         RU8OmBcu/saCDQUTaoQq8k1Ql4hrrtqS1b/c5WNZTBuUpP9jBqsRXhTXZQiFyta5IQcN
         +1lFtpkqR0pJGv7B652CWFH+v58vDTG7ZXxyOKnUOLHuT+AhvlvVg8KhzcRBPMcMdBDq
         BS/tixQ4AorlNW+QVGsl18gYtareLbpb66zEcR5+rE6WrjTxYfYf/2KHBpZv18M9dkrW
         Zz/6blI01w6STfAL7ii4uSoe9XXsQ+T0KGtZrksT0nHAQeMmt5BrtwBMgzqguqiehK8H
         RPvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TMS3BvgnCcgwdn5c17yD5wqD6fSZDjz9Zq6YQZIe6A4=;
        fh=Ufzh78iyDnVnNfQOM64HzEO7sSck1uAnL38ZnXbYE3Y=;
        b=ixs+jMzGk2Rk4Gerd/Wr+DxFuiBuOz/mEi0crMPtAcWK5oEaMNhgLY7H8AqmLH3rGN
         GDpAlWmoaxIh6QkACVIHNYod072qzuipSr58NzwLZxPG6dbJJde5z7yYI1I5yGv0MU1e
         X8V+NF3M3KI+E87b8bEcOj2d9RpXNZ3EILtbpdoU2+ZO/VUc91FPC3Vo+rTCYfjuEvpK
         jMGdb8MKjdbrxHPIm2MwCbF6ZWUE+o8C+x6ZbgSIzSQ/16ut7Z2A4m+58Lt/KFypXi35
         QSjXxwJC4eBmygwFhWEY6t4DUHF5UncV0i9YfUzo/blBG6+JiUIqkhcxdahmHXPCaT0Z
         C+pw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783507244; x=1784112044; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TMS3BvgnCcgwdn5c17yD5wqD6fSZDjz9Zq6YQZIe6A4=;
        b=JWPgTIBjNAmz3/RflHP+mbzUPLCY7Z3oHcYQOXOIaPp9zbq1xqO+AlYE2OOyYCNazk
         kj2fKXR1xNk9mSzxg6jTEXFTQ4Hb2nNplvaMoZsn8gU6adwx0f7KhLlPZ6XshsJ2tL1g
         pG34JjgWEau6WL+wEpZZVDL+vIKVHH7iI1iOMV33afWJJ2VGGwGE6TGuKENbYRljNtGw
         KbusTnkI+bVmb8TvZ2S/c4S20zv2krfyecuZ/4sdP9KgE58KDVTUD/7+03rBaNyD6Rv8
         a8yW/AE+E9k68eNVZo6Kyrwso4n5/kXelFnGd9kwzhSpwUqz1Hr/qL14xamAQcmEP5mt
         KOqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783507244; x=1784112044;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TMS3BvgnCcgwdn5c17yD5wqD6fSZDjz9Zq6YQZIe6A4=;
        b=B9pPrPBPmz6IJ5E1M8KiacFMCC2swIQoxIsErTnyb7od07VijDDgBpBQ/7yB+9+grb
         swWspQH9/pTu01/YITe5JoBW6slfG7gLfFJZmLBPLO2jzhWtNiwtfZG7KOFbfPi5dZvM
         bJeZI+4poxG1e65N3BHXQ4/z4QqGavAneOt1wc6X4OYewPhPRKM9CTHhIjfF5PU+QGIQ
         kGs0m+YqIwTuGcYCqquj2MkvTkkPfLRVPjmB3yOEd29x9JtgsWh4cVksIqtaoHcuN7aC
         RSGkTfE7RnnQzqZVkgCpRUufgKX5j4tVna1IRFwO1t1NP9i0jASDp6jjlvxvMTpUP+86
         hYaQ==
X-Gm-Message-State: AOJu0YwWu9m5UTnFQoFwDlbVwr/5+ZPLL/tZbkf+r2UD9fT/6fOGgci7
	Sky9F5ctYrZn/eUgNLaPKujiC8VLHv20VNSlhDtpGB13so+Xoo2F9wOuzuT1Nwm6cIuEttg4BtM
	ikNMyycEto5nyv8JLYIVIXBA8cCAG2Uk=
X-Gm-Gg: AfdE7clo5PRDPzyZVI0VzFGL2fUNsX0OPTzaGX+ZREB4rIX/Rdb44rvF5FXlxMC46oc
	2XYBlUgP78S0kvsIuUzKCaDIzndWHc/75N832mdDz/6G6psEQ7sH9DInAfq1dbYWN55A5TXb0F7
	i7+CAbjdiJ6JtH26s4Tpcz0GQbS827OK8OLDa6aXSf/2U7turJTGrzUATbaL5YXdg3qcLgU1T5E
	OgiWS1CWHSt56mJCBh53LmeGrm1b0EdpKG+J0NaqYYrtJDNfbCtjFDCwxdYBTriavdlEe6ibA==
X-Received: by 2002:a17:906:9910:b0:c12:5013:4b7e with SMTP id
 a640c23a62f3a-c15cdff24b9mr66328566b.18.1783507243458; Wed, 08 Jul 2026
 03:40:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260708095831.3381978-1-gscrivan@redhat.com>
In-Reply-To: <20260708095831.3381978-1-gscrivan@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 8 Jul 2026 12:40:31 +0200
X-Gm-Features: AVVi8CcOKTeSBqLQLrnrLgyZEIJXQKqNBrz3IPXb57fTGPuMcujvpl0alTuGlcs
Message-ID: <CAOQ4uxjC2JZ94r3dxJzHFFpder66biPxN-2Yy0ZeqDSyNooaPA@mail.gmail.com>
Subject: Re: [PATCH] ovl: add ioctls to retrieve layer file descriptors
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 8, 2026 at 12:00=E2=80=AFPM Giuseppe Scrivano <gscrivan@redhat.=
com> wrote:
>
> Add two ioctls to overlay filesystem to allow userspace to retrieve
> information about the overlay layers:
>
> OVL_IOC_OPEN_LAYER:     return an O_PATH fd to the root of a layer.
>                         arg =3D=3D 0 returns the upper layer (-ENOENT if
>                         no upper is configured), arg >=3D 1 returns
>                         lower layers (-ENOENT if index is out of
>                         range).
> OVL_IOC_GET_LAYERS_INFO: copy a struct ovl_layers_info to userspace
>                         with numlower, numlowerdata, and has_upper.
>
> The ioctls work on any overlayfs file or directory and require
> CAP_SYS_ADMIN in the mounter's user namespace.
>
> The UAPI constants and struct are defined in include/uapi/linux/overlay.h=
.
>
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
> ---
>  MAINTAINERS                  |  1 +
>  fs/overlayfs/file.c          |  2 ++
>  fs/overlayfs/overlayfs.h     |  4 +++
>  fs/overlayfs/ovl_entry.h     |  2 ++
>  fs/overlayfs/params.c        | 10 ++++++
>  fs/overlayfs/params.h        |  1 +
>  fs/overlayfs/readdir.c       |  2 ++
>  fs/overlayfs/super.c         | 70 ++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/overlay.h | 30 ++++++++++++++++
>  9 files changed, 122 insertions(+)
>  create mode 100644 include/uapi/linux/overlay.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 25453040dffb..b64c696686e4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -20368,6 +20368,7 @@ S:      Supported
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.g=
it
>  F:     Documentation/filesystems/overlayfs.rst
>  F:     fs/overlayfs/
> +F:     include/uapi/linux/overlay.h


overlayfs.h please

>
>  P54 WIRELESS DRIVER
>  M:     Christian Lamparter <chunkeey@googlemail.com>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 27cc07738f33..fc9c448c5959 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -649,4 +649,6 @@ const struct file_operations ovl_file_operations =3D =
{
>         .copy_file_range        =3D ovl_copy_file_range,
>         .remap_file_range       =3D ovl_remap_file_range,
>         .setlease               =3D generic_setlease,
> +       .unlocked_ioctl         =3D ovl_ioctl,
> +       .compat_ioctl           =3D compat_ptr_ioctl,
>  };
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index b75df37f70ac..10f7ef8cb78c 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -8,6 +8,7 @@
>  #include <linux/uuid.h>
>  #include <linux/fs.h>
>  #include <linux/fsverity.h>
> +#include <uapi/linux/overlay.h>
>  #include <linux/namei.h>
>  #include <linux/posix_acl.h>
>  #include <linux/posix_acl_xattr.h>
> @@ -908,6 +909,9 @@ void ovl_tempname(char name[OVL_TEMPNAME_SIZE]);
>  struct dentry *ovl_create_temp(struct ovl_fs *ofs, struct dentry *workdi=
r,
>                                struct ovl_cattr *attr);
>
> +/* super.c */
> +long ovl_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
> +
>  /* file.c */
>  extern const struct file_operations ovl_file_operations;
>  int ovl_real_fileattr_get(const struct path *realpath, struct file_kattr=
 *fa);
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 80cad4ea96a3..b8f4bca89a27 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -35,6 +35,8 @@ struct ovl_layer {
>         struct vfsmount *mnt;
>         /* Trap in ovl inode cache */
>         struct inode *trap;
> +       /* Keeps the original fsmount file alive for OVL_IOC_OPEN_LAYER *=
/
> +       struct file *origin;

as Miklos wrote, keep the file is an overkill

>         struct ovl_sb *fs;
>         /* Index of this layer in fs root (upper idx =3D=3D 0) */
>         int idx;
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index c93fcaa45d4a..92d1a56178f2 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -482,6 +482,11 @@ static int ovl_parse_layer(struct fs_context *fc, st=
ruct fs_parameter *param,
>                         return PTR_ERR(layer_name);
>
>                 err =3D ovl_do_parse_layer(fc, layer_name, &layer_path, l=
ayer);
> +               if (!err && !is_upper_layer(layer)) {
> +                       struct ovl_fs_context *ctx =3D fc->fs_private;
> +
> +                       ctx->lower[ctx->nr - 1].origin =3D get_file(param=
->file);
> +               }
>                 break;
>         }
>         default:
> @@ -504,6 +509,9 @@ static void ovl_reset_lowerdirs(struct ovl_fs_context=
 *ctx)
>                 path_put(&l->path);
>                 kfree(l->name);
>                 l->name =3D NULL;
> +               if (l->origin)
> +                       fput(l->origin);
> +               l->origin =3D NULL;
>         }
>         ctx->nr =3D 0;
>         ctx->nr_data =3D 0;
> @@ -856,6 +864,8 @@ void ovl_free_fs(struct ovl_fs *ofs)
>         mounts =3D (struct vfsmount **) ofs->config.lowerdirs;
>         for (i =3D 0; i < ofs->numlayer; i++) {
>                 iput(ofs->layers[i].trap);
> +               if (ofs->layers[i].origin)
> +                       fput(ofs->layers[i].origin);
>                 kfree(ofs->config.lowerdirs[i]);
>                 mounts[i] =3D ofs->layers[i].mnt;
>         }
> diff --git a/fs/overlayfs/params.h b/fs/overlayfs/params.h
> index ffd53cdd8482..1d8fe8fbaca2 100644
> --- a/fs/overlayfs/params.h
> +++ b/fs/overlayfs/params.h
> @@ -22,6 +22,7 @@ struct ovl_opt_set {
>  struct ovl_fs_context_layer {
>         char *name;
>         struct path path;
> +       struct file *origin;
>  };
>
>  struct ovl_fs_context {
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index e7fe29cb6028..7bab71c8bcc2 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -1069,6 +1069,8 @@ const struct file_operations ovl_dir_operations =3D=
 {
>         .iterate_shared =3D shared_ovl_iterate,
>         .llseek         =3D ovl_dir_llseek,
>         .fsync          =3D ovl_dir_fsync,
> +       .unlocked_ioctl =3D ovl_ioctl,
> +       .compat_ioctl   =3D compat_ptr_ioctl,
>         .release        =3D ovl_dir_release,
>         .setlease       =3D generic_setlease,
>  };
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 60f0b7ceef0a..d143002e74b2 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1107,6 +1107,8 @@ static int ovl_get_layers(struct super_block *sb, s=
truct ovl_fs *ofs,
>                  */
>                 mnt->mnt_flags |=3D MNT_READONLY | MNT_NOATIME;
>
> +               layers[ofs->numlayer].origin =3D l->origin;
> +               l->origin =3D NULL;
>                 layers[ofs->numlayer].trap =3D trap;
>                 layers[ofs->numlayer].mnt =3D mnt;
>                 layers[ofs->numlayer].idx =3D ofs->numlayer;
> @@ -1568,6 +1570,74 @@ int ovl_fill_super(struct super_block *sb, struct =
fs_context *fc)
>         return err;
>  }
>
> +static long ovl_ioctl_open_layer(struct file *filp, unsigned long arg)
> +{
> +       struct super_block *sb =3D file_inode(filp)->i_sb;
> +       struct ovl_fs *ofs =3D OVL_FS(sb);
> +       struct path root;
> +       struct file *f;
> +       int fd;
> +
> +       if (arg >=3D ofs->numlayer)
> +               return -ENOENT;
> +       if (arg =3D=3D 0 && !ovl_upper_mnt(ofs))
> +               return -ENOENT;
> +       if (!ofs->layers[arg].origin)
> +               return -EOPNOTSUPP;
> +
> +       root.mnt =3D mntget(ofs->layers[arg].origin->f_path.mnt);
> +       root.dentry =3D dget(root.mnt->mnt_root);
> +
> +       fd =3D get_unused_fd_flags(O_CLOEXEC);
> +       if (fd < 0) {
> +               path_put(&root);
> +               return fd;
> +       }
> +
> +       f =3D dentry_open(&root, O_PATH | O_NOFOLLOW, current_cred());
> +       path_put(&root);
> +       if (IS_ERR(f)) {
> +               put_unused_fd(fd);
> +               return PTR_ERR(f);
> +       }
> +
> +       fd_install(fd, f);
> +       return fd;
> +}
> +
> +static long ovl_ioctl_get_layers_info(struct file *filp, unsigned long a=
rg)
> +{
> +       struct super_block *sb =3D file_inode(filp)->i_sb;
> +       struct ovl_fs *ofs =3D OVL_FS(sb);
> +       struct ovl_layers_info info =3D {
> +               .numlower =3D ofs->numlayer - 1,
> +               .numlowerdata =3D ofs->numdatalayer,
> +               .has_upper =3D !!ovl_upper_mnt(ofs),
> +       };
> +
> +       if (copy_to_user((void __user *)arg, &info, sizeof(info)))
> +               return -EFAULT;
> +
> +       return 0;
> +}
> +
> +long ovl_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> +{
> +       struct ovl_fs *ofs =3D OVL_FS(file_inode(filp)->i_sb);
> +
> +       if (!ns_capable(ofs->creator_cred->user_ns, CAP_SYS_ADMIN))
> +               return -EPERM;
> +
> +       switch (cmd) {
> +       case OVL_IOC_OPEN_LAYER:
> +               return ovl_ioctl_open_layer(filp, arg);
> +       case OVL_IOC_GET_LAYERS_INFO:
> +               return ovl_ioctl_get_layers_info(filp, arg);
> +       default:
> +               return -ENOTTY;
> +       }
> +}
> +
>  struct file_system_type ovl_fs_type =3D {
>         .owner                  =3D THIS_MODULE,
>         .name                   =3D "overlay",
> diff --git a/include/uapi/linux/overlay.h b/include/uapi/linux/overlay.h
> new file mode 100644
> index 000000000000..c92ccecd9e21
> --- /dev/null
> +++ b/include/uapi/linux/overlay.h

overlayfs.h please

> @@ -0,0 +1,30 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI_LINUX_OVERLAY_H
> +#define _UAPI_LINUX_OVERLAY_H
> +
> +#include <linux/ioctl.h>
> +#include <linux/types.h>
> +
> +/**
> + * struct ovl_layers_info - overlay layer configuration summary
> + * @numlower:     number of lower (metadata) layers
> + * @numlowerdata: number of data-only lower layers
> + * @has_upper:    1 if an upper layer is configured, 0 otherwise
> + */
> +struct ovl_layers_info {
> +       __u32 numlower;
> +       __u32 numlowerdata;
> +       __u32 has_upper;
> +};

Whether this stays as ioctl or statmount blob

please use:

__u32 flags;
__u32 pad;

and use a flag for has_upper so we can extend this data struct in the futur=
e.

Thanks,
Amir.
