Return-Path: <SRS0=DgkE=AT=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E24C433E0
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Jul 2020 06:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3904E20760
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Jul 2020 06:55:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jqy2ZjZN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgGHGzp (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 02:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgGHGzo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Jul 2020 02:55:44 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79544C061755
        for <linux-unionfs@vger.kernel.org>; Tue,  7 Jul 2020 23:55:44 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id a6so21438576ilq.13
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Jul 2020 23:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r7NYpamvSZwhLmW4eLuWbB/7LiSihL9Y4Yst8qHzeaw=;
        b=jqy2ZjZNYp2nAz7Ms4z7/xMBFrZI2NXp4yYD3qjCWXrclEl+MtXiiKd/81JXYiUpGw
         V2UqDjdfwMdqzmvextoZ2txMOLBIuv7B5yqAHOBj9uhk8vrkU06SVNwxHjXkTpJetS1Q
         uL8C27sC1P47TgsHb1uyL6CSuOW5rxZ5acNvmSPmkbQMJtT5DgR+tBqFSlSdzsLX2S+6
         BEwnuUwNWNNPFmKsrnnY61Zw5SkjWUKmiG+HL47F5cHBrG4KdT25touQAA6/2V/O4MFL
         SeQK11nE6WpngLX8Xi8u8tdX9/k8QS/30e18hF5a2D2EdSs/t+pvYNBW6VifpyfHCIX5
         CFSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r7NYpamvSZwhLmW4eLuWbB/7LiSihL9Y4Yst8qHzeaw=;
        b=la7+3NhdS5vkOEd8VrfRBoR3PbadyJJz0npDbabGBkk7V/Y2KpqlaJOMEpgantjbXJ
         RxzVI2bozAMkeqotlqoQn0qzd+MBB4eh3pI4bsPdsMOfXGQRdLBijRvZa8GhcTgRX7qp
         QWFQm7cZH5iw0+qGMRBbbEN9sPqfQ9hGxM75XDXrlsgNBDocM+2vLs60NjvHUb2wM+h0
         7nAwFhr9e6iTnxuLzNebOoo6bNuHLIjf+i+1Myktn6W00//VoyMe7FfIYX2emz9+hNTj
         7qOmQC99v3F2HKEl2y5StbgT7mUhweU5Sm+75mVWgv6wFUUNemLPXIcyqymLjuvgKje2
         m5IA==
X-Gm-Message-State: AOAM532xsPMwLUhMKxP1zbfvnru7BGuJFhkGRF5QIPBFxixZ2+xALP36
        QXiMDm1jJP4q5yZbyuTypLji/HbeuPQrfRoPxWQ=
X-Google-Smtp-Source: ABdhPJxh9be9VKVTL45VkmifFR+BVAVbSS59uJi7yDyCPdLd6IiSnif0QyL3oAgRxtCakOf9moRTBFOLV/CESZTWL2Y=
X-Received: by 2002:a05:6e02:13e2:: with SMTP id w2mr41024228ilj.9.1594191343714;
 Tue, 07 Jul 2020 23:55:43 -0700 (PDT)
MIME-Version: 1.0
References: <32532923.JtPX5UtSzP@fgdesktop> <CAOQ4uxjm7i+uO4o4470ACctsft1m18EiUpxBfCeT-Wyqf1FAYg@mail.gmail.com>
 <106271350.sqX05tTuFB@fgdesktop> <CAOQ4uxgT_cmFPm_mnpQtjWqhd=3vOAiFLdw_z6Y_=FSxr+3nfg@mail.gmail.com>
 <20200707155159.GA48341@redhat.com> <CAOQ4uxhMq_8xwCU2t+WveTGgc9MAWE2RD66q5UjQ1r09EoLzHA@mail.gmail.com>
 <20200707215309.GB48341@redhat.com>
In-Reply-To: <20200707215309.GB48341@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 8 Jul 2020 09:55:32 +0300
Message-ID: <CAOQ4uxhd+kYzaDmndCV5rgiswfHnyLjZokmUa+BVk9t31C=HWg@mail.gmail.com>
Subject: Re: overlayfs: issue with a replaced lower squashfs with export-table
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Fabian <godi.beat@gmx.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jul 8, 2020 at 12:53 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, Jul 07, 2020 at 08:41:20PM +0300, Amir Goldstein wrote:
> > > > Miklos,
> > > >
> > > > At first glance I did not understand how changing lower file handles causes
> > > > failure to ovl_verify_inode().
> > > > To complete the picture, here is the explanation.
> > > >
> > > > Upper file A was copied up from lower file with inode 10 in old squashfs
> > > > and the "origin" file handle composed of the inode number 10 is recorded
> > > > in upper file A.
> > > >
> > > > With newly formatted lower, lower A has inode 11 and lower B has inode 10.
> > > > Upper file B is copied from lower file B with inode 10 in new squashfs and
> > > > the "origin" file handle composed of the inode number 10 is recorded
> > > > in upper file B.
> > > > Now we have two upper files with the same "origin" that are not hardlinks.
> > > >
> > > > On lookup of both overlay files A and B, ovl_check_origin() decodes lower
> > > > file B (inode 10) as the lower inode.
> > > > This lower inode is used to get the overlay inode number (10) and as
> > > > the key to hash overlay inode in inode cache.
> > > >
> > > > Suppose A is looked up first and it's inode is hashed.
> > > > Then B is looked up and in ovl_get_inode() it finds the inode hashed
> > > > by the same lower inode in inode cache, but fails ovl_verify_inode()
> > > > because:
> > > > d_inode(upperdentry) /* B */ != ovl_inode_upper(inode) /* A */
> > > >
> > > > This can also happen when copying overlay layers to a new
> > > > fs tree and carrying over the old "origin" xattr.
> > > > In practice, the UUID part of the stored "origin" xattr is meant to
> > > > protect against decoding lower fh when migrating to another
> > > > filesystem, but layers could be migrated inside the same filesystem.
> > > > Since squashfs does not have a UUID, re-creating sqhashfs is similar
> > > > to migrating layers inside the same filesystem.
> > >
> > > Hi Amir,
> > >
> > > So we can't use "origin" if lower layers have been copied. If they
> > > have been copied to a different filesystem with uuid we seem to
> > > have a mechanism to detect it but otherwise not and we can run
> > > into these kind of issues.
> > >
> >
> > Correct.
> >
> > > My question is, why do we allow copying or updating lower layers
> > > with same upper when we know this will break stored origin in
> > > upper.
> >
> > I don't know if we "allow" this.
>
> So there seem to two cases. One is copying the lower layers to same
> filesystem or a different filesystem. And another case is recreating
> the lower layers and use previous upper with old upper. IIUC, we
> are currently facing problem with second scenario.
>
> "copying the lower layers" is probably fine as you said because old
> tree still keeps that inode number busy and newly created inode
> should not acquire that number.
>
> But in this case looks like we recreated lower and that led to
> some file B acquiring an inode number which was used by A. So
> this is a different use case. IIUC, simply copying the layer
> will not lead to this situation.
>
> Now question is do we support recreating the lower layer with existing
> upper. And I see following text in "Sharing and copying layer"
>
> "Mounting an overlay using an upper layer path, where the upper layer path
> was previously used by another mounted overlay in combination with a
> different lower layer path, is allowed, unless the "inodes index" feature
> or "metadata only copy up" feature is enabled."
>
> This seems to suggest that recreating lower layer is allowed as long
> as you are not using index or metacopy feature.
>
> If that's the case, probably "origin" should have been an opt-in
> feature or automatically be enabled by some other opt-in feature.
>
>

Yes. "should have been". That is my point.
We thought it was a victimless crime to enable "origin" without opt-in
and I think we were wrong.

> > We never considered the case expect
> > for nfs export and index, see overlayfs.rst:
> > "When the overlay NFS export feature is enabled, overlay filesystems
> > behavior on offline changes of the underlying lower layer is different
> > than the behavior when NFS export is disabled. ..."
> >
> > > Can't I do same thing with ext4/xfs, where I recreate
> > > lower layers when inode numbers get exchanged  and same problem
> > > will happen (despite uuid being same).
> > >
> >
> > Same problem.
>
> >
> > > IOW, how can we support copying layers (with same upper) while origin
> > > is in use. Rest of the features are built on top of the assumption
> > > that origin is valid. And in case of copying layers, we don't
> > > seem to have a sure way to find if origin is valid or not.
> > >
> >
> > With index/nfs_export enabled we at least do:
> > /* Verify lower root is upper root origin */
> > and if verification fails we disable the feature.
>
> So discrepancy is still possible if somebody modifies lower layers
> without changing lower root.
>
> - Copy up file A.
> - Unmount overlay
> - unlink A
> - create B (assume B gets same inode number as A).
> - mount overlay; B gets copied up.
>
> And now we have both upper A and B having same origin despite no
> hardlink. Am I understanding it right?
>

Yes.

> Is there a good use case for allowing modifying lower layers with
> same upper. Given we are adding more complex features to overlayfs,
> will it make sense to not allow modifying lower layer going forward.
> We might not be able to detect it but atleast it will be unsupported
> configuration. And then we can only focus to provide a work around
> for existing use cases.
>

Agreed.

> [..]
> > > >
> > > > We were aware of the "layer migration" case when designing the
> > > > index/nfs_export feature, which is one of the reasons they are
> > > > opt-in features.
> > > >
> > > > But we enabled the functionality of following non-dir origin
> > > > unconditionally because we *thought* it is harmless, as the comment
> > > > in ovl_lookup() says:
> > > >
> > > >          /*
> > > >          * Lookup copy up origin by decoding origin file handle.
> > > >          * We may get a disconnected dentry, which is fine,
> > > >          * because we only need to hold the origin inode in
> > > >          * cache and use its inode number.  We may even get a
> > > >          * connected dentry, that is not under any of the lower
> > > >          * layers root.  That is also fine for using it's inode
> > > >          * number - it's the same as if we held a reference
> > > >          * to a dentry in lower layer that was moved under us.
> > > >          */
> > > >
> > > > The patch I posted disabled decoding of non-dir origin for the special
> > > > case of lower null uuid.
> > > >
> > > > I think we can also warn and auto-disable decoding non-dir origin in
> > > > case index is disabled and we detect this upper inode conflict in
> > > > ovl_verify_inode().
> > > >
> > > > The problem is if A is not metacopy and looked up first, and B is
> > > > metacopy and looked up second, then conflict will be deleted after
> > > > the wrong inode has been hashed.
>
> We don't allow modifying lower layers if metacopy is enabled.
>
> "For "metadata only copy up" feature there is no verification mechanism at
> mount time. So if same upper is mounted with different set of lower, mount
> probably will succeed but expect the unexpected later on. So don't do it.
> "
>
> So if somebody is recreating lower or modifying lower with metacopy
> on, its an unsupported configuration.
>

Very good. So this case is settled.

Now, suggestions for work arounds:

1. Don't follow with lower null uuid (patch posted) - no caveats
2. Opt-out of following origin with explicit option e.g. "index=nofollow"
3. Don't follow origin unless one of the following opt-in features:
    metacopy,index,xino

If we go for option #3, the easiest recommendation for distros
would be to set:
CONFIG_OVERLAY_FS_XINO_AUTO=y

Apart from "compatibility with applications that expect 32bit inodes"
I am not aware of any caveats to enabling XINO_AUTO.

The purpose of xino feature is to make overlay st_ino/st_dev more
posix-like (currently only for non samefs), so it makes some sense
to tie the "origin" xattr feature that preserves the pre copy up
persistent st_ino to xino.

The xino documentation does not mention the samefs exemption:
"...If this feature is disabled or the underlying filesystem doesn't have
enough free bits in the inode number, then overlayfs will not be able to
guarantee that the values of st_ino and st_dev returned by stat(2) and the
value of d_ino returned by readdir(3) will act like on a normal filesystem."

and the 'xino' mount option is currently not displayed with samefs.

If we implement option #3, then with samefs user could enable xino
if default is off and disable xino if default is auto and display xino in
mount options.

Thanks,
Amir.
