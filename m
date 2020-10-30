Return-Path: <SRS0=w8z3=EF=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B8EEC4363A
	for <linux-unionfs@archiver.kernel.org>; Fri, 30 Oct 2020 13:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B30E620731
	for <linux-unionfs@archiver.kernel.org>; Fri, 30 Oct 2020 13:20:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pEhclZPG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgJ3NUj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 30 Oct 2020 09:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgJ3NUj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 30 Oct 2020 09:20:39 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C27C0613CF
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2020 06:20:39 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id k6so6485985ilq.2
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2020 06:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BG5BP/8V2voMN1JGc/ZKPbXoKapOqxg7R5L0XhnjEp0=;
        b=pEhclZPGQ3W8Q3D3qjsKqQG/Q/Hfzn14nXUfY2HqUHQyGUj6y5YyY8m6y3aPPDUDN9
         CVheR5CU1iEonL8kThwjSwM0QLvd5CYxr436iBy46RoLFMOzDQyQAZw1aJcaUqwNqzO9
         Q6Dfbcbk5i4HDxM7ikn7+xZQ5siUc9j/+F2doePdvHAVi+xgy0pvfHCtufzGRGtCdsUK
         VduOK4Uo45bRYIijlxWXl8zla54ybVNtXqb8qmU0AHm7ISAfzE9Tlz+B5vacP/NDj74T
         COaQyn/FTPkIh43EDojk7mHuj2ycybMu84Wlb0D7UrZrYAuJlYutJ8qWglBxu0VCGdsS
         mtjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BG5BP/8V2voMN1JGc/ZKPbXoKapOqxg7R5L0XhnjEp0=;
        b=KuDTSrvX07hbBVQrry7vVxV3VOOJ/vX8SKOIPj8RFV9Nqq/ZnR862OmQr2PPM3Z/+8
         V5FxDfTPc8Q/kK3wfggG+W0J3DAZ0TaJy9m0Df9LUxJRsvFJWh58hUvXP61XNAcNGimW
         10AFQdJn9Vz2Tg2wfRTsfJlO0wySIRWlm9GfRxkM7gH56L/pSgDwydvdeYiw8W/ErXQ6
         sNK+E2sN9DmucsPcMhOKBzQqUVqElWfQnk9bDt0GloFXO7n9EL8YqsQQVupy3ReWcPlJ
         VnLXeq+6QxmcnufJFQf1A6obCzYOsie6Y2VsFY+QKvaQiul78SUSZedlCh5k3HGlrilF
         w9Fw==
X-Gm-Message-State: AOAM533dLWtyBdz2y3P4cWLoToE3MAct091xIdS1tcfUJYrE4WKQig9o
        JtFwv8j2GCWRFIsaLw6YMGzL+cHFJtUYQSlxh9k=
X-Google-Smtp-Source: ABdhPJxlcr7gPrdDhy02bbp+3xt9NDLslpzoyoxunVKwYHJg4b+41mE1Sz131Y96mYEA2a4QDTPRvF3XLK6arsUKuWk=
X-Received: by 2002:a05:6e02:c1:: with SMTP id r1mr1852049ilq.250.1604064038343;
 Fri, 30 Oct 2020 06:20:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200713141945.11719-1-amir73il@gmail.com> <20200713141945.11719-4-amir73il@gmail.com>
 <CAJfpegvhH+SUn-QModbU23sk3=NGYgxKSekh5B70JfK_=HbHfw@mail.gmail.com>
In-Reply-To: <CAJfpegvhH+SUn-QModbU23sk3=NGYgxKSekh5B70JfK_=HbHfw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 30 Oct 2020 15:20:27 +0200
Message-ID: <CAOQ4uxjNtKXFT8CLbgr6hMSiCVVK4x1usYAfOG6Cec7KzdqcQA@mail.gmail.com>
Subject: Re: [PATCH 3/3] ovl: do not follow non-dir origin with redirect_dir=nofollow
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Oct 30, 2020 at 2:05 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Mon, Jul 13, 2020 at 4:20 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Following non-dir origin can result in some bugs when underlying layers
> > are edited offline.
>
> Sorry, lost track.  What bugs this results in?

Frankly, not in a reported bug, but a theoretical one, so feel free to take
it or leave it. I tried to rationalize it in the cover letter [1].

The bug is that you can have an upper inode with wrong origin
lower inode when re-creating lower fs in a way that rewrites the
unique file handle history of the lower fs. This can result in two non-hardlinks
pointing at the same origin and possibly worse.

Commit a888db310195 ("ovl: fix regression with re-formatted lower squashfs")
solved this problem for  re-created lower squashfs by not following
origin in the
case of lower fs with null uuid.

The case of lower fs with non-null uuid you said was less interesting because
re-creating lower would result in a new uuid and therefore origin will not
be followed to the wrong inode.

However, the uuid=off use case [2] tells us that lower fs with uuid can in-fact
be re-created with the same uuid when a prototype image is being cloned
and modified.

The uuid=off feature was proposed because Virtuozzo change the uuid
of lower image after it has been cloned. But other users may not follow
this practice. As a matter of fact xfs has mount option nouuid exactly for
this case (mount a cloned block device as well as the origin).

Long story short, I just thought it would be nice  for users to have a way to
opt-out of any sort of decoding origin when they want "legacy" overlay
functionality in case we have any more latent origin related bugs.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-unionfs/20200713141945.11719-1-amir73il@gmail.com/
[2] https://lore.kernel.org/linux-unionfs/20201013145954.4274-1-ptikhomirov@virtuozzo.com/
