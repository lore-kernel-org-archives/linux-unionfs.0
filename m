Return-Path: <SRS0=vlVb=CI=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC59C433E7
	for <linux-unionfs@archiver.kernel.org>; Sun, 30 Aug 2020 11:44:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D7A9207DA
	for <linux-unionfs@archiver.kernel.org>; Sun, 30 Aug 2020 11:44:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LQSaD244"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgH3Loi (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 30 Aug 2020 07:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728691AbgH3Loh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 30 Aug 2020 07:44:37 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19260C061573
        for <linux-unionfs@vger.kernel.org>; Sun, 30 Aug 2020 04:44:37 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id w20so3341854iom.1
        for <linux-unionfs@vger.kernel.org>; Sun, 30 Aug 2020 04:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=90nqvY3TIGZlTWEomvS5xRC/YzJhv+Jw7sidT1nz8MA=;
        b=LQSaD244VrR+3VJ53dxHl+z+SsJ4Gv99iqjb3MzyqdYTOV0GQxPSLp+/I+FE4uZdmy
         Y4A9zrhkp3fPzeZrIdex2Hv0EXNSLn4D0aXYfhkg0dzX/P3psYNJKXmwMHX8i1ENtYdm
         b31PXWJkscY/XeiilliFEgzavMg8sYYCsRIa/W318Hxj2PT0qnEXico+HLhF2p99Pv5Q
         aNtGCzar2t6/NRr3pRHy0a0zOS1ckzOssKSGNUrEU2RzqMYfyW6RRNUYMh9+AD3ype7F
         aI9O3EQg9Vi6s4FeDTHE1ydya4dBeZ34XneyZH9PXp/9nDxdahErvY7vaU0m9szhTKqt
         xC2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=90nqvY3TIGZlTWEomvS5xRC/YzJhv+Jw7sidT1nz8MA=;
        b=exuQMlpNK1Ja9pwfbETCtIIyRsOe9Gb/lFelYAE8ZYJ378PFJyC+5hGF3DQnBJOFDj
         uqUux1hfw5ZnOhhMA4d3ThxEkkNL2h9FpPvk8b9yh9j4/1OGp/GR2OJ9GZ4bsKUumlbQ
         eKMoTKrxt5WIzFWm05kzL8OFFoYvTXkc35ElpysQT5S5zcCwRlGcTDMNoXTd1Wi606Lt
         Jllf8upctwCvxu7p2HEMACY7m5q4FcMM33NO7a9WWvlT6YsekWNhS/qvawGdrI/ZI1xG
         M6/AlHegxraopcfacSp4IQGSPAL1FasS4+5cl5qv6QpVvnWppReaNYDVpEt9+/nQPXC/
         TD9A==
X-Gm-Message-State: AOAM531XIVDUWyKU9jOqmX0idAqbckpX6Ua+OnlA1KdWZxow9tzeIg1I
        yWIMP5eXHMqYqIpboE+x1yg25HzJC2Tu+gqP2ZFNa9+P
X-Google-Smtp-Source: ABdhPJy4vo4H2sC+uVDy8REzBfxyPRw79Lr9Tq96ees6R2BnIAlv5R3U28q9XupNhYnzwoQ+QQDydbTkwqugHMLHKD0=
X-Received: by 2002:a6b:ec17:: with SMTP id c23mr5269194ioh.186.1598787871854;
 Sun, 30 Aug 2020 04:44:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAOQ4uxjXZdXZAaeiJ_p9n7NJziBv2yvWqSDs0hDd1ONUrVKxOQ@mail.gmail.com>
 <87tuwmiy4j.fsf@x220.int.ebiederm.org> <20200828155849.k46uk3x63aio3g3o@yavin.dot.cyphar.com>
In-Reply-To: <20200828155849.k46uk3x63aio3g3o@yavin.dot.cyphar.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 30 Aug 2020 14:44:20 +0300
Message-ID: <CAOQ4uxisYp9nGacXL8LaLiGa2ciXWOHYxgda-G0QEaw9t0MZHw@mail.gmail.com>
Subject: Re: Overlayfs @Plumbers
To:     Aleksa Sarai <asarai@suse.de>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Aug 28, 2020 at 6:58 PM Aleksa Sarai <asarai@suse.de> wrote:
>
> On 2020-08-28, Eric W. Biederman <ebiederm@xmission.com> wrote:
> > Amir Goldstein <amir73il@gmail.com> writes:
> >
> > > Hi Guys,
> > >
> > > It's been nice to virtually meet with you yesterday.
> > > Some of you wanted to follow up on overlayfs related issues.
> > >
> > > If you want to discuss, try to find me in one of the
> > > https://meet.2020.linuxplumbersconf.org/hackrooms
> > > today between 16:00-17:00 UTC
> > > (No need to enter the room to see who's inside)
> > >
> > > If those times do not work for you, contact me and we can try
> > > to schedule another time.
> >
> > Did this conversation wind up happening?  Do we need to reschedule?
>
> This conversation already happened in a Hackroom on Tuesday. I'm not
> sure if the Hackrooms will have their recordings published, so maybe
> Amir can post any of the takeaways we had?
>

AFAIK we had discussed two issues.
1. Watching changes on upper layer
2. OCI format v2

#1 was brought up by Josh Triplett.
He asked whether watching changes using inotify/fanotify on upper dir
and reading changes from upper dir is a reasonable practice.
I suggested that he use fanotify filesystem mark to watch changes
on overlay sb and read the changes from overlay mount.

#2 TBH I lost track and you guys continued the discussion after I left.
From what I gathered we need a way to describe clones and renames
more efficiently, but I did not hear any solid plan of how to do that.
So perhaps you would be able to fill in some details here.

Thanks,
Amir.
