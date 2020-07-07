Return-Path: <SRS0=JIvn=AS=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A0C9C433DF
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Jul 2020 05:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 445CA20702
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Jul 2020 05:52:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JuutRxBL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgGGFwG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 7 Jul 2020 01:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbgGGFwF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Jul 2020 01:52:05 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFC4C061755
        for <linux-unionfs@vger.kernel.org>; Mon,  6 Jul 2020 22:52:05 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id c16so41893712ioi.9
        for <linux-unionfs@vger.kernel.org>; Mon, 06 Jul 2020 22:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fe2f3BCfY30xRXcr19Elzwf5paL5SFl3ZV/mtID8sEU=;
        b=JuutRxBLZFhonBupVdAAEyT9cwMbtJ+aMDwFbNBDquYULmpPApXOksVJ+6AV93/lSn
         pY2CIDElyBWQ2nFbSpQloa0KEki30qSACYYaE1DXjZuDnzhGQMD5XJe4mrNGmBPzh102
         dkY7us3yk0r4x2mUawkh+3qncreHuGWDRMp6LN2VSHOvPzvr2hC5nUMxOkZ5vR9+QBsa
         oJl4cKlg6rDQb4F2cIedA9qRL3eQKjAGlnE6fMDZ3w1qfR+61aWmA1SQgkcEHMVjrZd5
         7ol7HDV892ONckYWJvNRxGDjwZDQyiSsdo522ujidHcMC9zyNeTZcZfioe3/jLgXtFUH
         HvEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fe2f3BCfY30xRXcr19Elzwf5paL5SFl3ZV/mtID8sEU=;
        b=jRN394lMgbnSP1qooEaeyI31NLQFVTcSJc5VqD79ZIDkP0B8nANr/pxhWz7XEzRvuA
         yFyQQTlxdPsiMRgZPdsrYjU/Cqh1S/0Pb64vsHKbRR2AhAI47wLaZ50wjrEL5sj6Ouob
         Fk+i4nytoNwrvWYWd5obGjb6VWvhCxtNYwLhHsJTUZgKqLac4My4VzLMqJ5uwYR6KfbN
         cqHBGh+Nv5/ZG03uOLgv1UfNtmmdk2nK9SmzkxYXRjq30/APMsMMla+VesqPUiat5iAt
         +Qz+c3qXlrRZPmAJE+1P+GBa/Be8t1Jnyj6ap0ZA37jVeDQyKULwahu9rhlllXjPm45D
         3Ibw==
X-Gm-Message-State: AOAM533fEviOHfKzgl139coDNB+apyAX5VspE5GJM95cQuajbdAvLPnB
        LwoUBfQE97O4LIk0s9UvddzOvHGlsV+3unL44As=
X-Google-Smtp-Source: ABdhPJyTfymVFygpjcAPYz+H4rPwU8h+AXZnVkGjswgAVEkwiHkCglI2w0qxli0evwZ+epmPAWAi0wZaDvYx89OQ+18=
X-Received: by 2002:a05:6638:d96:: with SMTP id l22mr59018803jaj.120.1594101124876;
 Mon, 06 Jul 2020 22:52:04 -0700 (PDT)
MIME-Version: 1.0
References: <32532923.JtPX5UtSzP@fgdesktop> <CAOQ4uxjm7i+uO4o4470ACctsft1m18EiUpxBfCeT-Wyqf1FAYg@mail.gmail.com>
 <106271350.sqX05tTuFB@fgdesktop>
In-Reply-To: <106271350.sqX05tTuFB@fgdesktop>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 7 Jul 2020 08:51:53 +0300
Message-ID: <CAOQ4uxgT_cmFPm_mnpQtjWqhd=3vOAiFLdw_z6Y_=FSxr+3nfg@mail.gmail.com>
Subject: Re: overlayfs: issue with a replaced lower squashfs with export-table
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Fabian <godi.beat@gmx.net>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 6, 2020 at 6:14 PM Fabian <godi.beat@gmx.net> wrote:
>
> Hi Amir,
>
> thanks for your mail and the quick reply!
>
> Am Montag, 6. Juli 2020, 16:29:51 CEST schrieb Amir Goldstein:
> > > We are seeing problems using an read-writeable overlayfs (upper) on a
> > > readonly squashfs (lower). The squashfs gets an update from time to time
> > > while we keep the upper overlayfs.
> >
> > It gets updated while the overlay is offline (not mounted) correct?
>
> Yes. We boot into a recovery system outside the rootfs and its overlayfs,
> replace the lower squashfs, and then reboot into the new system.
>
> > > On replaced files we then see -ESTALE ("overlayfs: failed to get inode
> > > (-116)") messages if the lower squashfs was created _without_ using the
> > > "-no-exports" switch.
> > > The -ESTALE comes from ovl_get_inode() which in turn calls
> > > ovl_verify_inode() and returns on the line where the upperdentry inode
> > > gets compared
> > > ( if (upperdentry && ovl_inode_upper(inode) != d_inode(upperdentry)) ).
> > >
> > > A little debugging shows, that the upper files dentry name does not fit to
> > > the dentry name of the new lower dentry as it seems to look for the inode
> > > on the squashfs "export"-lookup-table which has changed as we replaced
> > > the lower fs.
> > >
> > > Building the lower squashfs with the "-no-exports"-mksquashfs option, so
> > > without the export-lookup-table, seems to work, but it might be no longer
> > > exportable using nfs (which is ok and we can keep with it).

Miklos,

At first glance I did not understand how changing lower file handles causes
failure to ovl_verify_inode().
To complete the picture, here is the explanation.

Upper file A was copied up from lower file with inode 10 in old squashfs
and the "origin" file handle composed of the inode number 10 is recorded
in upper file A.

With newly formatted lower, lower A has inode 11 and lower B has inode 10.
Upper file B is copied from lower file B with inode 10 in new squashfs and
the "origin" file handle composed of the inode number 10 is recorded
in upper file B.
Now we have two upper files with the same "origin" that are not hardlinks.

On lookup of both overlay files A and B, ovl_check_origin() decodes lower
file B (inode 10) as the lower inode.
This lower inode is used to get the overlay inode number (10) and as
the key to hash overlay inode in inode cache.

Suppose A is looked up first and it's inode is hashed.
Then B is looked up and in ovl_get_inode() it finds the inode hashed
by the same lower inode in inode cache, but fails ovl_verify_inode()
because:
d_inode(upperdentry) /* B */ != ovl_inode_upper(inode) /* A */

This can also happen when copying overlay layers to a new
fs tree and carrying over the old "origin" xattr.
In practice, the UUID part of the stored "origin" xattr is meant to
protect against decoding lower fh when migrating to another
filesystem, but layers could be migrated inside the same filesystem.
Since squashfs does not have a UUID, re-creating sqhashfs is similar
to migrating layers inside the same filesystem.

We were aware of the "layer migration" case when designing the
index/nfs_export feature, which is one of the reasons they are
opt-in features.

But we enabled the functionality of following non-dir origin
unconditionally because we *thought* it is harmless, as the comment
in ovl_lookup() says:

         /*
         * Lookup copy up origin by decoding origin file handle.
         * We may get a disconnected dentry, which is fine,
         * because we only need to hold the origin inode in
         * cache and use its inode number.  We may even get a
         * connected dentry, that is not under any of the lower
         * layers root.  That is also fine for using it's inode
         * number - it's the same as if we held a reference
         * to a dentry in lower layer that was moved under us.
         */

The patch I posted disabled decoding of non-dir origin for the special
case of lower null uuid.

I think we can also warn and auto-disable decoding non-dir origin in
case index is disabled and we detect this upper inode conflict in
ovl_verify_inode().

The problem is if A is not metacopy and looked up first, and B is
metacopy and looked up second, then conflict will be deleted after
the wrong inode has been hashed.

Perhaps we should disable decoding non-dir origin with in case
metacopy=on,index=off?
Maybe also provide a user option to disable decoding non-dir origin
at the price of losing persistent inode number for copied up non-dir?
Something like 'index=nofollow'.

Thoughts?
Am I overthinking this?

Thanks,
Amir.
