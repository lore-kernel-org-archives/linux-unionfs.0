Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1709ACE7A8A
	for <linux-unionfs@archiver.kernel.org>; Sun, 24 Sep 2023 09:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjIXJ3I (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 24 Sep 2023 05:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjIXJ3I (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 24 Sep 2023 05:29:08 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E68FE
        for <linux-unionfs@vger.kernel.org>; Sun, 24 Sep 2023 02:29:01 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id af79cd13be357-7741c2fae49so204100985a.0
        for <linux-unionfs@vger.kernel.org>; Sun, 24 Sep 2023 02:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695547741; x=1696152541; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8jIRtPqKLxL3Lcq6EPRP18j2PMTzT0Mw4nWqcLE7RcQ=;
        b=NOJSzNgPcp1poSMhbj5V/Vz5G+5cIgiii2nfHlJilhvUBkn3ZTXKvlLDWPr5Jf7/Cl
         mBguot6rqFD4SP7Z1eMdhTEYBdw1Z2ViATiVZBzmt5+9NVeG3WafoQ+rX/94quImgq5b
         b+DAWGhHQHd1aulAKemQat6dLEs0MRRUHt75+6ISwhn9QnufUwgPmVFx+nb6Ra50TmKk
         YdF3dE4nCyJMz4n0pUNmxHfsuZzIejrRAS5/zfeJ6bXEtFegByRJUFbvk1+Z0hKNVrzs
         OJU8bziMxyy2ni37vv3NMKgQFA5HBZRHR8BD26ZMXPMc2O16LLtUkMT/I5EpQsPT9fZZ
         hZ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695547741; x=1696152541;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8jIRtPqKLxL3Lcq6EPRP18j2PMTzT0Mw4nWqcLE7RcQ=;
        b=v1Wsx89JszdpwhTsW1M7wGmfHl/3+8nSABdDBDnL9WGmSdJBCehSkdB5wV20nI+vCI
         q1DLxnmqEVVf54vQr/aMW0T9BsATPLqtJD3f+sP9diwUI1ZTPnN9XCSW5HQKhsZCRhoh
         BccwvpIlxdLSNa8wylRYG2doLkN6fnN12SF4U2uhemZ0uWYOAHOuDN+k66Alqaz5J37V
         A+QVSX0+78mHjLoUImx3P3q+KQOnEJnzvCuiKiyKsVGB28CaMurU6U1YzIo85i/RJ2Ye
         JVd+TTti/RnBdL/PcaMl4e4H4PgrJqQnJn6MRUcSI4cv2vKDuAzknwVP+H8AYoQTgdHw
         eVJA==
X-Gm-Message-State: AOJu0Yzng/7IAnt5Y68gC7HYOBwCTMJVihI3MMsM6XIPTLOXmM+vRLwE
        ayzvL8nMFU/9ACfnzctwvo4WaD0+JcbOgkcsJiA=
X-Google-Smtp-Source: AGHT+IFwu2LN5zvTcIXYN2Lvc36kBDDnJ86lmoBKLssVG662vgKnbrYck2pNFk4rnZ3Hu4xI+0gF08DQCx0w7CFtSjk=
X-Received: by 2002:ae9:f445:0:b0:774:1d85:54fc with SMTP id
 z5-20020ae9f445000000b007741d8554fcmr4062430qkl.74.1695547740956; Sun, 24 Sep
 2023 02:29:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230912173653.3317828-1-amir73il@gmail.com> <20230912173653.3317828-2-amir73il@gmail.com>
In-Reply-To: <20230912173653.3317828-2-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 24 Sep 2023 12:28:49 +0300
Message-ID: <CAOQ4uxhvztZMeGKy1YSq0+y_uWt7fud7vBw8pvO33sk2K44K0w@mail.gmail.com>
Subject: Re: [PATCH 1/4] ovl: protect copying of realinode attributes to ovl inode
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Christian Brauner <brauner@kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

[adding some folks from the multigrain ctime discussion]

On Tue, Sep 12, 2023 at 8:36=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> ovl_copyattr() may be called concurrently from aio completion context
> without any lock and that could lead to overlay inode attributes getting
> permanently out of sync with real inode attributes.
>
> Similarly, ovl_file_accessed() is always called without any lock to do
> "compare & copy" of mtime/ctime from realinode to inode.
>
> Use ovl inode spinlock to protect those two helpers.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/file.c | 2 ++
>  fs/overlayfs/util.c | 2 ++
>  2 files changed, 4 insertions(+)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 4193633c4c7a..c6ad84cf9246 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -249,6 +249,7 @@ static void ovl_file_accessed(struct file *file)
>         if (!upperinode)
>                 return;
>
> +       spin_lock(&inode->i_lock);
>         ctime =3D inode_get_ctime(inode);
>         uctime =3D inode_get_ctime(upperinode);
>         if ((!timespec64_equal(&inode->i_mtime, &upperinode->i_mtime) ||
>              !timespec64_equal(&ctime, &uctime))) {
>                 inode->i_mtime =3D upperinode->i_mtime;
>                 inode_set_ctime_to_ts(inode, uctime);
>         }
> +       spin_unlock(&inode->i_lock);
>

[patch manually edited to add missing line to context]

Miklos,

I am having latent concerns about this patch, which is currently
in overlayfs-next.

What was your reason for the "compare & copy" optimization?
I assume it was to avoid cache line bouncing. yes?
Would the added spinlock make this optimization moot?
I am asking since I calculated that on X86-64 and with
CONFIG_FS_POSIX_ACL && CONFIG_SECURITY
i_ctime.tv_nsec and i_lock are on the same cache line.

I should note for the non-overlayfs developers, that we do
not care to worry about changes to the upperinode that are
done behind the back of overlayfs.

Ovrerlayfs assumes that it is the only one to make changes
to the upperinode, otherwise, behavior is undefined.

This is the justification for only taking the overlayfs inode
i_lock for synchronization of this "compare & copy" routine.

Also, I think we only need to care that the overlayfs inode
timestamps are eventually consistent, after the last
ovl_file_accessed() call.

The decraled reason (in commit message) for adding the lock
here is to protect from races in the ovl aio code path, which was
not around when the ovl_file_accessed() helper was written.

But now I am wondering:
- Is the lock needed in all the sync calls?
- Is it needed even if there was no aio at all?

I think the answer is yes to both questions, so the patch
can remain in its current form, but I'm not 100% sure.

>         touch_atime(&file->f_path);
>  }
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 89e0d60d35b6..b7922862ece3 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -1403,6 +1403,7 @@ void ovl_copyattr(struct inode *inode)
>         realinode =3D ovl_i_path_real(inode, &realpath);
>         real_idmap =3D mnt_idmap(realpath.mnt);
>
> +       spin_lock(&inode->i_lock);
>         vfsuid =3D i_uid_into_vfsuid(real_idmap, realinode);
>         vfsgid =3D i_gid_into_vfsgid(real_idmap, realinode);
>
>         inode->i_uid =3D vfsuid_into_kuid(vfsuid);
>         inode->i_gid =3D vfsgid_into_kgid(vfsgid);
>         inode->i_mode =3D realinode->i_mode;
>         inode->i_mtime =3D realinode->i_mtime;
>         inode_set_ctime_to_ts(inode, inode_get_ctime(realinode));
>         i_size_write(inode, i_size_read(realinode));
> +       spin_unlock(&inode->i_lock);

My concerns about this part of the patch is that AFAIK,
all the calls of ovl_copyattr(), except for the one in aio completion,
are called with overlayfs inode mutex lock held.

So this lock is strictly only needed because of the aio write case,
but I think we need to have the lock in place for all the other
cases to protect them against racing with aio completion?

I guess the overhead of the spinlock is not a worry if the
mutex is already held, even though we do call ovl_copyattr()
twice (before and after) in some operations.

Anyway, I just want to make sure that I did not make any
mistakes in my analysis of the problem and the fix.

Thanks,
Amir.
