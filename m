Return-Path: <SRS0=lkgI=6G=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D81C55189
	for <linux-unionfs@archiver.kernel.org>; Wed, 22 Apr 2020 08:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78131206B9
	for <linux-unionfs@archiver.kernel.org>; Wed, 22 Apr 2020 08:31:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="j9I9U46b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgDVIbm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 04:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725899AbgDVIbl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 22 Apr 2020 04:31:41 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C6EC03C1A6
        for <linux-unionfs@vger.kernel.org>; Wed, 22 Apr 2020 01:31:41 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id r16so871753edw.5
        for <linux-unionfs@vger.kernel.org>; Wed, 22 Apr 2020 01:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qezUXX+PDmcxlnrQlsWEmrbjJla8YcRWeItkkwAcwoo=;
        b=j9I9U46bH+5xzQSttd9Yte6HlwYULiU912w6TNxyldx3/TlVf9/kA53QbsYvGG3CzW
         7e+0CL1Eu0upU5l8nDmZLBpf4q4nJJBP1Xj+JiD8xAFOJvZV/VBHSZZpeCQ0PGkKQHQB
         NCNOPn6iJD3TnaQg2hEEnZoQKhPPu9lR+Po2c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qezUXX+PDmcxlnrQlsWEmrbjJla8YcRWeItkkwAcwoo=;
        b=kOaVNliC2lq7VLDy2f5UkiRNm3OqhmvjxzC19km7/jphJKZMmyjLP0Gvgq2NBbV3av
         ZoE2XCvmd7PMolxKqW59JjwvdwARSOYk4HYSXWAuB8A21rvdsUAAvrgknmgep6xetSdm
         Qe2SOjtAuJjq02YxgPigam3v291qEsML03vpoQsTl4V+4pDVFTKj6JPkwVy1yqSjckeF
         lWy4iJTK3hwZN7kh9o+QuwHraSq7CVfyZ1Gsg9P0bzbMmOcN9AhR4aXIXsR2bj2Lshas
         ZHE5VqyZ7eWvsPt1gIENMyUwA/gqkE0SeNW/gL2l50+UdZWadZZC2M/Ej03uaM3bcaLL
         7bzQ==
X-Gm-Message-State: AGi0PuabrLSe2KloKf27ObvQAYneqFINKrHtYC/VTWQ+POo5nDwLyiE/
        svz1qPAmmo5mVuUoHuLMpUY1Jv36JKvu6U3czKUJuA==
X-Google-Smtp-Source: APiQypLoRNhqihwhQE5Ur1dVj8U8FImV/I8LORNh+0Kjb4eqMYTHyrIbDuCIM1Sio2Q8at3XTBfx5sTNDZts2TvaQm8=
X-Received: by 2002:a05:6402:22ed:: with SMTP id dn13mr21741386edb.212.1587544300366;
 Wed, 22 Apr 2020 01:31:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200421184107.GC28740@redhat.com> <CAJfpeguGqLxA14unqNx-nExCWKs1Tv_0MwqGohHnuW-ugcjDyQ@mail.gmail.com>
 <20200421210421.GE28740@redhat.com>
In-Reply-To: <20200421210421.GE28740@redhat.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 22 Apr 2020 10:31:29 +0200
Message-ID: <CAJfpegvsBLvodbmO+o6aLe6h3LvVCheKxE8KO4xXeQuwuEMrgw@mail.gmail.com>
Subject: Re: [PATCH] overlayfs: Pass O_TRUNC flag to underlying filesystem
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        virtio-fs-list <virtio-fs@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 21, 2020 at 11:04 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, Apr 21, 2020 at 08:59:24PM +0200, Miklos Szeredi wrote:
> > On Tue, Apr 21, 2020 at 8:41 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > As of now during open(), we don't pass bunch of flags to underlying
> > > filesystem. O_TRUNC is one of these. Normally this is not a problem as VFS
> > > calls ->setattr() with zero size and underlying filesystem sets file size
> > > to 0.
> > >
> > > But when overlayfs is running on top of virtiofs, it has an optimization
> > > where it does not send setattr request to server if dectects that
> > > truncation is part of open(O_TRUNC). It assumes that server already zeroed
> > > file size as part of open(O_TRUNC).
> > >
> > > fuse_do_setattr() {
> > >         if (attr->ia_valid & ATTR_OPEN) {
> > >                 /*
> > >                  * No need to send request to userspace, since actual
> > >                  * truncation has already been done by OPEN.  But still
> > >                  * need to truncate page cache.
> > >                  */
> > >         }
> > > }
> > >
> > > IOW, fuse expects O_TRUNC to be passed to it as part of open flags.
> > >
> > > But currently overlayfs does not pass O_TRUNC to underlying filesystem
> > > hence fuse/virtiofs breaks. Setup overlayfs on top of virtiofs and
> > > following does not zero the file size of a file is either upper only
> > > or has already been copied up.
> > >
> > > fd = open(foo.txt, O_TRUNC | O_WRONLY);
> > >
> > > Fix it by passing O_TRUNC to underlying filesystem.
> >
> >
> > Or clear ATTR_OPEN in ovl_setattr()
> >
> > Need to think about side effects of passing O_TRUNC down to underlying
> > fs.   Clearing ATTR_OPEN seems obviously safe, so as a quick fix I'd
> > rather go with that for now.
>
> Found another interesting problem while I cleared ATTR_OPEN. VFS also
> sets ATTR_FILE and attr->ia_file has ovl file pointer. ovl_setattr() does not
> look at this attribute and passes it to underlying layer as it is. Fuse
> thinks it got a valid file object and passes file handle to server and
> server complains -EBADF.
>
> ext4/xfs don't seem to look at ATTR_FILE, so it did not create problems
> so far.
>
> For now, I will simply reset ATTR_FILE, indicating to lower layers
> don't use attr->ia_file.

Right.

The solution to that would be to replace attr->ia_file with the real
file, but that can wait until we see any use case for that.

Thanks,
Miklos
