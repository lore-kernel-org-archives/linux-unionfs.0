Return-Path: <SRS0=0eJY=5I=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DFDC4332B
	for <linux-unionfs@archiver.kernel.org>; Mon, 23 Mar 2020 13:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA77420722
	for <linux-unionfs@archiver.kernel.org>; Mon, 23 Mar 2020 13:24:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HHbrDN65"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbgCWNYJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 09:24:09 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37384 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728344AbgCWNYJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 23 Mar 2020 09:24:09 -0400
Received: by mail-io1-f68.google.com with SMTP id q9so14085894iod.4
        for <linux-unionfs@vger.kernel.org>; Mon, 23 Mar 2020 06:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vWw3ALsz861R0bXCsXyBPhiIEcJi4mJsoOyXSpx+58I=;
        b=HHbrDN65GlrbPJDpcCHgo1+FETtgSdPfPGNcHm0oyMUUPOzYLC59hxLKQq0jKV/TIe
         rwHq2kgJLnKMzyujL+1l4pqOqUw2Osei4ntWXg5wNqRSANywbMwRFIQd4F0IWqZMKr53
         KnfRtplijLmB4s3gNTd3YPb+FGNoUowTgeLh5DJbLnS+WGzkynDbYm3MMhqBw+qnhAkO
         2QpDjqTv8hKPXBL4ruvpsO4xnSGKM3lgGrF5yltTMxS/if2Zjm7meYAq/jsBAICTOIff
         lKoXwhzpN4uRAVWb4R4jYBfgKpW1G+4qUFx7673JDgI2SA5Iik/D2cu8bqAAZioyIcj5
         TJyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vWw3ALsz861R0bXCsXyBPhiIEcJi4mJsoOyXSpx+58I=;
        b=rgp4NVbUbhMV7gYHZ27AdWZalgiel3lKz0MVma086UMoh1/hRveejYBvFPwmjwEEul
         iKTClpS5fv2YiiOMp4SKruimGlBKp/KUHywRroFTKfpJZ7IQdi8KFm/tPl066M7J39/J
         zADmxLKdm9oKma4e3fVh4ZZuEyBs44xFLnNpn5U3hkmxRfUwUMPr8kMHlVJut0LFwe2v
         MfO1EMsLHdrjAMpqBF9jzDQsZgpQ+o0D3L6pmY1631HGmtkOd2XJHIorR9+HfWnDyruh
         CtevO/zJX6zb0212B4etXDC5R3edXZgt7HaZmx3lGUQU4lOfmN2BWRty/0tAkvIQRDgs
         u90A==
X-Gm-Message-State: ANhLgQ036AAwPTQ4F/2N9Q4a952jE1uMFIe4ZJe3TcB+LPIqls8pA6wq
        QKgEmWeC8WoUO77BgYnbws4+qUUXEHo0F5Zsx24OukCu
X-Google-Smtp-Source: ADFU+vsWXxz3g6dwo20+GUBMrSi9GcHa40G84ItIoxbosSWEV3vu4DDtbA/ppImAhdhCRWNeNMEKAxNMtmIzqzkc+k4=
X-Received: by 2002:a02:2b02:: with SMTP id h2mr2183633jaa.81.1584969848206;
 Mon, 23 Mar 2020 06:24:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAFkON1U3cXdXFQYdkoQ3OQU+14GX7C88U6qre58vyfhrrFgKXw@mail.gmail.com>
 <CAJfpegsv+GayCtWtsfJZYWqH8DHw76U_cGOuqofgt895FBj0cg@mail.gmail.com>
In-Reply-To: <CAJfpegsv+GayCtWtsfJZYWqH8DHw76U_cGOuqofgt895FBj0cg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 23 Mar 2020 15:23:56 +0200
Message-ID: <CAOQ4uxiW2-Hh_sfuYXeuQy=a6FYBm7DyWkysgEe1GnC-qWWivg@mail.gmail.com>
Subject: Re: Kernel warnings in fs/inode.c:302 drop_nlink+0x28/0x40
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Phasip <phasip@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Mar 23, 2020 at 2:53 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Mon, Mar 23, 2020 at 9:50 AM Phasip <phasip@gmail.com> wrote:
> >
> > Hello!
> >
> > I have stumbled upon two ways of producing kernel warnings when using the overlayfs, both seem to be results of the same issue.
> >
> > The issue seems to be related to handling of hard links that are created directly in the upperdir.
> > Below is my system details and then two samples with a list of commands to reproduce and the corresponding kernel warning
>
> Hi,
>
> Thanks for the report.
>
> The problem is that i_nlink is not kept in sync with changes to
> underlying layers.   That would not in itself be an issue, since
> modification of the underlying layers may result in
> undefined/unexpected behavior.  The problem is that this manifests
> itself as a kernel warning.
>
> Since unlink/rename is synchronized on the victim inode (the one that
> is getting removed) it is possible to detect this condition and
> prevent drop_nlink() from being called.
>
> Attached patch fixes both of your testcases.

IDGI. coming from vfs_unlink() and vfs_rename() it doesn't look like
it is possible for victim inode not to have a hashed alias, so the
alias test seems futile.

We better replace the WARN_ON() with pr_warn_ratelimited().

>
> We'll need an xfstests case for this as well.
>

Please forward the part of the email with the test case to the list.

Thanks,
Amir.
