Return-Path: <SRS0=vlVb=CI=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E67A3C433E2
	for <linux-unionfs@archiver.kernel.org>; Sun, 30 Aug 2020 11:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B66192087D
	for <linux-unionfs@archiver.kernel.org>; Sun, 30 Aug 2020 11:38:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CCZpTSX8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgH3LiJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 30 Aug 2020 07:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgH3LiH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 30 Aug 2020 07:38:07 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA39C061573
        for <linux-unionfs@vger.kernel.org>; Sun, 30 Aug 2020 04:38:06 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id m1so4268714ilj.10
        for <linux-unionfs@vger.kernel.org>; Sun, 30 Aug 2020 04:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3C2VhaDgHqk43asHwygaKOqge31MS0kwvc1z6NYH8+0=;
        b=CCZpTSX8jlDPdgTyrOW4tgJKgVJIJssBtIh0D9RESUBL/pZftdAI9nj+5Vyl7xPmtG
         vnr4nfYOiQj9GUTu5//EjtVWoNimkeiRFIajv3aqGqR06tteWLrhawdEJqzpEzI3FETF
         9wD7uaEGck9I6ZkF0nV1vBa6Ow32Ql4Pt8DOTU75t0M3BZ6Rd68oQGM0TAptsz+ZY0qa
         q8bFe9cF7S6ATvrqFxtG1laG2VU1IsAleQ5Mmhb0laJsxN3Huu1i7pIIgLd/ABx0d+gS
         fsasPqDaepCQaYYayGbAcGw7ndpEjNie9+AQv3YE4vz+vkk7iwfD1Y9V+JWlK9ZCcl5b
         x3DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3C2VhaDgHqk43asHwygaKOqge31MS0kwvc1z6NYH8+0=;
        b=WJOkPj7dYR+v4Y9zMB3nK5Juc8k1zGUKojumt/H74KcXm08rnnStX6eXpu8e/KiHdO
         +CclYQGko4ppGN4AQkq5dGHiTGyEeNPye12bWYqEUbxMV11LVBpTde+y0q5oUKbjITU+
         UFdCKTiGTlJDkh/h2+eaIP6AuY1JaVFeWD4x7EIMWZkCEwQDYu5SWWhwXbq+n32GNAZw
         PmReoIsxG38CiU6HGHV2yaOyMHjycHpgKzC0D3/eFuTUDT/VXKSL4QtxvVRlzzmIe8IY
         HxeapPDmh5oRkbkkCjC5/LA2Z7MEtUp/J/PAz/5srsOFy0ziyWZMPMohJMlQB+QVEHUl
         asgg==
X-Gm-Message-State: AOAM530V7R5xrZD1GkwdiBnopp27PiVY0w/Nru4mj2tZ/o6rRZYsrR0M
        rMEg2K62Edtluv6s8YjgzM9NtsFcbVzFuX2PaOY=
X-Google-Smtp-Source: ABdhPJy1b/FW+fRcXbt0qLdxNH5gFdTYR9ZUs9GDbJUKN3kLSWICKqqQqIYZeRKpcWY8ENE6yVJKARIiCrAowr/r6nU=
X-Received: by 2002:a05:6e02:dc3:: with SMTP id l3mr5570878ilj.137.1598787485963;
 Sun, 30 Aug 2020 04:38:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAOQ4uxjXZdXZAaeiJ_p9n7NJziBv2yvWqSDs0hDd1ONUrVKxOQ@mail.gmail.com>
 <87tuwmiy4j.fsf@x220.int.ebiederm.org> <20200828155849.k46uk3x63aio3g3o@yavin.dot.cyphar.com>
 <CAMp4zn83CwpfuFq7+JSkYGZmFC03pUrt_30Wzn42AxqAaSDSpg@mail.gmail.com>
In-Reply-To: <CAMp4zn83CwpfuFq7+JSkYGZmFC03pUrt_30Wzn42AxqAaSDSpg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 30 Aug 2020 14:37:54 +0300
Message-ID: <CAOQ4uxiQ9KguY+x71C-D8O_Gi4-H6gGoPdkQM0LxoaB=F4RzDQ@mail.gmail.com>
Subject: Re: Overlayfs @Plumbers
To:     Sargun Dhillon <sargun@sargun.me>
Cc:     Aleksa Sarai <asarai@suse.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Aug 29, 2020 at 6:41 PM Sargun Dhillon <sargun@sargun.me> wrote:
>
> On Fri, Aug 28, 2020 at 8:59 AM Aleksa Sarai <asarai@suse.de> wrote:
> >
> > On 2020-08-28, Eric W. Biederman <ebiederm@xmission.com> wrote:
> > > Amir Goldstein <amir73il@gmail.com> writes:
> > >
> > > > Hi Guys,
> > > >
> > > > It's been nice to virtually meet with you yesterday.
> > > > Some of you wanted to follow up on overlayfs related issues.
> > > >
> > > > If you want to discuss, try to find me in one of the
> > > > https://meet.2020.linuxplumbersconf.org/hackrooms
> > > > today between 16:00-17:00 UTC
> > > > (No need to enter the room to see who's inside)
> > > >
> > > > If those times do not work for you, contact me and we can try
> > > > to schedule another time.
> > >
> > > Did this conversation wind up happening?  Do we need to reschedule?
> >
> > This conversation already happened in a Hackroom on Tuesday. I'm not
> > sure if the Hackrooms will have their recordings published, so maybe
> > Amir can post any of the takeaways we had?
> >
> > --
> > Aleksa Sarai
> > Senior Software Engineer (Containers)
> > SUSE Linux GmbH
> > <https://www.cyphar.com/>
>
> I unfortunately missed this conversation. I wanted to bring up OverlayFS, and
> ephemeral upper dirs. We use overlayfs with Docker containers, and we waste
> a lot of time on writing things back to disk.
>
> We're not so peeved about the fact that OVL does any sync operations, as that's
> what our users have been used to. The big problem is on unmount, ovelfs decides
> syncing the upperdirs is a good idea. IIRC, this regression was
> introduced somewhere
> in the 4.X series.
>
> We've been carrying a patch to short-circuit this behaviour for a while now:
> https://github.com/Netflix-Skunkworks/linux/commit/edb195d9b73cc22d095078010a14a690f41ee253
>
> I know that this behaviour (and any behaviour that short-circuits
> O_SYNC / FUA is
> technically "wrong", but in this case, can we make an exception? I originally
> thought about using device mapper to remove the FUA bit from all BIOs, but it
> turns out that my underlying storage *always* persists data to disk,
> so every write
> takes...a long time.
>
> Amir, what's your take?

It's not only FUA that is causing slow down.
syncfs() takes internal filesystem locks (e.g. to commit a journal transaction),
so it causes interference with other writers on the same underlying filesystem.

As Giuseppe pointed out, a patch has already been submitted to address
this issue.

Thanks,
Amir.
