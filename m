Return-Path: <SRS0=JIvn=AS=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75DB3C433DF
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Jul 2020 21:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BF1B20663
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Jul 2020 21:53:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bp0kYfzK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgGGVxQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 7 Jul 2020 17:53:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35008 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728357AbgGGVxQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Jul 2020 17:53:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594158793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IbauxBjo6iIVkUePUO3LjtqDa+geYnpMcPlufTvqL10=;
        b=Bp0kYfzKvs4cbCMYuPrJvq4tSTDj05HuPHztb/ookPoEeza1gGR4Rp2vWXgpvdHgtjZvdE
        nw8DcJPi9mxbg7t43/ycNz5RxQ/cq9h0vnpu3A0r3aCBunhwn7Gu9BLkBU2pofAhUmBsOq
        E4raEw7pbzIvFVOy3Po82gn9Z2GXqJ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-iLftb_mKNPCYzaf9WD3L3w-1; Tue, 07 Jul 2020 17:53:12 -0400
X-MC-Unique: iLftb_mKNPCYzaf9WD3L3w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB1D719200C0;
        Tue,  7 Jul 2020 21:53:10 +0000 (UTC)
Received: from horse.redhat.com (ovpn-113-156.rdu2.redhat.com [10.10.113.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D828797F3;
        Tue,  7 Jul 2020 21:53:10 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 8FADB22055E; Tue,  7 Jul 2020 17:53:09 -0400 (EDT)
Date:   Tue, 7 Jul 2020 17:53:09 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Fabian <godi.beat@gmx.net>
Subject: Re: overlayfs: issue with a replaced lower squashfs with export-table
Message-ID: <20200707215309.GB48341@redhat.com>
References: <32532923.JtPX5UtSzP@fgdesktop>
 <CAOQ4uxjm7i+uO4o4470ACctsft1m18EiUpxBfCeT-Wyqf1FAYg@mail.gmail.com>
 <106271350.sqX05tTuFB@fgdesktop>
 <CAOQ4uxgT_cmFPm_mnpQtjWqhd=3vOAiFLdw_z6Y_=FSxr+3nfg@mail.gmail.com>
 <20200707155159.GA48341@redhat.com>
 <CAOQ4uxhMq_8xwCU2t+WveTGgc9MAWE2RD66q5UjQ1r09EoLzHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhMq_8xwCU2t+WveTGgc9MAWE2RD66q5UjQ1r09EoLzHA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jul 07, 2020 at 08:41:20PM +0300, Amir Goldstein wrote:
> > > Miklos,
> > >
> > > At first glance I did not understand how changing lower file handles causes
> > > failure to ovl_verify_inode().
> > > To complete the picture, here is the explanation.
> > >
> > > Upper file A was copied up from lower file with inode 10 in old squashfs
> > > and the "origin" file handle composed of the inode number 10 is recorded
> > > in upper file A.
> > >
> > > With newly formatted lower, lower A has inode 11 and lower B has inode 10.
> > > Upper file B is copied from lower file B with inode 10 in new squashfs and
> > > the "origin" file handle composed of the inode number 10 is recorded
> > > in upper file B.
> > > Now we have two upper files with the same "origin" that are not hardlinks.
> > >
> > > On lookup of both overlay files A and B, ovl_check_origin() decodes lower
> > > file B (inode 10) as the lower inode.
> > > This lower inode is used to get the overlay inode number (10) and as
> > > the key to hash overlay inode in inode cache.
> > >
> > > Suppose A is looked up first and it's inode is hashed.
> > > Then B is looked up and in ovl_get_inode() it finds the inode hashed
> > > by the same lower inode in inode cache, but fails ovl_verify_inode()
> > > because:
> > > d_inode(upperdentry) /* B */ != ovl_inode_upper(inode) /* A */
> > >
> > > This can also happen when copying overlay layers to a new
> > > fs tree and carrying over the old "origin" xattr.
> > > In practice, the UUID part of the stored "origin" xattr is meant to
> > > protect against decoding lower fh when migrating to another
> > > filesystem, but layers could be migrated inside the same filesystem.
> > > Since squashfs does not have a UUID, re-creating sqhashfs is similar
> > > to migrating layers inside the same filesystem.
> >
> > Hi Amir,
> >
> > So we can't use "origin" if lower layers have been copied. If they
> > have been copied to a different filesystem with uuid we seem to
> > have a mechanism to detect it but otherwise not and we can run
> > into these kind of issues.
> >
> 
> Correct.
> 
> > My question is, why do we allow copying or updating lower layers
> > with same upper when we know this will break stored origin in
> > upper.
> 
> I don't know if we "allow" this.

So there seem to two cases. One is copying the lower layers to same
filesystem or a different filesystem. And another case is recreating
the lower layers and use previous upper with old upper. IIUC, we
are currently facing problem with second scenario.

"copying the lower layers" is probably fine as you said because old
tree still keeps that inode number busy and newly created inode
should not acquire that number. 

But in this case looks like we recreated lower and that led to 
some file B acquiring an inode number which was used by A. So
this is a different use case. IIUC, simply copying the layer
will not lead to this situation.

Now question is do we support recreating the lower layer with existing
upper. And I see following text in "Sharing and copying layer"

"Mounting an overlay using an upper layer path, where the upper layer path
was previously used by another mounted overlay in combination with a
different lower layer path, is allowed, unless the "inodes index" feature
or "metadata only copy up" feature is enabled."

This seems to suggest that recreating lower layer is allowed as long
as you are not using index or metacopy feature. 

If that's the case, probably "origin" should have been an opt-in
feature or automatically be enabled by some other opt-in feature.


> We never considered the case expect
> for nfs export and index, see overlayfs.rst:
> "When the overlay NFS export feature is enabled, overlay filesystems
> behavior on offline changes of the underlying lower layer is different
> than the behavior when NFS export is disabled. ..."
> 
> > Can't I do same thing with ext4/xfs, where I recreate
> > lower layers when inode numbers get exchanged  and same problem
> > will happen (despite uuid being same).
> >
> 
> Same problem.

> 
> > IOW, how can we support copying layers (with same upper) while origin
> > is in use. Rest of the features are built on top of the assumption
> > that origin is valid. And in case of copying layers, we don't
> > seem to have a sure way to find if origin is valid or not.
> >
> 
> With index/nfs_export enabled we at least do:
> /* Verify lower root is upper root origin */
> and if verification fails we disable the feature.

So discrepancy is still possible if somebody modifies lower layers
without changing lower root.

- Copy up file A.
- Unmount overlay
- unlink A
- create B (assume B gets same inode number as A).
- mount overlay; B gets copied up.

And now we have both upper A and B having same origin despite no
hardlink. Am I understanding it right?

Is there a good use case for allowing modifying lower layers with
same upper. Given we are adding more complex features to overlayfs,
will it make sense to not allow modifying lower layer going forward.
We might not be able to detect it but atleast it will be unsupported
configuration. And then we can only focus to provide a work around
for existing use cases.

[..]
> > >
> > > We were aware of the "layer migration" case when designing the
> > > index/nfs_export feature, which is one of the reasons they are
> > > opt-in features.
> > >
> > > But we enabled the functionality of following non-dir origin
> > > unconditionally because we *thought* it is harmless, as the comment
> > > in ovl_lookup() says:
> > >
> > >          /*
> > >          * Lookup copy up origin by decoding origin file handle.
> > >          * We may get a disconnected dentry, which is fine,
> > >          * because we only need to hold the origin inode in
> > >          * cache and use its inode number.  We may even get a
> > >          * connected dentry, that is not under any of the lower
> > >          * layers root.  That is also fine for using it's inode
> > >          * number - it's the same as if we held a reference
> > >          * to a dentry in lower layer that was moved under us.
> > >          */
> > >
> > > The patch I posted disabled decoding of non-dir origin for the special
> > > case of lower null uuid.
> > >
> > > I think we can also warn and auto-disable decoding non-dir origin in
> > > case index is disabled and we detect this upper inode conflict in
> > > ovl_verify_inode().
> > >
> > > The problem is if A is not metacopy and looked up first, and B is
> > > metacopy and looked up second, then conflict will be deleted after
> > > the wrong inode has been hashed.

We don't allow modifying lower layers if metacopy is enabled.

"For "metadata only copy up" feature there is no verification mechanism at
mount time. So if same upper is mounted with different set of lower, mount
probably will succeed but expect the unexpected later on. So don't do it.
"

So if somebody is recreating lower or modifying lower with metacopy
on, its an unsupported configuration.

Thanks
Vivek

