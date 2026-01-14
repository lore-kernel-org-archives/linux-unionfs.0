Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816DF32D0DE
	for <linux-unionfs@vger.kernel.org>; Wed, 14 Jan 2026 17:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768413293; cv=none; b=J9yOONZhaV2MWiR3fyYdPOs87wAC3QIm3jx90hBlHEOH4b3izuCkqk2oqEEr6YPx8oZIyiiB4Q3SxTtrtNngAIUh7sHnahQWAaeyQBh8e/ao+qAo0Z7z0v+VUpWipPYXeH9zUZ/GuRsh09vqE4Usm1310yoijFIo+FbEr0hL6y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768413293; c=relaxed/simple;
	bh=ri6XdCQOo82mlaJDsd+QmjUF07km5DczjkYwbJrj+3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L4cgRHftrKWcVU4+MBL8pwjygv05xDpuxQ17i3mExvwq27NNj2mA/rEzMjPgzJQaZrSnJVNzhasmHzKhpetznbF4NpURnXWcqP8cbcZbZhvBsIWs7f34HEBACt7ViVQn695g2178F1uiB7nY28wWYyXHsxdEUoZ8sIgffJhShEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D96vrZPV; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D96vrZPV"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b876bf5277dso126037366b.0
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jan 2026 09:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768413290; x=1769018090; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7JRxCvP4g5SpKNn0OXYTsa9XAVvPE6OA4ZzPHkT0Yco=;
        b=D96vrZPVd1Hu2aUVU0IU+r4oqOYsdqtv6md/7d7E44q7bwze1IwHI1ly0EI7BAtyQZ
         ++AeCxY1VkY7tke0rvuAS5oU+fttP/7/IoEk1PQcYh5Q4w7KItRlGsZdlzH746I3Imfn
         ITygMLQb5EOd1iAi+voF0elp/huUZ0zL1xzoTM7P4wTU7BOSZvVQEbEnBkdgCgaynITO
         IP8y7i2A9TUSZd6vcmIVWM6JVHMk2lAcmXQKdbK2UhR/DOhjgS/s9VBZvuvKUBWDRHnC
         kcXmpRLKbB6uGJ5E8aTrhoCX+PuczveFn6BAUE69KUbuiOeXzYdW/mWtxUjFoNhaUsxP
         lWjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768413290; x=1769018090;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7JRxCvP4g5SpKNn0OXYTsa9XAVvPE6OA4ZzPHkT0Yco=;
        b=ZYto3VzC3rpXgqPzyycT9jZOGthCMXheMvGhIAt/ZRrxIQtHJLwQg8KO1dzUKImdJX
         05rBtKd9IkwaI1iwpwqTyctgYijqyOFuOcNUgXkJssq/oyKEHjT0Bbx5K+urURAqH9rq
         0p61SYEjkzxL7aFQup3AVHMF+9X89lpETL2+wWCC4lSSug1gFJNU2IxteDfPJeeuTaLS
         NBmhD1rngqW4QfL0TEBMrT1aZ3eUhWDiUVJbIXayTyedzAHYBp6Rqm+a8v0wRaPyHDu4
         +x4oKW5N7Q1W6flciUDOzdDm+83GYmR8uDGB/qtflmkbcBPXygqa6Tf1I5qMIqqLrIo+
         VmbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrSGqljB2cQjBWYdR2RYeZqU5mO4pMuxsQXUCV4Ub+iVWxXiQ3ku5FqKWrvg1opmOmlHGszEcL4xgLPJdo@vger.kernel.org
X-Gm-Message-State: AOJu0YxI1VS+WjN1Gp18FvXtWN6hu/rMHl7cCBjH5kmfHMTXILYfRI1m
	kg8AyKYJjSmkAy/pWgf9WE3kfyYX76Kgh7db4Kir4JkK+k2fqDbh5005uVvsqwwZGVi6MWPRkNa
	P3g30xMymeeDoRVnl08LVcJ2obCQsO8Q=
X-Gm-Gg: AY/fxX4iO4Ozfy4ffK+W9Tcd0WsSvfNh0TtI94/vRvkH0UTehyUsu/jqXTowolcnvQT
	kQvolDVifn/uESy6VempSqEndkLAegxNe30hfDXhoxCDnRN0BJSbewPCoxwMhJNyDjuTu7+wFvr
	mFYw45VVL+CAlftCLJrgetgbaT9cIQGoZ6lIuHCmOGLp6WY5ujFWuyhOYFeo8PSZSlEEeTlAne4
	V03pI9W3SWCnLCn4Xo2IEv4mwBqFMytrnWzVjkowrUKcjx3jStc4FvBlL51sRetG2on8YPYvo6S
	/gsU4Eb3iiOJb+LKLEoRQ93sLTfahVMsjfMJFY/T
X-Received: by 2002:a17:906:3ca1:b0:b87:6c41:bd6e with SMTP id
 a640c23a62f3a-b8777a0b1a2mr20024966b.5.1768413289489; Wed, 14 Jan 2026
 09:54:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260114-tonyk-get_disk_uuid-v1-0-e6a319e25d57@igalia.com> <20260114-tonyk-get_disk_uuid-v1-3-e6a319e25d57@igalia.com>
In-Reply-To: <20260114-tonyk-get_disk_uuid-v1-3-e6a319e25d57@igalia.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 14 Jan 2026 18:54:37 +0100
X-Gm-Features: AZwV_QjJMBsMMFjKP053WyHEfg80dXeyrhI42AdnL-ae8ei5FSGNGR_90taCtJg
Message-ID: <CAOQ4uxjAQu9sQt3qOOVWS5cz5B51Hg0m4RAjsreBkmPhg-2cyw@mail.gmail.com>
Subject: Re: [PATCH 3/3] ovl: Use real disk UUID for origin file handles
To: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Cc: Christoph Hellwig <hch@lst.de>, Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
	Tom Talpey <tom@talpey.com>, Carlos Maiolino <cem@kernel.org>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	kernel-dev@igalia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2026 at 5:32=E2=80=AFAM Andr=C3=A9 Almeida <andrealmeid@iga=
lia.com> wrote:
>
> Some filesystem, like btrfs, supports mounting cloned images, but assign
> random UUIDs for them to avoid conflicts. This breaks overlayfs "index"
> check, given that every time the same image is mounted, it get's
> assigned a new UUID.
>
> Fix this assigning the disk UUID for filesystem that implements the
> export operation get_disk_uuid(), so overlayfs check is also against the
> same value.
>
> Signed-off-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> ---
>  fs/overlayfs/copy_up.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 758611ee4475..8551681fffd3 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -421,8 +421,26 @@ struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs=
, struct inode *realinode,
>         struct ovl_fh *fh;
>         int fh_type, dwords;
>         int buflen =3D MAX_HANDLE_SZ;
> -       uuid_t *uuid =3D &realinode->i_sb->s_uuid;
> -       int err;
> +       struct super_block *real_sb =3D realinode->i_sb;
> +       uuid_t *uuid =3D &real_sb->s_uuid, real_uuid;
> +       u32 len =3D sizeof(uuid_t);
> +       int err, ret;
> +       u64 offset;
> +
> +       /*
> +        * Some filesystems that support cloned devices may expose random=
 UUIDs
> +        * for userspace, which will cause the upper root origin check to=
 fail
> +        * during a remount. To avoid this, store the real disk UUID.
> +        *
> +        * ENODATA means that the filesystem implements get_disk_uuid(), =
but
> +        * this instance is using the real UUID so we can skip the operat=
ion.
> +        */
> +       if (real_sb->s_export_op && real_sb->s_export_op->get_disk_uuid) =
{
> +               ret =3D real_sb->s_export_op->get_disk_uuid(real_sb, real=
_uuid.b, &len, &offset);
> +
> +               if (!ret || ret !=3D ENODATA)
> +                       uuid =3D &real_uuid;
> +       }
>

Perhaps this is the wrong way to abstract what overlayfs needs from real fs=
.
Maybe better to extend ->encode_fh() to take a flags argument (see similar
suggested patch at [1]) and let overlayfs do something like:

fh_type =3D 0;
if (ovl_origin_uuid(ofs))
        fh_type =3D exportfs_encode_inode_fh(realinode, (void *)fh->fb.uuid=
.b,
                                           &dwords, NULL, EXPORT_FH_WITH_UU=
ID);
if (fh_type <=3D 0)
        fh_type =3D exportfs_encode_inode_fh(realinode, (void *)fh->fb.fid,
                                           &dwords, NULL, 0);

Similarly, in ovl_decode_real_fh() overlayfs won't verify the UUID,
this will be also delegated to the filesystem via exportfs_decode_fh()
whose fh->fb.type already has the EXPORT_FH_WITH_UUID flag.

This is very rough hand waving and details need to be worked out,
but it essentially delegates the encoding  of a "globally unique file handl=
e"
to the filesystem without specifying this or that version of uuid.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/CAOQ4uxj=3DXOFqHBmYY1aBFAnJtSkxzS=
yPu5G3xP1rx=3DZfPfe-kg@mail.gmail.com/
