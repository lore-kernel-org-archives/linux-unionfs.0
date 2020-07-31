Return-Path: <SRS0=/0gG=BK=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E13C433E0
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jul 2020 12:35:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3386521744
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jul 2020 12:35:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fo6K9MKp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733093AbgGaMfw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 31 Jul 2020 08:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733077AbgGaMfw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 31 Jul 2020 08:35:52 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADECC061574
        for <linux-unionfs@vger.kernel.org>; Fri, 31 Jul 2020 05:35:52 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id r12so25166670ilh.4
        for <linux-unionfs@vger.kernel.org>; Fri, 31 Jul 2020 05:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lrzOYdSgDz3vNIfjovjmV1358YKA84RMjMQEVtRWz+A=;
        b=Fo6K9MKpIH1+LZ3bmrX4o0TBe/LLQq6plRKgQySAJ6VzdVp2go763V3Dnda9kPT4Sj
         cbnFoKf+nMDWjD0GuWhEysBHfRz8Bjhqcwn0M/xVGHg0AnSUxKsJzybPvpYxHV9eaTQi
         XEtFUoqLTxOyK+UHjhFaEhgm2ZlK4BiyHvnFr8hI2ohzqAdI9Av6SgA786BS+YZk1VMu
         4LqfZbObnZZxQWxeUi2H1EXaxYFw2Acpd2qbjESPFMhzqus2cwZgZmt+tbP01GU4SOdy
         /zg3/GIKT1aLxCiDAnRcDnqAQ1aX4yFdVCcysFItQvEGsYZKMwSWZkZ4R9u7tIgiANwL
         3WWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lrzOYdSgDz3vNIfjovjmV1358YKA84RMjMQEVtRWz+A=;
        b=e3n+caGt1eSiwr/9wtxEehvBdmNKXG0Q7sGcfuBw8qfj25cH3/VMErxJQ0T8ST6vHU
         43BatSNrlIXJu99tuA8htvhLoWD4iUHfjomHZvNmX9TQwEL0Nqz3xA1kqoslELVwBoW0
         P5/Hmeb6JpXtlKK0ECXc68BCEaoF/E2MpNgbrDgLbmc2uih8CYH/3LafVBZvmaS9V1dk
         5FmG/2/Lh19Gg2KLcSexfC+cAMt3OkqGLjPLMivAk+txAYsL2j5VXWTs9+10L53vqSZT
         I+CnhK9Ca19EzKvZ6HkdOx+ZkDGq5E/ET2DVePfpRWekpZGMI0TpqgwkS8tC45hcH3rt
         DkJw==
X-Gm-Message-State: AOAM530XlvEdtj5ztX9lOFxMNVfDmO8cQ/Yl1cUkSGFAN6+z3OV/ypGr
        qTXIPoOWKxHrAEtjr1f9vvZq9sss+aR+15KTBeM=
X-Google-Smtp-Source: ABdhPJzshAHwWryVCWA2jjJVW4wTaeHOaTeDO9MEcF9AzMVsHEPakNDpRlSDI0OVV30uueobJx5Aj/VqQF8QdpYnb1k=
X-Received: by 2002:a92:da0e:: with SMTP id z14mr3429034ilm.275.1596198951534;
 Fri, 31 Jul 2020 05:35:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAOQ4uxhi63LPKdmkEJjnTEgy0VaX0qXML2Uz_258_B2iZcqd3w@mail.gmail.com>
 <20190709141302.GA19084@redhat.com>
In-Reply-To: <20190709141302.GA19084@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 31 Jul 2020 15:35:40 +0300
Message-ID: <CAOQ4uxjWc8WFRFS8GTpz8uE1AHrs6yGx2A3fZy-Sxfu7CCyKuw@mail.gmail.com>
Subject: [RFC] Passing extra mount options to unionmount tests
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> >
> > If anyone is running unionmount-testsuite on regular basis
> > I would be happy to know which configurations are being tested,
> > because the test matrix grew considerably since I took over the project -
> > both Overlayfs config options and the testsuite config options.
>
> For me, I think I am most interested in configuration used by
> container runtimes (docker/podman). Docker seems to turn off
> redirects as of now. podman is turning on metacopy (hence redirect)
> by default now to see how do things go.
>
> So for me (redirect=on/off and metacopy=on/off) are important
> configurations as of now. Having said that, I think I should talk
> to container folks and encourage them to use "index" and "xino"
> as well to be more posix like fs.
>

Hi Vivek,

I remember you asked me about configuring extra mount options
for unionmount but couldn't find that conversation, so replying to this
related old discussion with my thoughts on the subject.

Now that unionmount supports the environment variables:
UNIONMOUNT_{BASEDIR,LOWERDIR,MNTPOINT}

And now that xfstests has helpers to convert xfstests env vars to
UNIONMOUNT_* env vars, one might ask: why won't we support
UNIONMOUNT_OPTIONS=$OVERLAY_MOUNT_OPTIONS

So when you asked me a question along those lines, my answer was that
unionmount performs different validations depending on the test options,
so for example, the test option ./run --meta adds the mount option
"metacopy=on", but it also performs different validation tests, such as
upper file st_blocks == 0 after metadata change.

Right, so I gave a reason for why supporting extra mount options is not
straight forward, but that doesn't mean that it is not possible.
unionmount test could very well parse the extra mount options passed
in env var and translate them to test config options.  As a matter of fact,
unionmount already parses the following overlay module parameters
and translates the following values to test config options:

1) redirect_dir does not exist => --xdev (expect EXDEV on dir rename)
2) redirect_dir exists and no explicit --xdev => add redirect_dir=on
3) index=N and --verify => add index=on and check st_ino validations
4) metacopy=Y => check --meta validations (e.g. upper st_blocks)
5) xino_auto=Y => add xino=on and check --xino validations (e.g. uniform st_dev)

So apart from blindly adding the extra mount options to mount command,
will also need to translate:

6) redirect_dir=off => --xdev
   (redirect_dir=on conflicts with --xdev)
7) index=off => overrides index=on added by --verify
   (st_ino validations should still pass on tests without multi layers)
8) metacopy=on => --meta
   (metacopy=off conflicts with --meta)
9) xino=auto/on => --xino
   (xino=off conflicts with --xino)

At the moment, I have a patch to xfstests [1] that implements rule 8 in the
xfstests _unionmount_testsuite_run helper, but I came to realize that would
be wrong and that the correct way would be to implement conversion rules
6-9 in unionmount itself and then blindly assign in xfstest helper:
UNIONMOUNT_OPTIONS=$OVL_BASE_MOUNT_OPTIONS

Does anyone spot any obvious flaws in this plan before I make those changes?

Thanks,
Amir.

[1] https://github.com/amir73il/xfstests/commits/unionmount
