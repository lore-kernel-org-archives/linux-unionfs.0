Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E946BC63798
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Nov 2020 14:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE958222E8
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Nov 2020 14:46:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QdfgBu+J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730089AbgKPOp6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 16 Nov 2020 09:45:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51150 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728041AbgKPOp6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Nov 2020 09:45:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605537957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G2yZuUK5rvJlxcTrXiv5FpmPzxlTn1OazswLcthtf3I=;
        b=QdfgBu+Jyns6jHPpU/sm+q+mAEKWz+w37XmFvn8LIkUvAaMW4jswk6MV1rvFqF+7iXl+Yy
        af54upCaLZG7NeFB1jR1N/IemyObpTD2TJGV5dcZXkd66AdyRBVOwJSh8+P1fqz9kwt8Yy
        lC7LhA6xyfGczrr35xgfK1/LiwZWioM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-MfnGIqTEMoClN6YAGWoPQg-1; Mon, 16 Nov 2020 09:45:50 -0500
X-MC-Unique: MfnGIqTEMoClN6YAGWoPQg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C914FCE659;
        Mon, 16 Nov 2020 14:45:24 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-201.rdu2.redhat.com [10.10.114.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE02760C05;
        Mon, 16 Nov 2020 14:45:23 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 4E7A0220BCF; Mon, 16 Nov 2020 09:45:23 -0500 (EST)
Date:   Mon, 16 Nov 2020 09:45:23 -0500
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Sargun Dhillon <sargun@sargun.me>
Cc:     linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH 3/3] overlay: Add the ability to remount volatile
 directories when safe
Message-ID: <20201116144523.GB9190@redhat.com>
References: <20201116045758.21774-1-sargun@sargun.me>
 <20201116045758.21774-4-sargun@sargun.me>
 <20201116144240.GA9190@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116144240.GA9190@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Nov 16, 2020 at 09:42:40AM -0500, Vivek Goyal wrote:
> On Sun, Nov 15, 2020 at 08:57:58PM -0800, Sargun Dhillon wrote:
> > Overlayfs added the ability to setup mounts where all syncs could be
> > short-circuted in (2a99ddacee43: ovl: provide a mount option "volatile").
> > 
> > A user might want to remount this fs, but we do not let the user because
> > of the "incompat" detection feature. In the case of volatile, it is safe
> > to do something like[1]:
> > 
> > $ sync -f /root/upperdir
> > $ rm -rf /root/workdir/incompat/volatile
> > 
> > There are two ways to go about this. You can call sync on the underlying
> > filesystem, check the error code, and delete the dirty file if everything
> > is clean. If you're running lots of containers on the same filesystem, or
> > you want to avoid all unnecessary I/O, this may be suboptimal.
> > 
> 
> Hi Sargun,
> 
> I had asked bunch of questions in previous mail thread to be more
> clear on your requirements but never got any response. It would
> have helped understanding your requirements better.
> 
> How about following patch set which seems to sync only dirty inodes of
> upper belonging to a particular overlayfs instance.
> 
> https://lore.kernel.org/linux-unionfs/20201113065555.147276-1-cgxu519@mykernel.net/
> 
> So if could implement a mount option which ignores fsync but upon
> syncfs, only syncs dirty inodes of that overlayfs instance, it will
> make sure we are not syncing whole of the upper fs. And we could
> do this syncing on unmount of overlayfs and remove dirty file upon
> successful sync.
> 
> Looks like this will be much simpler method and should be able to
> meet your requirements (As long as you are fine with syncing dirty
> upper inodes of this overlay instance on unmount).

This approach also has the advantage error detection is much more granular
and you don't have to throw away container A if there was a writeback
issue in any other unrelated container N sharing same upper.

Thanks
Vivek

