Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1402AC05027
	for <linux-unionfs@archiver.kernel.org>; Fri, 10 Feb 2023 10:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbjBJKyE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 10 Feb 2023 05:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbjBJKyD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Feb 2023 05:54:03 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627F71E5C4
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Feb 2023 02:54:02 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ud5so14789305ejc.4
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Feb 2023 02:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IY4Whe06KZr/dCRKC/k3Pnuiy/Cav2kBFD8hLrrOg8g=;
        b=nY/IGLGNDxwn530xHObj2thmUqHZRExRlPumHRiXuRfiSoGNDPEVEF+L5oTEXv8PcP
         ETbaF/URLWOEk55Yq0H8SNZ5bXxPS/Ze9/GJ9GFYZs9XeTEJ7dl9t9krGUkdAC3wi0WF
         U3t/xZxHsaRWpDmZSXBrwiZnSO7RT+1smDyvY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IY4Whe06KZr/dCRKC/k3Pnuiy/Cav2kBFD8hLrrOg8g=;
        b=BSm18z2L99hKGnGIc6ZZUjb7im+jbjC6dbrha42BA03llotBbpaFw69FZHnO21+ldS
         8E+xPYG8wQjLtGtMZ1QY510OjfhjEdKIMpby8JPGK6K23JlzbvqEA+YOYk4tZVUpV+fu
         64Jc0V0kQdzAXmDx2G/KjvNAdFwO0phPNSxtQlSpyLGIvWmtt8D3GsmPZUDyLjxlCo3a
         OY+MDnbu6xQh37FLxWu0EHND5XLn+drAp5xW4U1jv2KlHoCPyLQFoXbklbaHjbC4bPL9
         PyZGqUoLiQeIYgYUxT7vb9rAVc9D+voV82XBDpafaoKwKlHm0Ws+KvKaWmdIm5g8wFIJ
         3iyA==
X-Gm-Message-State: AO0yUKVCx0r3bSnVzItmY0n7kTMBrzO+gnbetTsu5nydh9v2jbFMOuYj
        P6QpBJDGR0YFdD0kjCRnn4QihEIpQP0X/iNSoRI2zg==
X-Google-Smtp-Source: AK7set8xkzxBOD+wDzOrHdqZR4xd8pnPuGMx8oY9OQNbChtJSYSGC6AgESAHznUmU7N13mMocyUpTYWHP03Gt0TCi8c=
X-Received: by 2002:a17:906:7242:b0:889:a006:7db5 with SMTP id
 n2-20020a170906724200b00889a0067db5mr3270379ejk.138.1676026440994; Fri, 10
 Feb 2023 02:54:00 -0800 (PST)
MIME-Version: 1.0
References: <20221122021536.1629178-1-drosen@google.com> <CAOQ4uxiyRxsZjkku_V2dBMvh1AGiKQx-iPjsD5tmGPv1PgJHvQ@mail.gmail.com>
 <CA+PiJmRLTXfjJmgJm9VRBQeLVkWgaqSq0RMrRY1Vj7q6pV+omw@mail.gmail.com>
 <2dc5e840-0ce8-dae9-99b9-e33d6ccbb016@fastmail.fm> <CAOQ4uxiBD5NXLMXFev7vsCLU5-_o8-_H-XcoMY1aqhOwnADo9w@mail.gmail.com>
 <283b5344-3ef5-7799-e243-13c707388cd8@fastmail.fm> <CAOQ4uxjvUukDSBk977csO5cX=-1HiMHmyQxycbYQgrpLaanddw@mail.gmail.com>
 <CAJfpegvHKkCn0UnNRVxFXjjnkOuq0N4xLN4WzpqVX+56DqdjUw@mail.gmail.com> <81e010cc-b52b-4b20-8d08-631ce8ca7fad@app.fastmail.com>
In-Reply-To: <81e010cc-b52b-4b20-8d08-631ce8ca7fad@app.fastmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 10 Feb 2023 11:53:50 +0100
Message-ID: <CAJfpegsocoi-KobnSpD9dHvZDeDwG+ZPKRV9Yo-4i8utZa5Jww@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/21] FUSE BPF: A Stacked Filesystem Extension for FUSE
To:     Nikolaus Rath <nikolaus@rath.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Bernd Schubert <bernd.schubert@fastmail.fm>,
        Daniel Rosenberg <drosen@google.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@android.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, 10 Feb 2023 at 10:42, Nikolaus Rath <nikolaus@rath.org> wrote:
>
> On Fri, 10 Feb 2023, at 09:38, Miklos Szeredi wrote:
> > On Fri, 3 Feb 2023 at 12:43, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> >> > Thanks a lot Amir, I'm going to send out an invitation tomorrow. Maybe
> >> > Nikolaus as libfuse maintainer could also attend?
> >> >
> >>
> >> Since this summit is about kernel filesystem development, I am not sure
> >> on-prem attendance will be the best option for Nikolaus as we do have
> >> a quota for
> >> on-prem attendees, but we should have an option for connecting specific
> >> attendees remotely for specific sessions, so that could be great.
> >
> > Not sure.  I think including non-kernel people might be beneficial to
> > the whole fs development community.  Not saying LSF is the best place,
> > but it's certainly a possibility.
> >
> > Nikolaus, I don't even know where you're located.  Do you think it
> > would make sense for you to attend?
>
> Hi folks,
>
> I'm located in London.
>
> I've never been at LHS, so it's hard for me to tell if I'd be useful there or not. If there's interest, then I would make an effort to attend.
>
> Are we talking about the event in Vancouver on May 8th?

Yes, that's the one.

I'd certainly think it would be useful, since there will be people
with interest in fuse filesystems and hashing out the development
direction involves libfuse as well.

Here's the CFP and attendance request if you are interested:

  https://events.linuxfoundation.org/lsfmm/program/cfp/

Thanks,
Miklos
