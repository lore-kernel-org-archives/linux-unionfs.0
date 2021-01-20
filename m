Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD1BCC433DB
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Jan 2021 12:57:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C35323355
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Jan 2021 12:57:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732248AbhATMyP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 07:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbhATMio (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 20 Jan 2021 07:38:44 -0500
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265D0C061575
        for <linux-unionfs@vger.kernel.org>; Wed, 20 Jan 2021 04:38:04 -0800 (PST)
Received: by mail-vk1-xa2a.google.com with SMTP id m145so5614719vke.7
        for <linux-unionfs@vger.kernel.org>; Wed, 20 Jan 2021 04:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GO27T8yUKrIGM6y2LmjWX4/tf7ymNQb8hnQEfp2d+TA=;
        b=jnZkyj9cGsmDcjsd9ZlpNR1Cgl2XcxJysiQi2k5oVWN5jzTUKhwpDOiH7ckjrQ4ZG4
         NMn9GjPN4QYilvpEdQKsN2CSnDtADfrh0c44FvMLknPz1PXuEHXBWzCTkKN68pq24tQv
         lJihWznTxBYbvG0J5+Aw48kUwNddezwJXfiAk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GO27T8yUKrIGM6y2LmjWX4/tf7ymNQb8hnQEfp2d+TA=;
        b=kj9FOD87M09TDE4t7tmWz9yPkFQ6I4xSzSQPRpHMk5ARubblJNN5JtO0kkiGDEMUOx
         M7/9klL0FxHjraxcQFWVuhhg4J1ScoNlCqH+TtA8zruHG7OJRMXt+FwmaHL5kwX/iAAp
         xfvARSSM+77SK9KCvBVQ9p1j+cM1rkC5qzDgaNuRLQalh11IALkDK5qAGTANGVSvG5bs
         ztkQo2l7COPN8gTrjQIGrlg9qG/1AvopJy2Q2lUm3bb3j1rsBHvI6tysOZfhjVQ5vu7b
         059YMgx+aw+xkq+tVm5G1OTtHyXMCiNXfurDSTeNMspWf/r8tOb6OTokUml40deM0CYz
         M3ZQ==
X-Gm-Message-State: AOAM532bmbUaexRbhGeXO6hVR0ZKt5z/av+t6ZjREBfiCPQCuQGXSbgy
        pBhdR4haPnbzvE+wN9W92yvPHt5mmM0SjsMHJ6l1Xg==
X-Google-Smtp-Source: ABdhPJxoiEehtfA91muJYj2odCasliJJjDgt8V+sOsfp/XqKxDRid0M32hUjZSQ789CFhcVl2MCC61nihsyw2VxVGSM=
X-Received: by 2002:a1f:ab43:: with SMTP id u64mr6313045vke.3.1611146283449;
 Wed, 20 Jan 2021 04:38:03 -0800 (PST)
MIME-Version: 1.0
References: <20201219101608.16535-1-amir73il@gmail.com> <CAOQ4uxja8VcqykPxwjoZGXfLCnu7wDKLCy1Nt9CO5NLNfG442A@mail.gmail.com>
In-Reply-To: <CAOQ4uxja8VcqykPxwjoZGXfLCnu7wDKLCy1Nt9CO5NLNfG442A@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 20 Jan 2021 13:37:52 +0100
Message-ID: <CAJfpegs=RNRF+jomg=47bGic+25PA1KeZn2opxSxBAC_3HFt8Q@mail.gmail.com>
Subject: Re: [PATCH] ovl: skip getxattr of security labels
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Michael Labriola <michael.d.labriola@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jan 20, 2021 at 1:23 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Sat, Dec 19, 2020 at 12:16 PM Amir Goldstein <amir73il@gmail.com> wrote:

> > This is a workaround for a v5.9 selinux related regression reported by
> > Michael that caused copy up failure is a very specific configuration
> > involving lower squashfs and built-in but disabled selinux.
> >
> > I've sent the bug fix to selinux list, so this patch is complementary.
> > I removed the stable/Fixes tags, because this patch does not cleanly
> > apply to v5.9 and is not the real bug fix.
> >
>
> Ping.

Queued, thanks.

Miklos
