Return-Path: <SRS0=jndh=7J=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B5DC433E0
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 May 2020 18:47:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4E1E207E8
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 May 2020 18:47:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LE4J99aO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgE0Sr3 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 27 May 2020 14:47:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46464 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726074AbgE0Sr3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 27 May 2020 14:47:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590605248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1dT1ajDFhBdPK0uPEEH8mzrQ7Xpol+GVqy4p1Y5DTQE=;
        b=LE4J99aOmL4haS/AL+zSXte16dUTLDZfYktaM46E1k0OCdsZwDg/Vc4+mJDl/t3k0+wfaQ
        1WJ4jc84G2cnquT7DDdkn/qPh9mPqb3+xqVCQKm7/hkZilIYOy4T41Qz2QAbHwwfVgT37m
        iPg72tDQ376ON8EAkmfrBu+wyvIl/CY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-N4hk76TsN0qyUexsA0TT2g-1; Wed, 27 May 2020 14:47:26 -0400
X-MC-Unique: N4hk76TsN0qyUexsA0TT2g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30587835B41;
        Wed, 27 May 2020 18:47:25 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-83.rdu2.redhat.com [10.10.116.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AECC71084404;
        Wed, 27 May 2020 18:47:24 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 2BDB1220391; Wed, 27 May 2020 14:47:24 -0400 (EDT)
Date:   Wed, 27 May 2020 14:47:24 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     yangerkun <yangerkun@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH] ovl: fix some bug exist in ovl_get_inode
Message-ID: <20200527184724.GB140950@redhat.com>
References: <20200527041711.60219-1-yangerkun@huawei.com>
 <CAOQ4uxjjUjEzvy=b96FZPGt4nhOfwFk1_XE2Po9scYDiPPkJgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjjUjEzvy=b96FZPGt4nhOfwFk1_XE2Po9scYDiPPkJgQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, May 27, 2020 at 02:16:00PM +0300, Amir Goldstein wrote:

[..]
> > After check the code, there may some bug need to fix:
> > 1. We need to call iput once ovl_check_metacopy_xattr fail.
> > 2. We need to call unlock_new_inode or the above iput(also with iput in
> >    ovl_create_object) will trigger the a WARN_ON since  the I_NEW still
> >    exists.
> > 3. We should move the init for upperdentry to the place below
> >    ovl_check_metacopy_xattr. Or the dentry reference will decrease to
> >    -1(error path in ovl_create_upper will inc, ovl_destroy_inode too).
> >
> 
> OR we don't check metacopy xattr in ovl_get_inode().
> 
> In ovl_lookup() we already checked metacopy xattr.
> No reason to check it again in this subtle context.
> 
> In ovl_lookup() can store value of upper metacopy and after we get
> the inode, set the OVL_UPPERDATA inode flag according to
> upperdentry && !uppermetacopy.

I think reason behind initializing this attr in ovl_get_inode() was
that this is OVL_UPPERDATA is an inode property. So conceptually
it makes sense to initialize it when inode is being instantiated. And
that too under lock so that there are no races.

I was trying to think if we can trigger a race if we move OVL_UPPERDATA
initialization in ovl_lookup(). But given this is only one way
transition, I could not think of any. So for this speicific flag,
it probably is ok to initialize outside of ovl_get_inode().

Vivek

