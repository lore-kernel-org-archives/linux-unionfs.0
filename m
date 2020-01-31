Return-Path: <SRS0=T6lg=3U=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F72EC35240
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jan 2020 15:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3556420707
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jan 2020 15:38:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="P+56vbpj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgAaPir (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 31 Jan 2020 10:38:47 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:44225 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728752AbgAaPiq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 31 Jan 2020 10:38:46 -0500
Received: by mail-il1-f195.google.com with SMTP id s85so3059568ill.11
        for <linux-unionfs@vger.kernel.org>; Fri, 31 Jan 2020 07:38:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=46S1L/Fr2OaAYBi+gQ6U/X2dMBzkNkSrL5I3ADHH34Y=;
        b=P+56vbpjy9arzNUOUGlRxnZlFRq3z+7woJuw9mvdXGsQAUBgmsIpbDa/dFOfsZUWmy
         Ikd0AAvjwEykU+VS8hpvHR9s6wrU9vV6XyppnUAbE66h4Po876JU1xKI2Z4bUFTFECyI
         k5iMIxVShfinfb7+B7IGxjypu2vvgTV2OCnOQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=46S1L/Fr2OaAYBi+gQ6U/X2dMBzkNkSrL5I3ADHH34Y=;
        b=m16RhKZEOE7tcMHq8be+n6g19ruhe5sUkpLPwfDDBKn/72dvInZ7FwcgDyoRNi7n7y
         C6+DPd42qp9WFj2heUJOOyk/dHEG8FwsBdSzW1F+0SIKi3mDot+qQQP8sNegLY8ERbk4
         qUvKVW4vHH2W84biVuuTZj/v3qeV3ijk0LYQkA+5SALZCwZ+n82t+oC4qnlAV0HrDVhy
         S3tEYMbtEY1/lLwyENBmcuOnVo4xjR7JjGMXbZg7Tgx4WdQC3BqTp7ikFnk33xVWJ+MJ
         +4aHMug1tlkgZDijruaAi558dzRo0zvrjJGBwTInz7qadzX8vkdNF28ohLN8w/oAbU2v
         lc0w==
X-Gm-Message-State: APjAAAVRLXGYtjQKZC7s512ZEUL3Yj4X9i6Q37tdDMYPMCESbkXbpBlT
        uGoRqp27vqJEPE5lahlw9t+oGh9UdE1XYh12PeWvXA==
X-Google-Smtp-Source: APXvYqwwWX+2KKEll78rpV4fbd4o4omNYbJeY32yB8vH9xNP8HNGg0uvOxQs+Uihl0iRsF4rUY4bhhqIB/UzGqIPsBk=
X-Received: by 2002:a92:c0c9:: with SMTP id t9mr10212110ilf.174.1580485124724;
 Fri, 31 Jan 2020 07:38:44 -0800 (PST)
MIME-Version: 1.0
References: <20200131115004.17410-1-mszeredi@redhat.com> <20200131115004.17410-5-mszeredi@redhat.com>
 <CAOQ4uxgV9KbE9ROCi5=RmXe1moqnmwWqaZ98jDjLcpDuM70RGQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxgV9KbE9ROCi5=RmXe1moqnmwWqaZ98jDjLcpDuM70RGQ@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 31 Jan 2020 16:38:33 +0100
Message-ID: <CAJfpegvMz-nHOb3GkoU_afqRrBKt-uvOXL6GxWLa3MVhwNGLpg@mail.gmail.com>
Subject: Re: [PATCH 4/4] ovl: alllow remote upper
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jan 31, 2020 at 4:30 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Fri, Jan 31, 2020 at 1:51 PM Miklos Szeredi <mszeredi@redhat.com> wrote:
> >
> > No reason to prevent upper layer being a remote filesystem.  Do the
> > revalidation in that case, just as we already do for lower layers.
> >
>
> No reason to prevent upper layer from being a remote filesystem, but
> the !remote criteria for upper fs kept away a lot of filesystems from
> upper. Those filesystems have never been tested as upper and many
> of them are probably not fit for upper.
>
> The goal is to lift the !remote limitation, not to allow for lots of new
> types of upper fs's.
>
> What can we do to minimize damages?
>
> We can assert that is upper is remote, it must qualify for a more strict
> criteria as upper fs, that is:
> - support d_type
> - support xattr
> - support RENAME_EXCHANGE|RENAME_WHITEOUT
>
> I have a patch on branch ovl-strict which implements those restrictions.

Sounds good.  Not sure how much this is this going to be a
compatibility headache.  If it does, then we can conditionally enable
this with a config/module option.

>
> Now I know fuse doesn't support RENAME_WHITEOUT, but it does
> support RENAME_EXCHANGE, which already proves to be a very narrow
> filter for remote fs: afs, fuse, gfs2.
> Did not check if afs, gfs2 qualify for the rest of the criteria.
>
> Is it simple to implement RENAME_WHITEOUT for fuse/virtiofs?

Trivial.

> Is it not a problem to rely on an upper fs for modern systems
> that does not support RENAME_WHITEOUT?

Limited r/w overlay functionality is still available without
whiteout/xattr support, so it could turn out to be something people
already rely on.  Can't tell without trying...

Thanks,
Miklos
