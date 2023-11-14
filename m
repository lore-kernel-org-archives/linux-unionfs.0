Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75815C4167B
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 15:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbjKNPgE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 10:36:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233521AbjKNPgD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 10:36:03 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B30FED
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:36:00 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id af79cd13be357-778a20df8c3so374905985a.3
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699976159; x=1700580959; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RNQoHqOly/eE6iGOk9ocNYRd+6Xe9/6LC1abeZqYghM=;
        b=LWQJ/9SiCPZR2Ld5cw6e5XQ7qK9CTlRl5usCwQi8iBptBms7SPvnb2o+ARr+hw7THi
         m3aiEr0H1G3TDaAJFdZjJyGdhKDChkkvf6FlaQ9TFKDGKiNR/Uf6A6LPZdfiKaOq54Kl
         CO05sXa4PoInIkTVn8F1hLBoAIGmOOk07sX/K3PVtTkrJy7dXwystj9i7DYemshOgdlB
         wtvUDITOYQQB0tSJowH2AwFN97Ujg+rm1jmOjX1hVSeqlRuUUrONa3GqlIejRYhIppwJ
         +N4wziAIErQ1JYN5KA9CbY6vDP1XyJmg8EDBxEkG6v61HuyaVzv8+ubxvsgyruDxFwVj
         AEIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699976159; x=1700580959;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RNQoHqOly/eE6iGOk9ocNYRd+6Xe9/6LC1abeZqYghM=;
        b=SkIoDDrlAa0HcdmP9LNiTcOxpD3Wney4TBzmSNbJPsK9LISXBGYB2zSUjCTaKgscBE
         Sb9Y8Ys31KzAo0gxnVzqybTW4e8rWiTX4M7u1/ylecrXfRHmbb+qz0ZxJ9LcYdMJ9nGq
         lnXCrOuxVAGXM0sisDJzcUM9Fw2bIfFFo0Ls+iQ5Qg8X4YZb6zkRG1HLLVC/cJa/9yLg
         TqsOt9/TQ4fjfTaKhhfbv23CjP8Zxd0AJo7oKQScTcfD6PmZGuI4UlVhIZFAnz9e0Kt1
         vSZ/Hf3LwY8bEdk0niIHSaqLenMr/CqIUFiUtWkIuRDgvgnK3jJJqlyLpq4qokuEg77g
         RbgA==
X-Gm-Message-State: AOJu0Yyvsl8TTaFjAF1A/a6YZi6InEcdrV/Mvm2JT1T2O011qKxXFuFP
        nqOc8JnLblMztiLfdjz2gs7mmnxbvKiOwGRrBlj80nyx
X-Google-Smtp-Source: AGHT+IFn2k8hITxM5dxcQ3LYg02qhO5/d20yWfKaU2thlXuV8CcHwv8o9Zvw9i/9CAI3dgfDVMxt3BcDtORtKd244oQ=
X-Received: by 2002:a0c:fbc2:0:b0:670:6340:2b03 with SMTP id
 n2-20020a0cfbc2000000b0067063402b03mr2675758qvp.21.1699976159544; Tue, 14 Nov
 2023 07:35:59 -0800 (PST)
MIME-Version: 1.0
References: <20231114153254.1715969-1-amir73il@gmail.com>
In-Reply-To: <20231114153254.1715969-1-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 14 Nov 2023 17:35:48 +0200
Message-ID: <CAOQ4uxg0qnnboBGh3uhJNGoi_OBL6Rm1-sTFWHdbVwjPoY-VSA@mail.gmail.com>
Subject: Re: [PATCH 00/15] Tidy up file permission hooks
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Nov 14, 2023 at 5:32=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> Hi Christian,
>

OOPS, posted to the wrong list.
Re-posting to fsdevel.

Sorry for the noise.

Amir.


> I realize you won't have time to review this week, but wanted to get
> this series out for review for a wider audience soon.
>
> During my work on fanotify "pre content" events [1], Jan and I noticed
> some inconsistencies in the call sites of security_file_permission()
> hooks inside rw_verify_area() and remap_verify_area().
>
> The majority of call sites are before file_start_write(), which is how
> we want them to be for fanotify "pre content" events.
>
> For splice code, there are many duplicate calls to rw_verify_area()
> for the entire range as well as for partial ranges inside iterator.
>
> This cleanup series, mostly following Jan's suggestions, moves all
> the security_file_permission() hooks before file_start_write() and
> eliminates duplicate permission hook calls in the same call chain.
>
> The last 3 patches are helpers that I used in fanotify patches to
> assert that permission hooks are called with expected locking scope.
>
> My hope is to get this work reviewed and staged in the vfs tree
> for the 6.8 cycle, so that I can send Jan fanotify patches for
> "pre content" events based on a stable branch in the vfs tree.
>
> Thanks,
> Amir.
>
> [1] https://github.com/amir73il/linux/commits/fan_pre_content
>
> Amir Goldstein (15):
>   ovl: add permission hooks outside of do_splice_direct()
>   splice: remove permission hook from do_splice_direct()
>   splice: move permission hook out of splice_direct_to_actor()
>   splice: move permission hook out of splice_file_to_pipe()
>   splice: remove permission hook from iter_file_splice_write()
>   remap_range: move permission hooks out of do_clone_file_range()
>   remap_range: move file_start_write() to after permission hook
>   btrfs: move file_start_write() to after permission hook
>   fs: move file_start_write() into vfs_iter_write()
>   fs: move permission hook out of do_iter_write()
>   fs: move permission hook out of do_iter_read()
>   fs: move kiocb_start_write() into vfs_iocb_iter_write()
>   fs: create __sb_write_started() helper
>   fs: create file_write_started() helper
>   fs: create {sb,file}_write_not_started() helpers
>
>  drivers/block/loop.c   |   2 -
>  fs/btrfs/ioctl.c       |  12 +--
>  fs/cachefiles/io.c     |   2 -
>  fs/coda/file.c         |   4 +-
>  fs/internal.h          |   8 +-
>  fs/nfsd/vfs.c          |   7 +-
>  fs/overlayfs/copy_up.c |  26 ++++++-
>  fs/overlayfs/file.c    |   3 -
>  fs/read_write.c        | 164 +++++++++++++++++++++++++++--------------
>  fs/remap_range.c       |  48 ++++++------
>  fs/splice.c            |  78 ++++++++++++--------
>  include/linux/fs.h     |  62 +++++++++++++++-
>  12 files changed, 279 insertions(+), 137 deletions(-)
>
> --
> 2.34.1
>
