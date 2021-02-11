Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582E7C433DB
	for <linux-unionfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D0EE64DD8
	for <linux-unionfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbhBKX3P (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhBKX3M (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 11 Feb 2021 18:29:12 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB12C061756
        for <linux-unionfs@vger.kernel.org>; Thu, 11 Feb 2021 15:28:32 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id b9so12666652ejy.12
        for <linux-unionfs@vger.kernel.org>; Thu, 11 Feb 2021 15:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZS/Kb4C0pmzvsqhMC2Ou+1Mu1lc/Bk7sljYJuO8Ll2w=;
        b=SX5PQG4/TxfGT8wYPOCEV4aXq9/ofAAsZMVMb2zXa6KzsqLTHFy9tk7ZfWyG/lbBMb
         ByfxPMXyH8vbbXKAZAa/+HBdV/lJmzYMOCxpt0i+DieCiBUCMPaG17u+0oUqpQoUceJx
         WH3JwHtylDgKuzSLsWSrEQLjKyf8iSrQQpxLgb3kKsTMOAXkIWtDyvyeatTcWGXFnB5d
         jcJKrijOoYejTBI1i1yKUOBx0ZB+CbgJ8dQXD3QCMxx1jzmQm9TxQvz1y7Al1IHuCKMS
         jn252ISvt4tlUMYr4ZMumbSTx5ro5K2/9IFBBE8iyAOr8SViLpPWhRfq5sv1x6RTylLe
         TYFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZS/Kb4C0pmzvsqhMC2Ou+1Mu1lc/Bk7sljYJuO8Ll2w=;
        b=JCJYQNlgmOnZKm5qg9emEABH//vaBilKCtdMQduZdw4z2VUTzDnmTnXYGnRC7Y6Fqs
         JE7HOxG5cFZdFniqMzwE9427z9a+/Gt5/AFQimYWHQlPrlWm1NquSHfDGD2ZKiDUeRGU
         wv85g4rp8grvdwT+u//LJNKPwfUeOYJSHQ/vWF6edI3h7u/nXolHaYm0U2nLWw7AiH2m
         4Bgvtqo9hXa1NeDqNMcCxBiGhve7NzfO+R8y94AFaNQZ4/qMWTl+jCa/+hHeraFZX6vv
         7if1HfBEPqFQmwBjmSKm2Sc2MwSn0s2ecVn6eqnBMJE49DOBx9LiKYcUGDhccAswpkSG
         n1rQ==
X-Gm-Message-State: AOAM530RtGVWCLnV6E7Us7E7Jift5KAOjkmoG7OzbsI6XPe4p3Trol11
        fHg/VDDsClIV/RJhWt9mwytBMVHr0Akz5BSUfE5e
X-Google-Smtp-Source: ABdhPJyxPMR/IJw7yRDaz9hLSEwtwXj4pCxq52IrPU924l0yN/rZsCs+2HB5gkY9WMU4SXfZgK/Fu/CK1h1aMv7BQQY=
X-Received: by 2002:a17:906:1199:: with SMTP id n25mr62722eja.431.1613086110571;
 Thu, 11 Feb 2021 15:28:30 -0800 (PST)
MIME-Version: 1.0
References: <20210211180303.GE5014@redhat.com> <CAHC9VhRM6MiF1m2aFpLJKb3CFWXcXEX_SY=EnkLaq7U_X2UTZw@mail.gmail.com>
 <bb7b8304-b0fe-f6a3-b1fa-c06193f9cc02@redhat.com>
In-Reply-To: <bb7b8304-b0fe-f6a3-b1fa-c06193f9cc02@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 11 Feb 2021 18:28:19 -0500
Message-ID: <CAHC9VhS_+VT5cSXg+msEajnMYNjegKfubLO0EggaSr2p+JfSuA@mail.gmail.com>
Subject: Re: [PATCH][v2] selinux: Allow context mounts for unpriviliged overlayfs
To:     Dan Walsh <dwalsh@redhat.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>, selinux@vger.kernel.org,
        linux-unionfs@vger.kernel.org,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Feb 11, 2021 at 5:41 PM Daniel Walsh <dwalsh@redhat.com> wrote:
> On 2/11/21 16:24, Paul Moore wrote:
> > On Thu, Feb 11, 2021 at 1:03 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >> Now overlayfs allow unpriviliged mounts. That is root inside a non-init
> >> user namespace can mount overlayfs. This is being added in 5.11 kernel.
> >>
> >> Giuseppe tried to mount overlayfs with option "context" and it failed
> >> with error -EACCESS.
> >>
> >> $ su test
> >> $ unshare -rm
> >> $ mkdir -p lower upper work merged
> >> $ mount -t overlay -o lowerdir=lower,workdir=work,upperdir=upper,userxattr,context='system_u:object_r:container_file_t:s0' none merged
> >>
> >> This fails with -EACCESS. It works if option "-o context" is not specified.
> >>
> >> Little debugging showed that selinux_set_mnt_opts() returns -EACCESS.
> >>
> >> So this patch adds "overlay" to the list, where it is fine to specific
> >> context from non init_user_ns.
> >>
> >> v2: Fixed commit message to reflect that unpriveleged overlayfs mount is
> >>      being added in 5.11 and not in 5.10 kernel.
> >>
> >> Reported-by: Giuseppe Scrivano <gscrivan@redhat.com>
> >> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> >> ---
> >>   security/selinux/hooks.c |    3 ++-
> >>   1 file changed, 2 insertions(+), 1 deletion(-)
> > Thanks Vivek, once the merge window closes I'll merge this into
> > selinux/next and send a note to this thread.
>
> In order for us to take advantage of rootless overlay we need this
> feature ASAP.

It will get merged into selinux/next *after* this upcoming merge
window.  I'm sorry, but -rc7 is just too late for new functionality;
kernel changes need to soak before hitting Linus' tree and with the
merge window opening in about three days that simply isn't enough
time.  Come on Dan, even you have to know that ...

-- 
paul moore
www.paul-moore.com
