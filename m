Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5198EC433EF
	for <linux-unionfs@archiver.kernel.org>; Mon, 11 Jul 2022 20:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiGKULE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 16:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiGKULD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 11 Jul 2022 16:11:03 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E0F2B1A0
        for <linux-unionfs@vger.kernel.org>; Mon, 11 Jul 2022 13:11:02 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id f2so8422594wrr.6
        for <linux-unionfs@vger.kernel.org>; Mon, 11 Jul 2022 13:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=4qBBvQLkalstXPKKvGBw+eSa+Bdn/j8tTK7/6tgITzQ=;
        b=4nZVwU9rxNDgtblc6K29Fzjkqd3jaQg7+msXBFfPBpie2EXd64tgsM67YAELuhpPCj
         /FcjC1sG9TvNFQiQKcJ7LAvHwVOI4/0S62gGu4kX1kjywRUA258qFRT2OmrsRvaWscsj
         zuTf/sqO3hS6Gp1Lln7+9bx/DKsf/RpSUHmR6xzzN6WU+FWRFLcoucRLKtVvnYu7rJym
         LnvsLM+m9Xoc/R+g1rbEqP5Y6KX2qPzV0CRkQLlyP4x4TzgHCmH8OUKj9q3h5PLtAL2s
         mKSF+z9nDkMH6K1I9nKqCLimJGTNN1PuRKtQKzses81iHbC5hotCO9z9RkV98p+gvVsj
         zSLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=4qBBvQLkalstXPKKvGBw+eSa+Bdn/j8tTK7/6tgITzQ=;
        b=s6UYj7bVZIxDK6HNUatFfehJtYbBBbWmH2+EJVGbdToLf6CqayabfBUzzXASUa2NQO
         F1SsneeMOTMLMTrlN1stdLulzdupyHgDoSAmmMxryHjSc7aVX1maXSq0c3Yn9LCfVcQ8
         6XHPxQ+fKat4YX7QKzE+sYLVKy488jih6AL86t9tT1xPgIkKZ1cPVT8Sl6cFn346f0oE
         Oq+kcNcDKi2wHJW4qS/3CJ1HxfGJSQRkGi3aNLZRz/BAYueMQmyu+P8C87FvJYOAwdm9
         a1ikW8UG4mXq2ixlMx+jb1ZJsq07zKBVgdwU3cL4QAIo0pgkinX3AqTKVq5kWqVun0F1
         fo2w==
X-Gm-Message-State: AJIora9ZHZhOxwwyF8TwHk2tkBd8pFvL1yP6zD0PmdVUUz1dbm5u72J+
        7G0qsZjSMQrHmXtACqg+mVphfjpvOHAwNGZfrLxyHdtbKw==
X-Google-Smtp-Source: AGRyM1vcKYYfmobWVhqVsis7TZ0/WUFPE8lDnNgKNQfhTHyMsfiv7K5sB7KQTKGTX3No9LzzMtFDKAigyu/HXYoOHN0=
X-Received: by 2002:adf:f345:0:b0:21d:6a26:6d8f with SMTP id
 e5-20020adff345000000b0021d6a266d8fmr19079659wrp.538.1657570260838; Mon, 11
 Jul 2022 13:11:00 -0700 (PDT)
MIME-Version: 1.0
References: <165668469351.28601.2872895377697386439.stgit@olly> <CAHC9VhSBF5oK0x2zw6xemqNn-Zf5p8ih8Q5hWyF9waF1RpzAvA@mail.gmail.com>
In-Reply-To: <CAHC9VhSBF5oK0x2zw6xemqNn-Zf5p8ih8Q5hWyF9waF1RpzAvA@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 11 Jul 2022 16:11:09 -0400
Message-ID: <CAHC9VhRmTzZD9HCWUeWx2=dV2v33kzzoJ1mtUtpEZT3uLjF=7w@mail.gmail.com>
Subject: Re: [RFC PATCH] ovl: properly release old cache entries in ovl_cache_get()
To:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jul 1, 2022 at 10:15 AM Paul Moore <paul@paul-moore.com> wrote:
> On Fri, Jul 1, 2022 at 10:11 AM Paul Moore <paul@paul-moore.com> wrote:
> >
> > If an old readdir cache entry is found during lookup we need to
> > ensure that we drop a reference to the old cache entry before
> > we remove it from the cache.
> >
> > Signed-off-by: Paul Moore <paul@paul-moore.com>
> > ---
> >  fs/overlayfs/readdir.c |   21 +++++++++++----------
> >  1 file changed, 11 insertions(+), 10 deletions(-)
>
> I ran across this a few months ago while working on something related
> in overlayfs' readdir cache, unfortunately that work has been shelved
> for now, but it seems like this bugfix might still have merit,
> although I'll leave that decision up to the overlayfs experts; it's
> very possible I've missed an important detail and this isn't actually
> a bug.
>
> I've done some basic manual testing (kernel boots,
> mounting/traversal/accesses are all okay), but nothing exhaustive.

Based on the lack of a response, should I assume this is not a bug and
this patch is not needed?

-- 
paul-moore.com
