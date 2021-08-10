Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E4EC4338F
	for <linux-unionfs@archiver.kernel.org>; Tue, 10 Aug 2021 19:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B08D60E09
	for <linux-unionfs@archiver.kernel.org>; Tue, 10 Aug 2021 19:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbhHJTt1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 10 Aug 2021 15:49:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49701 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232158AbhHJTtZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 10 Aug 2021 15:49:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628624943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dlfzC09yimoixVF6KjWbYHO5F6Yb8bDrB0XdgXep8KE=;
        b=gM5bp4Dc5IeSHayIX1OAD1lHmBPiB2WlYVA2VPKRH4ggHAH7Db0yfXWkYw0X3tCLwvpmya
        iZbN9H7DaxTXN8f/65S/EUgn4IGjrzrwLZeCsgFtS6sXm8U0smLyfXhkS6f5j2eYrxNLFE
        E0FSIbENk2/uXFBjQVZclcDsmTzvUE8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-dWh8PvR0MkCS1FFF_6-cXQ-1; Tue, 10 Aug 2021 15:49:01 -0400
X-MC-Unique: dWh8PvR0MkCS1FFF_6-cXQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10404801A92;
        Tue, 10 Aug 2021 19:49:00 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.22.9.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEDDF2854F;
        Tue, 10 Aug 2021 19:48:55 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 624942237F5; Tue, 10 Aug 2021 15:48:55 -0400 (EDT)
Date:   Tue, 10 Aug 2021 15:48:55 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Zhihao Cheng <chengzhihao1@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Nalin Dahyabhai <nalin@redhat.com>
Subject: Re: [QUESTION] Why overlayfs cannot mounted as nfs_export and
 metacopy?
Message-ID: <YRLYJ4uXLNR7NSmi@redhat.com>
References: <ec78de1b-4edb-1eea-5c0d-79e65f139d79@huawei.com>
 <CAOQ4uxiO7zt7sywNqyd-WwCVds9-NqRAixham9yVeN7F+JhXoA@mail.gmail.com>
 <CAOQ4uxhAGSPKx6xsa5w_Wn9sax8LQQ=dPhB7Dtn1XDwghNpgvg@mail.gmail.com>
 <YRGfmx+xXVvERhhx@redhat.com>
 <CAOQ4uxhih4z=0xtuN4X11DY1xdhzsaQRDrtwuWFP2bejc41dWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhih4z=0xtuN4X11DY1xdhzsaQRDrtwuWFP2bejc41dWA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Aug 10, 2021 at 07:17:23AM +0300, Amir Goldstein wrote:
> On Tue, Aug 10, 2021 at 12:35 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Sat, Aug 07, 2021 at 07:37:00PM +0300, Amir Goldstein wrote:
> > > On Sat, Aug 7, 2021 at 2:05 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > >
> > > > On Sat, Aug 7, 2021 at 1:17 PM Zhihao Cheng <chengzhihao1@huawei.com> wrote:
> > > > >
> > > > > Hi, all.
> > > > >
> > > > > As title said. I wonder to know the reason for overlayfs mount failure
> > > > > with '-o nfs_export=on,metacopy=on'.
> > > > >
> > > > > I modified kernel to enable these two options 'on',  it looks like that
> > > > > overlayfs can still work fine under nfs_v4.
> > > > >
> > > > > Besides, I can get no more information about the reason from source
> > > > > code, maybe I missed something.
> > > > >
> > > >
> > > > It's because ovl_obtain_alias() (decoding a disconnected non-dir file handle)
> > > > does not know how to construct a metacopy overlayfs inode.
> > > >
> > > > Maybe Vivek will be able to point you to the discussion that lead to making
> > > > the features mutually exclusive.
> > > >
> > > > I don't remember any other reason.
> > > >
> > >
> > > I remembered some more details...
> > >
> > > I think the main complication discussed w.r.t decoding a metacopy
> > > inode was for the case where ovl_inode_lowerdata() differs from
> > > ovl_inode_lower().
> > >
> > > If we had a weaker variant of metacopy (e.g. metacopy=upper) that
> > > only allows creating and following metacopy inodes in the upper layer,
> > > it would have been simpler to implement ovl_obtain_alias().
> > >
> > > Specifically, when ofs->numlayer == 2 (single lower layer), there can
> > > be no valid metacopy inodes in the lower layer, so that configuration
> > > should also be rather easy to support.
> >
> > Hi Amir,
> >
> > /me does not understand well the notion of disconnected dentries and
> >  how nfs export stuff works. So please bear with my stupid questions.
> 
> No stupid questions ;-)
> 
> Without getting into the hairy details of nfs export there are a few basic
> things to consider:
> - A file handle does not encode the path, only an inode identifier
> - A non-directory inode may have multiple paths (hardlinks)
> - Most filesystems do not store path information in inode on-disk for
>   non-directory inode (the ".." entry stores the path for a directory)
> - When filesystem is asked to decode a file handle and does not find the
>   inode in question in inode cache nor a dentry in dcache, the only resort
>   is to instantiate a "disconnected" dentry with unknown path
> - Later "normal" lookup() by path that resolves to the same inode, does not
>   make that "disconnected" dentry connected. Istead, lookup() instantiates
>   another connected dentry "alias" to the same inode
> 
> All this has some implications when enabling nfs_export for overlayfs:
> 1. ovl_obtain_dentry() needs to be able to cope with a disconnected
>     'real' dentry
> 2. Since ovl_obtain_dentry() cannot assume to know the path of the
>     'real' dentry, it needs to know how to instantiate a disconnected
>     overlayfs dentry
> 3. Other overlayfs code needs to be able to cope with a disconnected
>     overlayfs dentry (for example, copy up only to index)

Hi Amir,

Thanks for giving a summary. It helps a lot.

> 
> >
> > I am wondering why a lower inode can't be metacopy inode. For the
> > normal lookup case, we can lookup in all lower layers and figure out
> > which is actual data inode and which inodes are metacopy inodes.
> >
> > For the case of disconnected dentry, we probably can't do lookup. So
> > are calling underlying filesystem to decode. (Using origin?). If yes,
> > will intermediate lower not have origin xattr which we can use
> > to follow the complete lower chain and reconstruct all real lower
> > dentries and use lower data dentry and latest lower meatacopy dentry
> > (in the same way we do as for lookup).
> 
> We can do that. I did not say we cannot.
> I just said it would be simpler if we can avoid this complication
> and I listed the guidelines for the "simple" implementation.
> 
> But beyond the complexity, what is the benefit?
> I was under the impression that container manager do not know how
> to build images with metacopy, so what are the chances of actually
> seeing metacopy in middle layers in the wild?

Sure, we don't put metacopy inodes into portable images. But I thougt
this could be part of a lower directory on same system. For example,
docker devicemapper driver used to take an image and explode that
on a thin volume. Then it will take a snaphost, modify some files
and prefix that intermediate state with "-init". And then containers
will use this "-init" as base for container rootfs and take snapshot
of this.

I am not sure if container managers are doing this for overlayfs
or not on same system. But I will not be surprised if somebody
decides to do that. That's is change some metadata in image
(which triggers metacopy) and then use upper layer as lower layer
for container rootfs.

[ CC Dan Walsh and Nalin Dahyabhai ]

Dan, Nalin, I think now metacopy feature is being used in podman and
container/storage. Do we ever create lower layers in such a way that
metacopy inodes can be present in lower layers?

> 
> IOW, if we implemented metacopy=upper (only allow metacopy in
> upper layer), would it be sufficient for the use cases that need to enable
> nfs_export?

IMHO, it will be good if we don't add one more variation to metacopy
option. Even if container managers will find it hard to ensure that
there are no metacopy inodes in any of the lower layers. And will
find it difficult to use this option.

IIRC, while adding metacopy option, you had mentioned that it is possible
that intermediate layers have metacopy inodes. So I changed implementation
to take care of it. :-) And now you are the one suggesting not allowing
metacopy inodes in lower layers with nfs_export. :-)

If given a choice, I would prefer that we support metacopy inodes
in lower layers as well with nfs_export and not create a new option
metacopy=upper.

Thanks
Vivek

