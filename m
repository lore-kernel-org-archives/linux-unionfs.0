Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D20AFC2D0E4
	for <linux-unionfs@archiver.kernel.org>; Tue, 17 Nov 2020 18:30:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F5E92222E
	for <linux-unionfs@archiver.kernel.org>; Tue, 17 Nov 2020 18:30:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W4/xPUn+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbgKQS3y (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 13:29:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53846 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726993AbgKQS3x (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Nov 2020 13:29:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605637786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n+sA9RW4IaMrLL5m5pqRfekzWZqlArjiOjWWeiCtFB4=;
        b=W4/xPUn+tYR45KkIp8Sh04yjuI8hPQ4R8+F62XBue1yQ94ZqKB3fS8C4ulkn5a3FeolXKa
        BtOWmyq+qyAVmZlSLM5YQFuUwEsXfi+JeppYac9u7ROstFUubMDTRiQ3jfwWhGNk3d7nv+
        ypFuJUR1EjcbHQvOi68t+r55aGbaYz4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-Cv_DgJ4pPIqspP4wf8EJZw-1; Tue, 17 Nov 2020 13:29:43 -0500
X-MC-Unique: Cv_DgJ4pPIqspP4wf8EJZw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 720BB809DE4;
        Tue, 17 Nov 2020 18:29:41 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-186.rdu2.redhat.com [10.10.116.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 077F419931;
        Tue, 17 Nov 2020 18:29:41 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 4314B220BCF; Tue, 17 Nov 2020 13:29:40 -0500 (EST)
Date:   Tue, 17 Nov 2020 13:29:40 -0500
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sargun Dhillon <sargun@sargun.me>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Chengguang Xu <cgxu519@mykernel.net>
Subject: Re: [RFC PATCH 3/3] overlay: Add the ability to remount volatile
 directories when safe
Message-ID: <20201117182940.GA91497@redhat.com>
References: <20201116144240.GA9190@redhat.com>
 <CAOQ4uxgMmxhT1fef9OtivDjxx7FYNpm7Y=o_C-zx5F+Do3kQSA@mail.gmail.com>
 <20201116163615.GA17680@redhat.com>
 <CAOQ4uxgTXHR3J6HueS_TO5La890bCfsWUeMXKgGnvUth26h29Q@mail.gmail.com>
 <20201116210950.GD9190@redhat.com>
 <CAOQ4uxhkRauEM46nbhZuGdJmP8UGQpe+fw_FtXy+S4eaR4uxTA@mail.gmail.com>
 <20201117144857.GA78221@redhat.com>
 <CAOQ4uxg1ZNSid58LLsGC2tJLk_fpJfu13oOzCz5ScEi6y_4Nnw@mail.gmail.com>
 <20201117164600.GC78221@redhat.com>
 <CAOQ4uxgi-8sn4S3pRr0NQC5sjp9fLmVsfno1nSa2ugfM2KQLLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgi-8sn4S3pRr0NQC5sjp9fLmVsfno1nSa2ugfM2KQLLQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Nov 17, 2020 at 08:03:16PM +0200, Amir Goldstein wrote:
> > > C. "shutdown" the filesystem if writeback errors happened and return
> > >      EIO from any read, like some blockdev filesystems will do in face
> > >      of metadata write errors
> > >
> > > I happen to have a branch ready for that ;-)
> > > https://github.com/amir73il/linux/commits/ovl-shutdown
> >
> >
> > This branch seems to implement shutdown ioctl. So it will still need
> > glue code to detect writeback failure in upper/ and trigger shutdown
> > internally?
> >
> 
> Yes.
> ovl_get_acess() can check both the administrative ofs->goingdown
> command and the upper writeback error condition for volatile ovl
> or something like that.

This approach will not help mmaped() pages though, if I do.

- Store to addr
- msync
- Load from addr

There is a chance that I can still read back old data.

> 
> > And if that works, then Sargun's patches can fit in nicely on top which
> > detect writeback failures on remount and will shutdown fs.
> >
> 
> Not sure why remount needs to shutdown. It needs to fail mount,
> but yeh, all those things should fit nicely together.

Agreed. mount/remount can just fail in that case.

Thanks
Vivek

