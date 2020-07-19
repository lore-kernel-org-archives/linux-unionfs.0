Return-Path: <SRS0=xnyB=A6=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94580C433DF
	for <linux-unionfs@archiver.kernel.org>; Sun, 19 Jul 2020 18:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7453922482
	for <linux-unionfs@archiver.kernel.org>; Sun, 19 Jul 2020 18:36:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TxjDrWDg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgGSSgw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 19 Jul 2020 14:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgGSSgv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 19 Jul 2020 14:36:51 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7309FC0619D2;
        Sun, 19 Jul 2020 11:36:51 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id o3so11417099ilo.12;
        Sun, 19 Jul 2020 11:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EJR/ZsxG7WM2Vu9KbmVQpFIG+nDmhBW9NBHHUpFALn0=;
        b=TxjDrWDgCCnKalSE1uFI35DTqy3FYqreiNwo6rdWVRwPSwevhYi2MeSroNRqB9x7bQ
         UQzk2vYDLfy5DxDby8X4Klw+ioN1/FMB6Vby1I+i6k2ucunAciawe/qUn1SVwSWQVYWV
         oQCbk7l9oMo1D+e9u8bMbjyieG5eUXiuocNefufIOnlAznlXPuhRCxF/PZDDWt7nymBF
         AYtllJ7ynFH9tYum+YZfqgvNz5Dyw6F/O0llQf2Gjt2N5jjTy/0BnE5WyFSxYGgYLdvi
         7yv0Zuij4c4w9TMPr3rdrSDifyqAdGuG4ecCGym5piQ1R8YjIniHCojZqQP+gQjFCfTN
         5eyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EJR/ZsxG7WM2Vu9KbmVQpFIG+nDmhBW9NBHHUpFALn0=;
        b=E7GPedCsjB5U9EpPWm3MPeGZxMS/ebdXCSFYh0vZWY177OUbkhPqIwdvsIXClXq2V+
         s/xdUoThx24QIB0hl+VlBtQ5EnjB4GTWb3oV5zVIt7QUbZGPfgdyZziRVPLMng3e0Xzq
         MLGbO55myL0PGO4AoIhpPRoS6f4H42j9PH2yC7bVB11T7S2M6ghvQc3qYG7KKe7H3YEN
         v66hlqoe7L+59//WihPPlK0yuu8a3xK5fUvxWlLMosO0w9XjirW/mj7Xz4Pqwe+759+c
         v5C2NfgDIfxevgBH6byLOy5XFGY2XXuQ6UGShgfZCaTdIyoPa0Rtubsz071IU5uyvuou
         D4rg==
X-Gm-Message-State: AOAM5334k4sg8hVoEQxxp7BuaDqWw76vUHPWcOoEhQQR/D59iSyeD65r
        j6ChVfvoQu0eFPLz7qCdqih/j2tscMJf93jlU44=
X-Google-Smtp-Source: ABdhPJxcZFex3YpHFt9X66XzZWlN1qdpzATZl7BNuM6amNfVfQ90UtuP5vw2NwJnu+aBRDfTapMQiPE+tevzdlemYQ8=
X-Received: by 2002:a92:b6d4:: with SMTP id m81mr19944963ill.72.1595183810847;
 Sun, 19 Jul 2020 11:36:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200531110156.6613-1-amir73il@gmail.com> <20200719181116.GG2557159@desktop>
In-Reply-To: <20200719181116.GG2557159@desktop>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 19 Jul 2020 21:36:39 +0300
Message-ID: <CAOQ4uxjY7SqyVEG9vCtv=wB9BxDovpjwZGAQ7h5+VeiZPMKOeQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Running unionmount testsuite from xfstests
To:     Eryu Guan <guan@eryu.me>
Cc:     Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Jul 19, 2020 at 9:11 PM Eryu Guan <guan@eryu.me> wrote:
>
> Hi Amir,
>
> On Sun, May 31, 2020 at 02:01:53PM +0300, Amir Goldstein wrote:
> > Eryu,
> >
> > unionmount testsuite has a lot more test coverage than the overlay
> > xfstests, but it has a lot less exposure to testers.
> >
> > The various test setups that I have added to unionmount testsuite since
> > I took over the maintanace of the testsuite have even smaller exposure
> > to testers.
> >
> > These patches add overlay tests that are used as a harness to run
> > different setups of unionmount testsuite.  I have been using this method
> > for over two year for testing my overlayfs branches.
> >
> > What does it take to install unionmount testsuite?
> > As README.overlay says:
> >
> >   git clone https://github.com/amir73il/unionmount-testsuite.git
> >   ln -s $PWD/unionmount-testsuite <path-to-xfstests>/src/
>
> I'm really sorry for the long-long delay..
>

No worries.

> The test itself looks really good to me, my only concern is that
> the updates in unionmount repo are not visible to fstests, and may cause
> new failures, which are out of fstests' control. But I'm not sure if
> this really is a problem for people.
>
> I came up with two options anyway
> - add unionmount tests as a submodule of fstests
> - put unionmount tests in fstests
>

I suppose you mean git submodule?
IMO that's a fairly good option.
I suspect that some people would want to continue running
unionmount independently of xfstests and I have some development
branches, so it's convenient to keep the unionmount repo independent
of xfstests repo and use git submodule as the "pull request" method
between us, for keeping control of the flow of changes from my repo
in the hands of xfstests maintainer.

But as I wrote before, I am also fine with "handing over" the official
upstream of unionmount src to xfstests project and be the
"sub-maintainer" for that module, but I think there is going to be more
chatter with that option compared to the submodule option.
Another argument in favor of submodule, is that we can always
graduate unionmount in the future from submodule to built-in.

Thanks,
Amir.

> I'd like to hear what people think about this patchset, any other
> comments & suggestions are welcomed!
>
> Thanks,
> Eryu
>
> >
> > Thanks,
> > Amir.
> >
> > Amir Goldstein (3):
> >   overlay: run unionmount testsuite test cases
> >   overlay: add unionmount tests with multi lower layers
> >   overlay: add unionmount tests with nested overlay
> >
> >  README.overlay        | 15 ++++++++++++
> >  common/config         |  2 ++
> >  common/overlay        | 54 +++++++++++++++++++++++++++++++++++++++++++
> >  tests/overlay/100     | 38 ++++++++++++++++++++++++++++++
> >  tests/overlay/100.out |  2 ++
> >  tests/overlay/101     | 39 +++++++++++++++++++++++++++++++
> >  tests/overlay/101.out |  2 ++
> >  tests/overlay/102     | 40 ++++++++++++++++++++++++++++++++
> >  tests/overlay/102.out |  2 ++
> >  tests/overlay/103     | 38 ++++++++++++++++++++++++++++++
> >  tests/overlay/103.out |  2 ++
> >  tests/overlay/104     | 39 +++++++++++++++++++++++++++++++
> >  tests/overlay/104.out |  2 ++
> >  tests/overlay/105     | 40 ++++++++++++++++++++++++++++++++
> >  tests/overlay/105.out |  2 ++
> >  tests/overlay/106     | 41 ++++++++++++++++++++++++++++++++
> >  tests/overlay/106.out |  2 ++
> >  tests/overlay/107     | 41 ++++++++++++++++++++++++++++++++
> >  tests/overlay/107.out |  2 ++
> >  tests/overlay/108     | 41 ++++++++++++++++++++++++++++++++
> >  tests/overlay/108.out |  2 ++
> >  tests/overlay/109     | 41 ++++++++++++++++++++++++++++++++
> >  tests/overlay/109.out |  2 ++
> >  tests/overlay/110     | 39 +++++++++++++++++++++++++++++++
> >  tests/overlay/110.out |  2 ++
> >  tests/overlay/111     | 40 ++++++++++++++++++++++++++++++++
> >  tests/overlay/111.out |  2 ++
> >  tests/overlay/112     | 40 ++++++++++++++++++++++++++++++++
> >  tests/overlay/112.out |  2 ++
> >  tests/overlay/113     | 41 ++++++++++++++++++++++++++++++++
> >  tests/overlay/113.out |  2 ++
> >  tests/overlay/114     | 39 +++++++++++++++++++++++++++++++
> >  tests/overlay/114.out |  2 ++
> >  tests/overlay/115     | 40 ++++++++++++++++++++++++++++++++
> >  tests/overlay/115.out |  2 ++
> >  tests/overlay/116     | 40 ++++++++++++++++++++++++++++++++
> >  tests/overlay/116.out |  2 ++
> >  tests/overlay/117     | 41 ++++++++++++++++++++++++++++++++
> >  tests/overlay/117.out |  2 ++
> >  tests/overlay/group   | 18 +++++++++++++++
> >  40 files changed, 843 insertions(+)
> >  create mode 100755 tests/overlay/100
> >  create mode 100644 tests/overlay/100.out
> >  create mode 100755 tests/overlay/101
> >  create mode 100644 tests/overlay/101.out
> >  create mode 100755 tests/overlay/102
> >  create mode 100644 tests/overlay/102.out
> >  create mode 100755 tests/overlay/103
> >  create mode 100644 tests/overlay/103.out
> >  create mode 100755 tests/overlay/104
> >  create mode 100644 tests/overlay/104.out
> >  create mode 100755 tests/overlay/105
> >  create mode 100644 tests/overlay/105.out
> >  create mode 100755 tests/overlay/106
> >  create mode 100644 tests/overlay/106.out
> >  create mode 100755 tests/overlay/107
> >  create mode 100644 tests/overlay/107.out
> >  create mode 100755 tests/overlay/108
> >  create mode 100644 tests/overlay/108.out
> >  create mode 100755 tests/overlay/109
> >  create mode 100644 tests/overlay/109.out
> >  create mode 100755 tests/overlay/110
> >  create mode 100644 tests/overlay/110.out
> >  create mode 100755 tests/overlay/111
> >  create mode 100644 tests/overlay/111.out
> >  create mode 100755 tests/overlay/112
> >  create mode 100644 tests/overlay/112.out
> >  create mode 100755 tests/overlay/113
> >  create mode 100644 tests/overlay/113.out
> >  create mode 100755 tests/overlay/114
> >  create mode 100644 tests/overlay/114.out
> >  create mode 100755 tests/overlay/115
> >  create mode 100644 tests/overlay/115.out
> >  create mode 100755 tests/overlay/116
> >  create mode 100644 tests/overlay/116.out
> >  create mode 100755 tests/overlay/117
> >  create mode 100644 tests/overlay/117.out
> >
> > --
> > 2.17.1
> >
