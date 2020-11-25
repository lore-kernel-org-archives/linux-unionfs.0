Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 160FCC56202
	for <linux-unionfs@archiver.kernel.org>; Wed, 25 Nov 2020 18:32:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FE7F20656
	for <linux-unionfs@archiver.kernel.org>; Wed, 25 Nov 2020 18:32:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sargun.me header.i=@sargun.me header.b="fz+eoZBm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732578AbgKYScP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 25 Nov 2020 13:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730781AbgKYScP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 25 Nov 2020 13:32:15 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E1CC0613D4
        for <linux-unionfs@vger.kernel.org>; Wed, 25 Nov 2020 10:32:14 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id a16so4400552ejj.5
        for <linux-unionfs@vger.kernel.org>; Wed, 25 Nov 2020 10:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ecRcBDigyuzJpB4+DEEjbs/8q8jM472OmYKMrTaXLcM=;
        b=fz+eoZBmT7qC4mcDH7aY9dy2eKBuFqczfeivFyhSj4KSb3aiPp+PV5wLlMEk9+xfDe
         D/asPbT25lNO9mcusmQZ+k/2hkfHjCiK3Fl7iZkBex6CISwwhVaKVNCmMo5AcDlGrzV1
         9pmrY9xMY4DwAKIZifUHcsC0UvOeMFvEjZzBc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ecRcBDigyuzJpB4+DEEjbs/8q8jM472OmYKMrTaXLcM=;
        b=L57Y2UqWr8mE4i4qj0l6pO9H6SaxE2AE1m8kMbzdIBzVl/FZ0zjpxtv6Mv4672IDFR
         AM8vD+JTVUG9ZJDELoBt9cpOd/p4dqe8vZaF2phKH7w1q3jj7qJ5l0pWfLep9gf38uQz
         FFFb3vNWjUoOiQGQGFt67i3IIyY035Y0y4uHWVt9bHGq0oz6gG/OM94MHENmLyy21K5J
         7Mj0ws1Q63RIoj/eSN0AdUsa0s+djhD/QqQRwneBB6ksPkiWu0xu6ihvZivT/KQlKPax
         dRbX7+I9Sm/U9QDJS31t2a1/GEDk1pDaggA8exCex059LNUVW9n3M0bqVW05VP0VSUKf
         OctA==
X-Gm-Message-State: AOAM532NGEQtNU7qAi8ZygYQsypCjl1ytPTtmbaQ+aAeqF9byhS1hcQi
        Ga+Nsvcmga3qg9gsICujgXt7ZbZD9qXdTu3j5VGv+g==
X-Google-Smtp-Source: ABdhPJwlZrbCvfj3PJAGYPrC0QMaE1AMNMzD35MIDdb9brVL8P39XfFyTdj6VUET/3czQ86eRxr0KWaTeO3ROp0C5tc=
X-Received: by 2002:a17:906:6b86:: with SMTP id l6mr4318905ejr.524.1606329133305;
 Wed, 25 Nov 2020 10:32:13 -0800 (PST)
MIME-Version: 1.0
References: <20201125104621.18838-1-sargun@sargun.me> <20201125104621.18838-3-sargun@sargun.me>
 <20201125181704.GD3095@redhat.com>
In-Reply-To: <20201125181704.GD3095@redhat.com>
From:   Sargun Dhillon <sargun@sargun.me>
Date:   Wed, 25 Nov 2020 10:31:36 -0800
Message-ID: <CAMp4zn_jR28x4P21QaHJV8AzG90ZZO3=K+pDVwNovP1m3hf7pw@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] overlay: Add the ability to remount volatile
 directories when safe
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Amir Goldstein <amir73il@gmail.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Nov 25, 2020 at 10:17 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, Nov 25, 2020 at 02:46:20AM -0800, Sargun Dhillon wrote:
>
> [..]
> > @@ -1125,16 +1183,19 @@ static int ovl_workdir_cleanup_recurse(struct path *path, int level)
> >                       if (p->len == 2 && p->name[1] == '.')
> >                               continue;
> >               } else if (incompat) {
> > -                     pr_err("overlay with incompat feature '%s' cannot be mounted\n",
> > -                             p->name);
> > -                     err = -EINVAL;
> > -                     break;
> > +                     err = ovl_check_incompat(ofs, p, path);
> > +                     if (err < 0)
> > +                             break;
> > +                     /* Skip cleaning this */
> > +                     if (err == 1)
> > +                             continue;
> >               }
>
> Shouldn't we clean volatile/dirty on non-volatile mount. I did a
> volatile mount followed by a non-volatile remount and I still
> see work/incompat/volatile/dirty and "trusted.overlay.volatile" xattr
> on "volatile" dir. I would expect that this will be all cleaned up
> as soon as that upper/work is used for non-volatile mount.
>
>

Amir pointed out this is incorrect behaviour earlier.
You should be able to go:
non-volatile -> volatile
volatile -> volatile

But never
volatile -> non-volatile, since our mechanism is not bulletproof.

I will fix this in the next respin.
