Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4010CC43334
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Jul 2022 15:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbiGLP0j (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 11:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbiGLP03 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Jul 2022 11:26:29 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE132F03E
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Jul 2022 08:26:28 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id a5so11664066wrx.12
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Jul 2022 08:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HM6IkKz6GiWAXMyG17S3kqQ6je/YJEcM0KLSycGzMfY=;
        b=ojG9PSqwjBbAfRCx6wW7W8aD3YtDip+aAIlULOWEGdSGKRCV0WZmGCiljCrOqWln7A
         UxGZcBBsd/ZRlbDedawHQOUj7MMdVVzavRW9ONMflwlpwqCrNY4zQU7cY9oml40klPUc
         Ok115c/lQgXsqrFGqV5F1SLcpYCrpfX53YxqrI0L0PMNZ5RpcKoLDhQbSb8SnArBJaBF
         260UqL0TpX8Qydcqm+9t5kRA9hHNzTfNn4qdhNYRds7wcj17lM3pBNSBffRMm/ABPzBQ
         PfVMjDgNjULLnnHQwewNDozNU8g+lglhbeRRByKY6dkytpkoV9Kh1zEfLPoBlPfLggqc
         5C3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HM6IkKz6GiWAXMyG17S3kqQ6je/YJEcM0KLSycGzMfY=;
        b=s3y41sntil4EGuKny9qh5ZUhtqpBY+61HTaG2g7We4lxj8TEB5PkgLf7dCKMIH2R8O
         IYLDgdF0Ta3G98WhcVQW0h68IY6ZtG4/mcCxknkI0I2a+i740Q03DlnrATcn4xYMUaXw
         eTugkHfwjTamzoO9laDlSE6gmSV2L0K6dkwrIHkHpG0yDBU0Nz15bmGdSobkbHktAFhk
         4b2vv8wYVkXlPeQPVY6PXYxO++JwGxTV2Q3Ks0njuu3PbaB4oID/lEDmjRIi+ukgWDxJ
         Bsq6Qg4xUj10ggrn0+F1W4cdNs2lHXgoiNmHc1u69qaRADX3sdnjiyXCAu1S9CISs62O
         uMjw==
X-Gm-Message-State: AJIora9D7PxnBRuJAM202BDuWMxpgd/OVcQHKdvwg0gwRvDLV4fxov/6
        BqPh3Nryw21mxEMnxDAy7C/a1Ryk5uZ1ZG1tNf6EbCTJ+w==
X-Google-Smtp-Source: AGRyM1urQ0WXuOONjO9+8BAEpjg8aiiIDSEsPlg2LpEWLiZG3IASYvl3mr0aad0mOsDjcKCtcWluMQ8HdHoZmtjcCW0=
X-Received: by 2002:a5d:698c:0:b0:21d:b2d0:ad4e with SMTP id
 g12-20020a5d698c000000b0021db2d0ad4emr3642667wru.483.1657639587079; Tue, 12
 Jul 2022 08:26:27 -0700 (PDT)
MIME-Version: 1.0
References: <165668469351.28601.2872895377697386439.stgit@olly>
 <CAHC9VhSBF5oK0x2zw6xemqNn-Zf5p8ih8Q5hWyF9waF1RpzAvA@mail.gmail.com>
 <CAHC9VhRmTzZD9HCWUeWx2=dV2v33kzzoJ1mtUtpEZT3uLjF=7w@mail.gmail.com> <CAJfpegsAzgOBvBTv48N6e+xjS6h0wFAVjM7z+rFT_FK-va=35w@mail.gmail.com>
In-Reply-To: <CAJfpegsAzgOBvBTv48N6e+xjS6h0wFAVjM7z+rFT_FK-va=35w@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 12 Jul 2022 11:26:16 -0400
Message-ID: <CAHC9VhRnEq1q--n-Xnu251ZhTr5+Nq_nPift55bE-GdXBEc=zQ@mail.gmail.com>
Subject: Re: [RFC PATCH] ovl: properly release old cache entries in ovl_cache_get()
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jul 12, 2022 at 9:05 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, 11 Jul 2022 at 22:11, Paul Moore <paul@paul-moore.com> wrote:
> > On Fri, Jul 1, 2022 at 10:15 AM Paul Moore <paul@paul-moore.com> wrote:
> > > On Fri, Jul 1, 2022 at 10:11 AM Paul Moore <paul@paul-moore.com> wrote:
> > > >
> > > > If an old readdir cache entry is found during lookup we need to
> > > > ensure that we drop a reference to the old cache entry before
> > > > we remove it from the cache.
> > > >
> > > > Signed-off-by: Paul Moore <paul@paul-moore.com>
> > > > ---
> > > >  fs/overlayfs/readdir.c |   21 +++++++++++----------
> > > >  1 file changed, 11 insertions(+), 10 deletions(-)
> > >
> > > I ran across this a few months ago while working on something related
> > > in overlayfs' readdir cache, unfortunately that work has been shelved
> > > for now, but it seems like this bugfix might still have merit,
> > > although I'll leave that decision up to the overlayfs experts; it's
> > > very possible I've missed an important detail and this isn't actually
> > > a bug.
> > >
> > > I've done some basic manual testing (kernel boots,
> > > mounting/traversal/accesses are all okay), but nothing exhaustive.
> >
> > Based on the lack of a response, should I assume this is not a bug and
> > this patch is not needed?
>
> Hi Paul,
>
> Sorry for the late response.
>
> Yes, the code is okay, though could be better documented.   The logic
> is that only open directories contain counted references to the cache,
> not the directory inode.  The uncounted reference from the inode is
> used to allow sharing the cache in case there are mulitple directory
> readers. Thus the ref from the inode can be dropped without
> decrementing the count, and this reference is reset to NULL when the
> count hits zero.  Locking is provided by i_rwsem.

Great, I'm glad to hear the existing code is working as intended.
Thanks for the explanation too!

-- 
paul-moore.com
