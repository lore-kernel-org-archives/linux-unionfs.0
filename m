Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1632AC433EF
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Jul 2022 13:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiGLNFF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 09:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiGLNFE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Jul 2022 09:05:04 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857C421821
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Jul 2022 06:05:01 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id w12so9284752edd.13
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Jul 2022 06:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uL1zdbafjjiZaxJvf+G3ckJMWl7TdZqjcKACnGsQ+V0=;
        b=NNaaTzUMFaURz+lzpnO8MruhzaJ/NFRxITDz8IY3tgz72t3u9OJbG2sy3Pax1Tj1WG
         Gug0fK3MmtKSlLdRUMiG6QsvNn3f17BbUvk7fcfgSKYSQXgGjlht62K7WmE01vXFIPVu
         50c7cdoOXstnFHO/+sA0iPwYQN8l0q/Aekmg8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uL1zdbafjjiZaxJvf+G3ckJMWl7TdZqjcKACnGsQ+V0=;
        b=xSnn9bu6EPdmatcNv7S3RfoqEgdDoNzW9YxMvTdK5QB7LPTHuTrkazwOHhgCWJKf3I
         N0RgzyxwKTDXfiXpIN8fg1pXuZkIHE9gJtOlEtbZYVkR4B0en3gwIvbgk9J+gVC0E2/p
         MsxL5FNAXAk/qkk5qeTgRcp47kJu0kZmYm+3v9Vnj1e8x07S6Avk56TQQxfqn2gImxM+
         bAHgCMDiR8swufFl4KsT+Kz3NocMM5kL6pjmvykBLHs4BwZfJMeTzWPYNqnI/XScN9WH
         DAp9hztqDhmA5p6LYEJC7Ro2pYxNYeeIQDbEiP/8gU+GDZ7NLmTc6nESfmI5L4a85FH6
         a/8A==
X-Gm-Message-State: AJIora9jdJaEwM7PfigytRa0rCQsR4MFLMILlIvbR+HzwG5pjjAGoDm/
        bMp5sHX/S9SvFLcvdzB0rSTl4WbkMuqfwPDl6TTh0DmC7h9FHg==
X-Google-Smtp-Source: AGRyM1vKahLphlAi5Zy92kC0GUfb8be6qT/PqP4okdlUyKN0diNVaxG1H580BWJ1u7HQt8zPntcDCpU3JP+/wdaevxI=
X-Received: by 2002:a05:6402:270d:b0:43a:d1e8:460b with SMTP id
 y13-20020a056402270d00b0043ad1e8460bmr15329154edd.40.1657631100050; Tue, 12
 Jul 2022 06:05:00 -0700 (PDT)
MIME-Version: 1.0
References: <165668469351.28601.2872895377697386439.stgit@olly>
 <CAHC9VhSBF5oK0x2zw6xemqNn-Zf5p8ih8Q5hWyF9waF1RpzAvA@mail.gmail.com> <CAHC9VhRmTzZD9HCWUeWx2=dV2v33kzzoJ1mtUtpEZT3uLjF=7w@mail.gmail.com>
In-Reply-To: <CAHC9VhRmTzZD9HCWUeWx2=dV2v33kzzoJ1mtUtpEZT3uLjF=7w@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 12 Jul 2022 15:04:48 +0200
Message-ID: <CAJfpegsAzgOBvBTv48N6e+xjS6h0wFAVjM7z+rFT_FK-va=35w@mail.gmail.com>
Subject: Re: [RFC PATCH] ovl: properly release old cache entries in ovl_cache_get()
To:     Paul Moore <paul@paul-moore.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 11 Jul 2022 at 22:11, Paul Moore <paul@paul-moore.com> wrote:
>
> On Fri, Jul 1, 2022 at 10:15 AM Paul Moore <paul@paul-moore.com> wrote:
> > On Fri, Jul 1, 2022 at 10:11 AM Paul Moore <paul@paul-moore.com> wrote:
> > >
> > > If an old readdir cache entry is found during lookup we need to
> > > ensure that we drop a reference to the old cache entry before
> > > we remove it from the cache.
> > >
> > > Signed-off-by: Paul Moore <paul@paul-moore.com>
> > > ---
> > >  fs/overlayfs/readdir.c |   21 +++++++++++----------
> > >  1 file changed, 11 insertions(+), 10 deletions(-)
> >
> > I ran across this a few months ago while working on something related
> > in overlayfs' readdir cache, unfortunately that work has been shelved
> > for now, but it seems like this bugfix might still have merit,
> > although I'll leave that decision up to the overlayfs experts; it's
> > very possible I've missed an important detail and this isn't actually
> > a bug.
> >
> > I've done some basic manual testing (kernel boots,
> > mounting/traversal/accesses are all okay), but nothing exhaustive.
>
> Based on the lack of a response, should I assume this is not a bug and
> this patch is not needed?

Hi Paul,

Sorry for the late response.

Yes, the code is okay, though could be better documented.   The logic
is that only open directories contain counted references to the cache,
not the directory inode.  The uncounted reference from the inode is
used to allow sharing the cache in case there are mulitple directory
readers. Thus the ref from the inode can be dropped without
decrementing the count, and this reference is reset to NULL when the
count hits zero.  Locking is provided by i_rwsem.

Thanks,
Miklos
