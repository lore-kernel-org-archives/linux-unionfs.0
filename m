Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795025358;
	b=pN9b9LgaTPa/QAV1vzGFZopDskLdgTJgqql2dAldfZmbPpOM+9QUHp+Q1P5FNevibte4
	 6P5x3Qn0VZQ2LfZrkTawX49rk8nPjrq2vwHbORRD/8iML8teb/UHBCXoMAVYD45sOlsbI
	 cvfgiu1FIkdJIDHC1XHWKcY20OxA+OCBRdojffRdv88NA/geYWh6Bw2a7RxijZr79QJbC
	 8vNHXzxG17olCTThS0D08EI582OkMv9nHCA3jiLNT5bGbWbcH+Y/+rlJo3lW3/rT83Vdl
	 iawnV4Th/AXba6SVzcyn1anWKybGMCvUwy6z3xfPMsoZP/4ES4kw7STSuICDs6Q36Mg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025358;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=kwy4Hj1zovxLuT7JhwbmIP+fCBASCZe33N49zoGI9m8=;
	b=ROLpcFq4J0Uaj4OdT//5BhGfb71eMMsdTkKAA2dIQ7zrrlIH3anR1mQsxYbsaY26sHrw
	 bp0ZlV7HfiegZTtAyHTh/qI4ECvaBfM+g88az5zhzA07AJ6LpHcOy1Yk6iOA5RG7w2dwK
	 beZkqx04qHBqgkM8r5WZ/6WiMvAdTepsMRPL2iiutXA7f+LBY5l415i2pqUt/YzeHrjyF
	 7/j0BGcAInszit2vpw/CNehETT7Pp2R6YplEWSh+AwV5i+hVF0A27NaEdn6wPwVJ2h3aP
	 xajaLW/Y/uiEjzSu6Zt2xfAAhCVn6u3xZXt6xX6F+Js7evkQ5tpEEAvs88YDdaqfLmA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FaCjoIxd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EE560A2615
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 18:09:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08EE560A2615
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FaCjoIxd
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b86bbce3d1so1862803a12.0
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 10:09:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795025356; cv=none;
        d=google.com; s=arc-20260327;
        b=Ng+SAVuJYgxAXWGS5hiGGrlx4ZG1pCCY/cASkLfxWkNYUMfJW92LpWS3RAOQCUez0f
         HyPsUvKoiUFMzbnOoU5o56b8ciUSX1sjsBrJW2erSHRI93Nzfctes20OYNBijTMQYPSP
         2TpWdKFAkyC3NCyo9QEFBsG9VC59I4d6h627k43rTjbhzck747+hQyphmzxsACb6+8i9
         Jol+DkQ2fXf4zcx8gaRBDa1PQPKxFhKLvVjZ/IYlto28QB5NYE5sN88Mao0N8x5RcSyi
         SNJzfv5m8+zuOI9cwebJwO4U3VopwrwJF78mfAfOcQUSv2WQAxFHF/Krzcat/sf2P+K6
         Wg5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kwy4Hj1zovxLuT7JhwbmIP+fCBASCZe33N49zoGI9m8=;
        fh=EAYgtcrtaZ+1dUpXEgofi1u+bcnuJhVzxe8GrPDEs+A=;
        b=XEZV8nUPqnwHtUmtqECpFw3/Md+UfZcWxzCNfYhd//ENnkUKvQUfykwFnju8cdoa09
         hsoe08+7knq8j3aq4q/P8Cr+aVKIXkFwcs4g97df32C1EWW+hp3D+WYhj7KfPwf+bkYW
         j3buFDjsBu1SOnKbJLGUxmF7rsjEr6K/iMbEriXB/89wGqhNHjel53g7sbixm11PEnr0
         1ZlaGbaRInQ0JxjYJAHNMy80XT1i2UUsER610AKODtOBo83J+3WNvywfzlcFIIJ31snN
         nJN8BpcDHjt4wLbLsIMfdhQd3OY/jbo8wewnhlO32XXPL0F4ri9kGyf18Fs3spdXrmXx
         Hciw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795025356; x=1795630156; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kwy4Hj1zovxLuT7JhwbmIP+fCBASCZe33N49zoGI9m8=;
        b=FaCjoIxduW+OQqqM1HY+h2AatdrxA8mvHHYzo/xdr5ctytG8VhpPyqRKZKMRhE7iVv
         7FgmUAafV1rRzfmFxPFRFw3/BiHts/CNWjIbRJHB2j3xXPmy5weVodlesnbV0UkSas/2
         04rG+3UIa8LffuqU1uXJ9bDdgIwXauiQh4WsLgN4RYqIqTp1/ywOah9cXAKi6V+tM6wb
         /PMdlxMBGsA/QMbgsYo7AO/hF9BST1V0cVWyNmm27iBtzdykIEmrdjR/cVPK2ZzRoM6I
         WtiX51ayzxrUg9vwzy5WadGWFEyQicy72O2ouN3fpFqg9K6FEkOJIh/l5xbnNTQ+JvAG
         CxFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795025356; x=1795630156;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kwy4Hj1zovxLuT7JhwbmIP+fCBASCZe33N49zoGI9m8=;
        b=GGAgDcNJpqzmGdu40bX54UgWP1+UoqFGRAzShJ/jnqjhnbA3fTkkKFXm5cVhvPR41K
         xsDaSE61S31dHEdrr1ROQUyFQ9sKus8v/OrApOlTlsCORkp1zVWhKApl5U/dFUXR4M7O
         rDoqSUraErIObdZEw0CHfcjUxS3GwzCjWqQZy+gbuypMNfA1VM1j9FGo8zp/7123M8wc
         aWJ66nUG9S4tw3aqQfrsvv+9aFV0DRBHxTckuzhVOtNWCEH2mOFTwI/zQmHPTu/m8tVH
         ijQQoPh2aDIL1edKfl8ANZw9InopVL6jP0YKZzUiv5Cj84X/d0jzfUmXeQq2VH3ryAmt
         K0qg==
X-Forwarded-Encrypted: i=1; AL+hErEksGXmMQ9i7fgpldXuKWsJ1WVt5Htxd3N3d/mmrBS88gFS9BdM3TLmvyBXDJEee7Mw2AO1fPziiMgqJuFS@vger.kernel.org
X-Gm-Message-State: APuU4Z9vxz0hKjW+nkVw068LAWvBCAbXyNQcFMOCUxoF3v+EGrLEnSC4
	cRDwReNflGv1zkHsaAK0iEpF4CQoZL6pn6ncX8yz65GxwAWKaetqREyCMp7XK3+CiyTiPkU3IRe
	fFrUNKjvNKCSeejpKFGDhEZrQVuVJFz4=
X-Gm-Gg: AYBFou1vEHor+wTJkHS+q0MLmXG2TkjfiZkpiECx6w0WP1Y0qIv9UMzhM4vhqv7+XvX
	r1OUnkwtkoc7aHp/WIXCwD69lBnqqPqUogWdlVQJ//7MX28MMWnzenqUlXESKpEnDp3lsYXlibm
	kbcQtbpX/PYqooW8y1YFFiB8Kt8HXwJhuV9H35Xp2zz10ZCyrSKtwwxPJejqGmeiCm9zD5wSLfp
	J/+ftOWYVgKRFxcC+jBOixKPN9XvzF9gv8jUxqYw2DqcZ09CLnxYatWyS9fFBqJ+nvTgU1G+cW+
	4wtmKbJbiEY3DSaab0rBxizo0AP5Pls4f4W8IjTJQfskpzOFJxrDHhZ2r384WSZhlDs/ynILKDX
	NbVlP8l5HgqgiaVKOsH5MvlHb7vpPtfd1oPWZctVn8eLNCjBKG6/q6pU=
X-Received: by 2002:a05:6402:1d4b:b0:6b7:f9e0:a5bd with SMTP id
 4fb4d7f45d1cf-6b887eb273amr2779728a12.23.1795025356010; Wed, 18 Nov 2026
 10:09:16 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261118-b4-ovl-containerized-sync-v7-0-54f45743fe55@toxicpanda.com>
 <20261118-b4-ovl-containerized-sync-v7-7-54f45743fe55@toxicpanda.com>
In-Reply-To: <20261118-b4-ovl-containerized-sync-v7-7-54f45743fe55@toxicpanda.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 18 Nov 2026 19:09:04 +0100
X-Gm-Features: AclHuK8VtQI7kbgQWNsYTQs5zinc50rhvyv9MuCfqsFP8jTSp9pRJGJQpVNgjmU
Message-ID: <CAOQ4uxiexeX-Mu3eTOUTnOknb7BrYw3vSsSxqA3+oQVVYVh9oQ@mail.gmail.com>
Subject: Re: [PATCH v7 7/7] ovl: implement containerized syncfs for overlayfs
To: Josef Bacik <josef@toxicpanda.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
	Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chengguang Xu <charliecgxu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 6:03=E2=80=AFPM Josef Bacik <josef@toxicpanda.com> =
wrote:
>
> From: Chengguang Xu <charliecgxu@tencent.com>
>
> Now overlayfs can only sync own dirty inodes during syncfs,
> so remove unnecessary sync_filesystem() on upper file system.
>
> Do that with fsync=3Drelaxed only, which is what the default, fsync=3Daut=
o,
> selects on most filesystems.  fsync=3Don brings the old behaviour back.
>
> Take the steps of sync_filesystem() for the upper filesystem, but only fo=
r
> the tracked inodes, and go about it like the page cache does.
>
> Without wait, ->sync_fs() gives every inode that is marked dirty the
> towrite mark.  That is what this sync has to write.  Then it starts
> writeback of the upper inode of each of them, and replaces dirty and
> towrite by the writeback mark.
>
> With wait, for every inode with the writeback mark, it calls
> write_inode_for_sync(), which also hands over the timestamps that lazytim=
e
> has deferred, and waits for the data, whoever has started to write it.
>
> Both end with sync_fs_and_bdev(), which is what sync_filesystem() does
> after the inodes.  Do the same for unmount and for a read-only remount.
>
> A sync tags once, so tasks that modify files do not keep it going.  The
> marks are shared by all syncs that are running, so it also writes and wai=
ts
> for what another one tags ahead of it.  A walk only goes up, so it ends.
>
> In the page cache the completion of the I/O clears the writeback mark.
> Here whoever has waited does, and another sync may have started the inode
> again meanwhile.  So the mark only goes if the upper inode is seen clean.
> Until then every sync sees the inode and waits for it as well, so they do
> not have to wait for each other.  Otherwise the inode is marked dirty
> again, which also covers an upper inode that is open for writing: stores
> through a shared mapping do not call into overlayfs.
>
> That does not cover pages that are pinned through such a mapping.  A dire=
ct
> read into it that completes after the last munmap() and close() dirties
> them when the inode may have left the set, and the next syncfs() does not
> write them.
>
> syncfs() now also returns the error of writeback that the flusher of the
> upper filesystem has done before, which it did not do so far.  It compare=
s
> the wb_err of the upper mapping with what it was when the inode entered t=
he
> set.  Unlike the error flags of the mapping, nobody can take that away, a=
n
> fsync() for one.  The error is recorded in the superblock of the overlay
> under the lock that protects the cursor, so another syncfs() that runs at
> the same time gets it as well.
>
> A read-only remount of the overlay syncs it the same way, so it now fails
> with such an error, once.
>
> Keep a freeze and a read-only remount of the upper filesystem out while a=
n
> inode is handed over.  If one has already begun when ->sync_fs() is to
> wait, sync the whole upper filesystem, like before.  If one kept it from
> starting an inode and has gone away since, start that inode then.
>
> Upper inodes that have no overlay inode, like whiteouts and the work
> directories, are not tracked.  It is up to ->sync_fs() and the block devi=
ce
> to get them to disk.  ext4, xfs and btrfs log all metadata, and ext4
> without a journal keeps it in the buffers of the block device.
>
> With many containers on one upper filesystem, stopping one of them no
> longer writes out the dirty data of all the others.
>
> Signed-off-by: Chengguang Xu <charliecgxu@tencent.com>
> [josef: everything after the first paragraph]
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  Documentation/filesystems/overlayfs.rst |   7 +-
>  fs/overlayfs/overlayfs.h                |   1 +
>  fs/overlayfs/params.c                   |  14 +--
>  fs/overlayfs/super.c                    |   3 +
>  fs/overlayfs/sync.c                     | 217 ++++++++++++++++++++++++++=
++++++
>  5 files changed, 230 insertions(+), 12 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index 8a007fbc5257..00e2cba65e2c 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -830,7 +830,12 @@ Traditionally, syncfs(2) and unmount of an overlay s=
ync the entire upper
>  filesystem, including the dirty data of other overlays that share it.
>  Overlayfs can be told to only write back the files that were modified
>  through the overlay, and then ask the upper filesystem to commit its
> -metadata.
> +metadata and write its block device.
> +
> +In that mode syncfs(2) also returns the error of writeback of such a fil=
e
> +that has failed earlier, like fsync(2) on the file does.  As after fsync=
(2),
> +a file that is opened on the upper filesystem later does not get that er=
ror
> +any more.  A read-only remount of the overlay fails with such an error o=
nce.
>
>  On traditional local filesystems with a single journal (e.g. ext4, xfs),
>  fsync on a file also persists the parent directory changes, because they
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index f4770b4c0222..63200551a7d0 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -899,6 +899,7 @@ void ovl_forget_inode(struct inode *inode);
>  void ovl_drop_tracked(struct ovl_fs *ofs);
>  long ovl_nr_cached_objects(struct super_block *sb, struct shrink_control=
 *sc);
>  long ovl_free_cached_objects(struct super_block *sb, struct shrink_contr=
ol *sc);
> +int ovl_sync_tracked(struct super_block *sb, int wait);
>
>  /* vfs fileattr flags read from overlay.protattr xattr to ovl inode */
>  #define OVL_PROT_I_FLAGS_MASK  (S_APPEND | S_IMMUTABLE)
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index 370dd6341392..90111c480440 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -774,22 +774,14 @@ static int ovl_reconfigure(struct fs_context *fc)
>  {
>         struct super_block *sb =3D fc->root->d_sb;
>         struct ovl_fs *ofs =3D OVL_FS(sb);
> -       struct super_block *upper_sb;
> -       int ret =3D 0;
>
>         if (!(fc->sb_flags & SB_RDONLY) && ovl_force_readonly(ofs))
>                 return -EROFS;
>
> -       if (fc->sb_flags & SB_RDONLY && !sb_rdonly(sb)) {
> -               upper_sb =3D ovl_upper_mnt(ofs)->mnt_sb;
> -               if (ovl_should_sync(ofs)) {
> -                       down_read(&upper_sb->s_umount);
> -                       ret =3D sync_filesystem(upper_sb);
> -                       up_read(&upper_sb->s_umount);
> -               }
> -       }
> +       if (fc->sb_flags & SB_RDONLY && !sb_rdonly(sb) && ovl_should_sync=
(ofs))
> +               return sync_filesystem(sb);
>
> -       return ret;
> +       return 0;
>  }
>
>  static const struct fs_context_operations ovl_context_ops =3D {
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 7f7d3993bc7a..a2d527f62d75 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -287,6 +287,9 @@ static int ovl_sync_fs(struct super_block *sb, int wa=
it)
>         if (!ret)
>                 return ret;
>
> +       if (!ovl_should_sync_upper_fs(ofs))
> +               return ovl_sync_tracked(sb, wait);
> +
>         /*
>          * Not called for sync(2) call or an emergency sync (SB_I_SKIP_SY=
NC).
>          * All the super blocks will be iterated, including upper_sb.

Maybe also move ovl_sync_fs() to sync.c makes this
a very nice finale ;)

Thanks,
Amir.
