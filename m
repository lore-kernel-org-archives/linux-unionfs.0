Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1CAC433DB
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Mar 2021 02:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AF3A6500F
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Mar 2021 02:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCECKI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 4 Mar 2021 21:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhCECKI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Mar 2021 21:10:08 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DF2C061756
        for <linux-unionfs@vger.kernel.org>; Thu,  4 Mar 2021 18:10:06 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id d13so517331edp.4
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Mar 2021 18:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O9ReJcy8RlfrDC/fAF+2CwFahTTparPVhDqzUGMBrqE=;
        b=woUbkBjqxCS2IzG7iYf9ZxU8YwMf3pJO3aanguwN3a9ejhULoWEEOvedgeoMmHRpcB
         CpQzvoHNNVNY87HzO0gGKcpMCjp4M8uu5mMdOWxgia7GfLsIbD8ES+Z+e3KauORxPdOK
         tlebWgMEU78s2xbRwVrz2Nj/0VnNV7/j1+3xgsUuaA8Cp3kWX0x+zx//hB3IKKcrleOG
         A4uNsMamZ+CPRpSooYpTI+Ce17zHiTrsImBHPR3oD8XjSzu42+tZ1c+B1WvAtc3dYg16
         9MCq6l7p86q7RtEMYjjK8fDmSTdUo6uF+jifM/wooLUjKcs+bS4MI9Ah9al7vOhMrO2s
         kjAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O9ReJcy8RlfrDC/fAF+2CwFahTTparPVhDqzUGMBrqE=;
        b=dHz9QRkyZU+h7X8gmqVpJvYUVMOSb/j6TLiDKazxoH/AgVWV3feaEcBOJcQYbvFG+/
         rrf/MaJ2jvbLUVYSK7Kv7E5Uo9YA+tqDGLgPfT77qQG8xEF+1e2gBNpzOaWPoPqO4lX2
         t3Xxtw5MCSBXy+OtPdEOP/FcwyUkhCV4tVxgVhg5VnS7DwwD8A1LnkwL8gyvxvBTXKi/
         kPUB/ZNnsaiucDC/rkD0iSSXWUDpyoSTj4qaUNH3WtWrMl/6TXo1gtJinyQg/CgbCQb9
         B08Q/OYzD2w3LRSiWOJcO8nkxWEJqXZqXP8PTE7fzUKKT1ADV10E8Khm3VXsrWS7BK5x
         9Kmw==
X-Gm-Message-State: AOAM533wbcdX6hjI6RV8D8OHDa3NuM7Icoh3GIAD4u78hbXEmzI7H7l3
        F3I6yM5jy0IwVdbR9szstLmKkDm/n/lyZVHR14cihqhSWVlw
X-Google-Smtp-Source: ABdhPJwU/jYv/w94e0kLCOV17GeQZelv+fX7z5DY6QQvma7jKikZr0KQ9k1MEZKv+mWLLb81+E/rWaCcJnm1odjFkpU=
X-Received: by 2002:a05:6402:1cc1:: with SMTP id ds1mr3615411edb.135.1614910205565;
 Thu, 04 Mar 2021 18:10:05 -0800 (PST)
MIME-Version: 1.0
References: <20210211180303.GE5014@redhat.com> <CAHC9VhRM6MiF1m2aFpLJKb3CFWXcXEX_SY=EnkLaq7U_X2UTZw@mail.gmail.com>
In-Reply-To: <CAHC9VhRM6MiF1m2aFpLJKb3CFWXcXEX_SY=EnkLaq7U_X2UTZw@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 4 Mar 2021 21:09:54 -0500
Message-ID: <CAHC9VhSrcMS7BxZ9R=RUb-5DkWxT_6ELpcm1-1XwszkzVmwrgQ@mail.gmail.com>
Subject: Re: [PATCH][v2] selinux: Allow context mounts for unpriviliged overlayfs
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     selinux@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Feb 11, 2021 at 4:24 PM Paul Moore <paul@paul-moore.com> wrote:
> On Thu, Feb 11, 2021 at 1:03 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > Now overlayfs allow unpriviliged mounts. That is root inside a non-init
> > user namespace can mount overlayfs. This is being added in 5.11 kernel.
> >
> > Giuseppe tried to mount overlayfs with option "context" and it failed
> > with error -EACCESS.
> >
> > $ su test
> > $ unshare -rm
> > $ mkdir -p lower upper work merged
> > $ mount -t overlay -o lowerdir=lower,workdir=work,upperdir=upper,userxattr,context='system_u:object_r:container_file_t:s0' none merged
> >
> > This fails with -EACCESS. It works if option "-o context" is not specified.
> >
> > Little debugging showed that selinux_set_mnt_opts() returns -EACCESS.
> >
> > So this patch adds "overlay" to the list, where it is fine to specific
> > context from non init_user_ns.
> >
> > v2: Fixed commit message to reflect that unpriveleged overlayfs mount is
> >     being added in 5.11 and not in 5.10 kernel.
> >
> > Reported-by: Giuseppe Scrivano <gscrivan@redhat.com>
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  security/selinux/hooks.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
>
> Thanks Vivek, once the merge window closes I'll merge this into
> selinux/next and send a note to this thread.

I just merged this into my local selinux/next and will be pushing it
to kernel.org later tonight.  Thanks!

-- 
paul moore
www.paul-moore.com
