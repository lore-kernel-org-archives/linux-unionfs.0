Return-Path: <SRS0=Lx5L=AZ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E11C433DF
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 13:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C08E122365
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 13:41:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PFpXnTwY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgGNNll (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 09:41:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52775 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725906AbgGNNll (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Jul 2020 09:41:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594734100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=veNOogqWTcIwuAhjE9Hi9GBD843Sn0eUmLmx5dQzjuQ=;
        b=PFpXnTwY+itzT22+RNLGQFPSkYEXQtW9/EI8PnQwfUHkTGHPNlAn/r2ECmQqohlTkDfsQ1
        egYefWN3gb2BqaYMxmfuKM4HtySLlRx6SY36YZNqqKS/XqwbN/KwBkz4QLAw66+duNLQfh
        curMv393zNhlSVAgwE0XClxB52SyrY8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-3G8wFVbDOEa92utVbVZkRw-1; Tue, 14 Jul 2020 09:41:38 -0400
X-MC-Unique: 3G8wFVbDOEa92utVbVZkRw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 280688027E1;
        Tue, 14 Jul 2020 13:41:37 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-205.rdu2.redhat.com [10.10.115.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5903F10013C3;
        Tue, 14 Jul 2020 13:41:36 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id E3EA72237D7; Tue, 14 Jul 2020 09:41:35 -0400 (EDT)
Date:   Tue, 14 Jul 2020 09:41:35 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Josh England <jjengla@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH RFC 1/2] ovl: invalidate dentry with deleted real dir
Message-ID: <20200714134135.GC324688@redhat.com>
References: <20200713105732.2886-1-amir73il@gmail.com>
 <20200713105732.2886-2-amir73il@gmail.com>
 <20200713192517.GA286591@redhat.com>
 <CAOQ4uxiXWH2RtXdLXRJY-pcZt=zFK-urhcTSQYNbPpmMjFCJdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiXWH2RtXdLXRJY-pcZt=zFK-urhcTSQYNbPpmMjFCJdw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jul 14, 2020 at 06:28:41AM +0300, Amir Goldstein wrote:
> On Mon, Jul 13, 2020 at 10:25 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Mon, Jul 13, 2020 at 01:57:31PM +0300, Amir Goldstein wrote:
> > > Changes to underlying layers while overlay in mounted result in
> > > undefined behavior.  Therefore, we can change the behavior to
> > > invalidate the overlay dentry on dcache lookup if one of the
> > > underlying dentries was deleted since the dentry was composed.
> > >
> > > Negative underlying dentries are not expected in overlay upper and
> > > lower dentries.  If they are found it is probably dcache lookup racing
> > > with an overlay unlink, before d_drop() was called on the overlay dentry.
> > > IS_DEADDIR directories may be caused by underlying rmdir, so invalidate
> > > overlay dentry on dcache lookup if we find those.
> >
> > Can you elaborate a bit more on this race. Doesn't inode_lock_nested(dir)
> > protect against that. I see that both vfs_rmdir() and vfs_unlink()
> > happen with parent directory inode mutex held exclusively. And IIUC,
> > that should mean no further lookup()/->revalidate() must be in progress
> > on that dentry? I might very well be wrong, hence asking for more
> > details.
> >
> 
> lookup_fast() looks in dcache without dir inode lock.
> d_revalidate() is called to check if the found cached dentry is valid.

Got it.

> 
> For example, ovl_remove_upper() can make an upper dentry negative
> or upper dir inode S_DEAD (i.e. vfs_rmdir) just before calling d_drop()
> to prevent overlay dentry from being found in fast cache lookup.
> 
> Unless I am missing something, that leaves a small window where
> lookup_fast() can return an overlay dentry with negative/S_DEAD
> upper dentry, which was not caused by illegitimate underlying fs
> changes, so we must gracefully invalidate the dcache lookup
> (return 0 from revalidate) in order to fallback to fs lookup.

So what's the side affect of this? I mean one even you make this change,
it is possible that on a cpu parallel unlink is going on and right
after d_revalidate() finishes, upper is marked negative (or directory
S_DEAD).

So this change will not plug the hole. It will just narrow it a bit?

/me is failing to see complete picture that what's the problem at
macro level and how this patch fixes it.

Thanks
Vivek

