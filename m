Return-Path: <SRS0=+UIx=6F=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C1A4C54FCC
	for <linux-unionfs@archiver.kernel.org>; Tue, 21 Apr 2020 19:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 410282072D
	for <linux-unionfs@archiver.kernel.org>; Tue, 21 Apr 2020 19:32:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hyozcavT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgDUTcB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 15:32:01 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39081 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726362AbgDUTcB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 21 Apr 2020 15:32:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587497520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NuJ/vEabFlRUXwHVpUNP5StibMYd5Gb2bvoLZEGwlA4=;
        b=hyozcavTyzPzfnBUfUUJRdnEtwg+gfE4PDkoBYjOaIRBmCAoWuyYSEJP44TW5FvUbS+R6I
        MZL/41a7J9h40R2yNjNQsZtOZ4tnPkNolpWUO36dpMLj0pa9WsxNWkqw5qZqOOeS9G80oF
        tU7WK/Ty5nhCYUSZrA1kce2uYi2WNoE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-2Izi8nCfNuW1T9Z7xsOWhg-1; Tue, 21 Apr 2020 15:31:58 -0400
X-MC-Unique: 2Izi8nCfNuW1T9Z7xsOWhg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 662191934101;
        Tue, 21 Apr 2020 19:31:57 +0000 (UTC)
Received: from horse.redhat.com (ovpn-113-152.rdu2.redhat.com [10.10.113.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BE2960C88;
        Tue, 21 Apr 2020 19:31:54 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id DD1B9220E74; Tue, 21 Apr 2020 15:31:53 -0400 (EDT)
Date:   Tue, 21 Apr 2020 15:31:53 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        virtio-fs-list <virtio-fs@redhat.com>
Subject: Re: [PATCH] overlayfs: Pass O_TRUNC flag to underlying filesystem
Message-ID: <20200421193153.GD28740@redhat.com>
References: <20200421184107.GC28740@redhat.com>
 <CAJfpeguGqLxA14unqNx-nExCWKs1Tv_0MwqGohHnuW-ugcjDyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguGqLxA14unqNx-nExCWKs1Tv_0MwqGohHnuW-ugcjDyQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 21, 2020 at 08:59:24PM +0200, Miklos Szeredi wrote:
> On Tue, Apr 21, 2020 at 8:41 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > As of now during open(), we don't pass bunch of flags to underlying
> > filesystem. O_TRUNC is one of these. Normally this is not a problem as VFS
> > calls ->setattr() with zero size and underlying filesystem sets file size
> > to 0.
> >
> > But when overlayfs is running on top of virtiofs, it has an optimization
> > where it does not send setattr request to server if dectects that
> > truncation is part of open(O_TRUNC). It assumes that server already zeroed
> > file size as part of open(O_TRUNC).
> >
> > fuse_do_setattr() {
> >         if (attr->ia_valid & ATTR_OPEN) {
> >                 /*
> >                  * No need to send request to userspace, since actual
> >                  * truncation has already been done by OPEN.  But still
> >                  * need to truncate page cache.
> >                  */
> >         }
> > }
> >
> > IOW, fuse expects O_TRUNC to be passed to it as part of open flags.
> >
> > But currently overlayfs does not pass O_TRUNC to underlying filesystem
> > hence fuse/virtiofs breaks. Setup overlayfs on top of virtiofs and
> > following does not zero the file size of a file is either upper only
> > or has already been copied up.
> >
> > fd = open(foo.txt, O_TRUNC | O_WRONLY);
> >
> > Fix it by passing O_TRUNC to underlying filesystem.
> 
> 
> Or clear ATTR_OPEN in ovl_setattr()
> 
> Need to think about side effects of passing O_TRUNC down to underlying
> fs.   Clearing ATTR_OPEN seems obviously safe, so as a quick fix I'd
> rather go with that for now.

Ok, I will send another patch which clears ATTR_OPEN in ovl_setattr().

Thanks
Vivek

