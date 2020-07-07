Return-Path: <SRS0=JIvn=AS=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8727AC433E1
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Jul 2020 15:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 614022082F
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Jul 2020 15:52:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MUN9WQ+A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgGGPwH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 7 Jul 2020 11:52:07 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30399 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727886AbgGGPwG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Jul 2020 11:52:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594137124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xh1RPqwXHZeuVcdPjUHOy0H2lQFozcak9DN0AAWrnK0=;
        b=MUN9WQ+ASfMd/WtYUauwxdUrHaRZxZCeLLPUs7xSoOrO3qYfP37IXVuqEuveemIa9QGvaz
        f9EHaC0wMppKoiJsEQ5Ij01cUmFCnrh35EwDqER5RitLPCaZn3oZCksmUt1VUAiUE+ZQCU
        bGDOscs2d3cWruFbD7hKfxg6f3UHrzY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-pl2e2xgLPUKdE1Cf-kToWg-1; Tue, 07 Jul 2020 11:52:02 -0400
X-MC-Unique: pl2e2xgLPUKdE1Cf-kToWg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1EDEE107B265;
        Tue,  7 Jul 2020 15:52:01 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-115.rdu2.redhat.com [10.10.116.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35BAB71674;
        Tue,  7 Jul 2020 15:52:00 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id CC4A822055E; Tue,  7 Jul 2020 11:51:59 -0400 (EDT)
Date:   Tue, 7 Jul 2020 11:51:59 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Fabian <godi.beat@gmx.net>
Subject: Re: overlayfs: issue with a replaced lower squashfs with export-table
Message-ID: <20200707155159.GA48341@redhat.com>
References: <32532923.JtPX5UtSzP@fgdesktop>
 <CAOQ4uxjm7i+uO4o4470ACctsft1m18EiUpxBfCeT-Wyqf1FAYg@mail.gmail.com>
 <106271350.sqX05tTuFB@fgdesktop>
 <CAOQ4uxgT_cmFPm_mnpQtjWqhd=3vOAiFLdw_z6Y_=FSxr+3nfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgT_cmFPm_mnpQtjWqhd=3vOAiFLdw_z6Y_=FSxr+3nfg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jul 07, 2020 at 08:51:53AM +0300, Amir Goldstein wrote:
> On Mon, Jul 6, 2020 at 6:14 PM Fabian <godi.beat@gmx.net> wrote:
> >
> > Hi Amir,
> >
> > thanks for your mail and the quick reply!
> >
> > Am Montag, 6. Juli 2020, 16:29:51 CEST schrieb Amir Goldstein:
> > > > We are seeing problems using an read-writeable overlayfs (upper) on a
> > > > readonly squashfs (lower). The squashfs gets an update from time to time
> > > > while we keep the upper overlayfs.
> > >
> > > It gets updated while the overlay is offline (not mounted) correct?
> >
> > Yes. We boot into a recovery system outside the rootfs and its overlayfs,
> > replace the lower squashfs, and then reboot into the new system.
> >
> > > > On replaced files we then see -ESTALE ("overlayfs: failed to get inode
> > > > (-116)") messages if the lower squashfs was created _without_ using the
> > > > "-no-exports" switch.
> > > > The -ESTALE comes from ovl_get_inode() which in turn calls
> > > > ovl_verify_inode() and returns on the line where the upperdentry inode
> > > > gets compared
> > > > ( if (upperdentry && ovl_inode_upper(inode) != d_inode(upperdentry)) ).
> > > >
> > > > A little debugging shows, that the upper files dentry name does not fit to
> > > > the dentry name of the new lower dentry as it seems to look for the inode
> > > > on the squashfs "export"-lookup-table which has changed as we replaced
> > > > the lower fs.
> > > >
> > > > Building the lower squashfs with the "-no-exports"-mksquashfs option, so
> > > > without the export-lookup-table, seems to work, but it might be no longer
> > > > exportable using nfs (which is ok and we can keep with it).
> 
> Miklos,
> 
> At first glance I did not understand how changing lower file handles causes
> failure to ovl_verify_inode().
> To complete the picture, here is the explanation.
> 
> Upper file A was copied up from lower file with inode 10 in old squashfs
> and the "origin" file handle composed of the inode number 10 is recorded
> in upper file A.
> 
> With newly formatted lower, lower A has inode 11 and lower B has inode 10.
> Upper file B is copied from lower file B with inode 10 in new squashfs and
> the "origin" file handle composed of the inode number 10 is recorded
> in upper file B.
> Now we have two upper files with the same "origin" that are not hardlinks.
> 
> On lookup of both overlay files A and B, ovl_check_origin() decodes lower
> file B (inode 10) as the lower inode.
> This lower inode is used to get the overlay inode number (10) and as
> the key to hash overlay inode in inode cache.
> 
> Suppose A is looked up first and it's inode is hashed.
> Then B is looked up and in ovl_get_inode() it finds the inode hashed
> by the same lower inode in inode cache, but fails ovl_verify_inode()
> because:
> d_inode(upperdentry) /* B */ != ovl_inode_upper(inode) /* A */
> 
> This can also happen when copying overlay layers to a new
> fs tree and carrying over the old "origin" xattr.
> In practice, the UUID part of the stored "origin" xattr is meant to
> protect against decoding lower fh when migrating to another
> filesystem, but layers could be migrated inside the same filesystem.
> Since squashfs does not have a UUID, re-creating sqhashfs is similar
> to migrating layers inside the same filesystem.

Hi Amir,

So we can't use "origin" if lower layers have been copied. If they
have been copied to a different filesystem with uuid we seem to
have a mechanism to detect it but otherwise not and we can run
into these kind of issues.

My question is, why do we allow copying or updating lower layers
with same upper when we know this will break stored origin in
upper. Can't I do same thing with ext4/xfs, where I recreate
lower layers when inode numbers get exchanged  and same problem
will happen (despite uuid being same). 

IOW, how can we support copying layers (with same upper) while origin
is in use. Rest of the features are built on top of the assumption
that origin is valid. And in case of copying layers, we don't
seem to have a sure way to find if origin is valid or not.

Should we put a restrictions that if lower layers are updated or
moved then upper should be rotated as lower layer and a new
fresh upper should be used instead?

I might be missing something very fundamental, but before I try
to understand fine details of all the features built on top of
"origin", I fail to understand that how can we allow changing
lower layers and still expect "origin" to be valid and use it.

Thanks
Vivek
> 
> We were aware of the "layer migration" case when designing the
> index/nfs_export feature, which is one of the reasons they are
> opt-in features.
> 
> But we enabled the functionality of following non-dir origin
> unconditionally because we *thought* it is harmless, as the comment
> in ovl_lookup() says:
> 
>          /*
>          * Lookup copy up origin by decoding origin file handle.
>          * We may get a disconnected dentry, which is fine,
>          * because we only need to hold the origin inode in
>          * cache and use its inode number.  We may even get a
>          * connected dentry, that is not under any of the lower
>          * layers root.  That is also fine for using it's inode
>          * number - it's the same as if we held a reference
>          * to a dentry in lower layer that was moved under us.
>          */
> 
> The patch I posted disabled decoding of non-dir origin for the special
> case of lower null uuid.
> 
> I think we can also warn and auto-disable decoding non-dir origin in
> case index is disabled and we detect this upper inode conflict in
> ovl_verify_inode().
> 
> The problem is if A is not metacopy and looked up first, and B is
> metacopy and looked up second, then conflict will be deleted after
> the wrong inode has been hashed.
> 
> Perhaps we should disable decoding non-dir origin with in case
> metacopy=on,index=off?
> Maybe also provide a user option to disable decoding non-dir origin
> at the price of losing persistent inode number for copied up non-dir?
> Something like 'index=nofollow'.
> 
> Thoughts?
> Am I overthinking this?
> 
> Thanks,
> Amir.
> 

