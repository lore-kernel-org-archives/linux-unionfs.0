Return-Path: <SRS0=dsgN=7S=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645C2C433E0
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 14:38:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F0C1206DC
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 14:38:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DBdT7N1A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgFEOiw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 10:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbgFEOiw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jun 2020 10:38:52 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2724C08C5C2
        for <linux-unionfs@vger.kernel.org>; Fri,  5 Jun 2020 07:38:51 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id l6so9828258ilo.2
        for <linux-unionfs@vger.kernel.org>; Fri, 05 Jun 2020 07:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nToWhQNJiBLpDXTJedlK0vJoOavtrOjmBi34kXhGKIo=;
        b=DBdT7N1AFbSrh37ikjRgrcSMVn3rlXeS5hlyXSaynFJXmmgE2dXw/6KQkby3PNrmAJ
         IWdf3AYPatA8+WJgeO/sK8+tkp+6642yvVbKi3rT76GHg7iWaOVFFonRAyVZr9V3UpT+
         nRq7L9KaolTVLjmJRrXvf+6Dx4oQpNeZgwCH/TsDrnmJVGA4I6eJVWNL7/0tzPwK+/La
         6rfhdz5V1gDB+svRIOh+RyMusBtr5cbNsXnjjfs4EWY8r6MjUczBrM44+H2WbRNjikoK
         BQiaWmpra3+FpjZw669Wi+A5vhHQ1JY4gtops+ZbmuDo/me1OW8MPvm9bcDXYFuCw+l+
         QjYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nToWhQNJiBLpDXTJedlK0vJoOavtrOjmBi34kXhGKIo=;
        b=Lx0ha8BsYFMpp0LGT+L4hiKV0PmIaTF+jDQtKmeqrw+CWl/4ahzMz2tje5Ugu/ZlDV
         Ngi5Dd4/fDHYQjPCnqD213gBC4q0SRc7u8TlVsKTZZRytq0ED6sQ30cqgiJNmLmooBNQ
         W/xEEl2cxPxR+c/Cms7IddHpvPY93/aefv6iDl5WU6pA42cYtuTNbzOKdNLLDvxTeMsK
         +QPnplroEOYs/qjEZ6H28cvqQ+TrTg0+tR/yxbVHHVdJM+8G4owShchJ+9EPARXXyYXG
         cls0SvWDy4RHJ2fuAOpteU6/P8HSqCM/zXX8z6sCjMVKUcO2rN5vmlHta3fHCSMJSSZF
         p4/Q==
X-Gm-Message-State: AOAM532e7wQ2IG/iymUuN+lRLh96BAIrXEa+X7Xq7zxCD6H1bee/tQ+p
        7nQ7IyoemwCLv36JuZ9FfTHXYXtNP2QfWFoZrUg=
X-Google-Smtp-Source: ABdhPJwzBkD8WEBSypnxHFXlXGO2H0VLQ0XtC0VXaYWwgAEh6xdM5lo9+V8cBVfycVgRToh/57vD1Gu+Ogl31Vbm0F8=
X-Received: by 2002:a92:2a0c:: with SMTP id r12mr8549234ile.275.1591367931071;
 Fri, 05 Jun 2020 07:38:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAOQ4uxjFC81hikgg0WaF0Z3Mxkk3iDakKx2Ttuhp_L_2Tnc6xQ@mail.gmail.com>
 <20200108140611.GA1995@redhat.com> <CAOQ4uxiUXk-=RV+cCXvE_0KMjW-3xqFFVkhNx7TmnbtMySh7Gw@mail.gmail.com>
 <20200605143217.GB123988@redhat.com>
In-Reply-To: <20200605143217.GB123988@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 5 Jun 2020 17:38:40 +0300
Message-ID: <CAOQ4uxhP0VPMUSrPReKVaWLzyGkr1CFqiWNtGWOA29uLb0NEhg@mail.gmail.com>
Subject: Re: OverlaysFS offline tools
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        StuartIanNaylor <rolyantrauts@gmail.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        kmxz <kxzkxz7139@gmail.com>, "zhangyi (F)" <yi.zhang@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <christian.brauner@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> Hi Amir,
>
> I can't seem to access this abstract proposal (Despite the fact I
> created a new login id).
>

Maybe it needs to be accepted to become public, anyway:

Containers are by far the biggest use case for overlayfs.
Yet, there seems to be very little cross talk between overlayfs and
containers mailing lists.

This talk is going to present some opt-in overlayfs features that were
added in recent years (redirect_dir, index, nfs_export, xino,
metacopy).

Most of those features have not been enabled by most container
runtimes, because of various reasons:

* Requires more development in userspace (image migration)
* Unrelated runtime bugs (mount leaks)
* Mismatch for containers needs
* Lack of promotion

This talk is about giving the opportunity to container runtime
developers to better understand what they may get from overlayfs.

This talk is not about containers wish list from overlayfs, because
userns overlayfs mount needs 45 minutes on its own...

Thanks,
Amir.
