Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DBD7C4338F
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Aug 2021 21:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C14C60EE7
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Aug 2021 21:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbhHIVfv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 9 Aug 2021 17:35:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30227 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232334AbhHIVfu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 9 Aug 2021 17:35:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628544929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x3/kxNeWgCjd4F5Wyyk1uxrCDUBvKZrIfKvW3IpXLCY=;
        b=LLUegdAnvmPdJnseU4mqTH4meQMSXw3s42bBKYDmuOs5zMF2r31LEGhIlnkiDcRrN3d/XU
        f26EBZBvJrks8fvUh7oAJPR9FEpNhY/rrONGcIxftahqkIzvq3cNFIg4WTjj8BT/uQlZW6
        wdCJ/cFi09T3yUvvRLBjXEfCkUPj4uQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-HSlr4zkNOXanJ4gjY7W-yQ-1; Mon, 09 Aug 2021 17:35:25 -0400
X-MC-Unique: HSlr4zkNOXanJ4gjY7W-yQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4628210066E6;
        Mon,  9 Aug 2021 21:35:24 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.22.10.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B509B5D9DC;
        Mon,  9 Aug 2021 21:35:23 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 57CDF220261; Mon,  9 Aug 2021 17:35:23 -0400 (EDT)
Date:   Mon, 9 Aug 2021 17:35:23 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Zhihao Cheng <chengzhihao1@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [QUESTION] Why overlayfs cannot mounted as nfs_export and
 metacopy?
Message-ID: <YRGfmx+xXVvERhhx@redhat.com>
References: <ec78de1b-4edb-1eea-5c0d-79e65f139d79@huawei.com>
 <CAOQ4uxiO7zt7sywNqyd-WwCVds9-NqRAixham9yVeN7F+JhXoA@mail.gmail.com>
 <CAOQ4uxhAGSPKx6xsa5w_Wn9sax8LQQ=dPhB7Dtn1XDwghNpgvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhAGSPKx6xsa5w_Wn9sax8LQQ=dPhB7Dtn1XDwghNpgvg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Aug 07, 2021 at 07:37:00PM +0300, Amir Goldstein wrote:
> On Sat, Aug 7, 2021 at 2:05 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Sat, Aug 7, 2021 at 1:17 PM Zhihao Cheng <chengzhihao1@huawei.com> wrote:
> > >
> > > Hi, all.
> > >
> > > As title said. I wonder to know the reason for overlayfs mount failure
> > > with '-o nfs_export=on,metacopy=on'.
> > >
> > > I modified kernel to enable these two options 'on',  it looks like that
> > > overlayfs can still work fine under nfs_v4.
> > >
> > > Besides, I can get no more information about the reason from source
> > > code, maybe I missed something.
> > >
> >
> > It's because ovl_obtain_alias() (decoding a disconnected non-dir file handle)
> > does not know how to construct a metacopy overlayfs inode.
> >
> > Maybe Vivek will be able to point you to the discussion that lead to making
> > the features mutually exclusive.
> >
> > I don't remember any other reason.
> >
> 
> I remembered some more details...
> 
> I think the main complication discussed w.r.t decoding a metacopy
> inode was for the case where ovl_inode_lowerdata() differs from
> ovl_inode_lower().
> 
> If we had a weaker variant of metacopy (e.g. metacopy=upper) that
> only allows creating and following metacopy inodes in the upper layer,
> it would have been simpler to implement ovl_obtain_alias().
> 
> Specifically, when ofs->numlayer == 2 (single lower layer), there can
> be no valid metacopy inodes in the lower layer, so that configuration
> should also be rather easy to support.

Hi Amir,

/me does not understand well the notion of disconnected dentries and
 how nfs export stuff works. So please bear with my stupid questions.

I am wondering why a lower inode can't be metacopy inode. For the
normal lookup case, we can lookup in all lower layers and figure out
which is actual data inode and which inodes are metacopy inodes. 

For the case of disconnected dentry, we probably can't do lookup. So
are calling underlying filesystem to decode. (Using origin?). If yes,
will intermediate lower not have origin xattr which we can use
to follow the complete lower chain and reconstruct all real lower
dentries and use lower data dentry and latest lower meatacopy dentry
(in the same way we do as for lookup).

Thanks
Vivek

> 
> Basically, for ovl_obtain_alias():
> - 'lowerpath' must not have metadata xattr
> - 'upper_alias' must not have metadata xattr
> - If 'index' has metacopy xattr, OVL_UPPERDATA flag
>   should not be set on ovl inode
> 
> But there are bigger complications w.r.t disconnected dentry.
> Overlayfs knows how to decode, work with and copy up
> disconnected dentries (parent is unknown), but in ovl_link(old, ...),
> 'old' dentry must not be a disconnected metacopy dentry when
> calling ovl_set_link_redirect() => ... ovl_get_redirect(), so we will
> also need to:
> - On copy up of a disconnected lower, do not use metacopy
> - Copy up data before ovl_link() when nfs_export is enabled
> - In ovl_obtain_alias(), if 'index' has redirect:
> -- Verify that it is an absolute path that it is resolved to the
> 'lowerpath's inode
> -- oip.redirect needs to be passed to ovl_get_inode()
> -- ovl_verify_inode() needs to verify that oip.redirect matches
>    redirect that is found on existing ovl inode
> 
> And probably other things that I am forgetting...
> 
> Thanks,
> Amir.
> 

