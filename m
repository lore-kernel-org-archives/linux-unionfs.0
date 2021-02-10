Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E8EC433E6
	for <linux-unionfs@archiver.kernel.org>; Wed, 10 Feb 2021 23:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0643864E0D
	for <linux-unionfs@archiver.kernel.org>; Wed, 10 Feb 2021 23:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbhBJXwC (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 10 Feb 2021 18:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234133AbhBJXvu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 Feb 2021 18:51:50 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E46C06174A
        for <linux-unionfs@vger.kernel.org>; Wed, 10 Feb 2021 15:51:09 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id f14so7219174ejc.8
        for <linux-unionfs@vger.kernel.org>; Wed, 10 Feb 2021 15:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1M0KC3p1meyDQrYPzDqxypfZ2M1GwZFs8VgujKNOBPw=;
        b=UIZslfjRO/9DuoX7z8lTy1KL6HjZR0/5cZp7deUc8QMR5nfUEzG0dNExmyqkCF4f6y
         WLuSVQFYypxlJksG9emU4luaA9tYyJoc4XeLGX9vvp0DsPHPWlRAX08NmSH3Em3Npnzi
         i6iNNUSZb3Y+yXgHisVAAwJbuv/ojTbhWwRvsEwwHpBhA0zUx6WxjzQq0/7TJKZSE3AX
         5cDtGCSGgyeevLu7cFf9ClQ+7YMuvrqDjLA48QSG9YsoX308kU025vSB2l3zBylA/QGJ
         1rOrBJcb8cq9EkaHm8TzfDTNpHuTzvxKHvX//Us6R88Zkjh/sGRis+1qMIzrTukYe3p+
         Wgdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1M0KC3p1meyDQrYPzDqxypfZ2M1GwZFs8VgujKNOBPw=;
        b=iTjHB4iOX56knIIwVEC5wNUJxGFqdiuQVj501K8kDr7i220ZMdIeSQHTY9Tk3qG2gs
         sr66bNwNkRnhDcXDmJ91ZThkqtiEam9EpFEF3M+/+DzivaD4xR0jF1Ia5W98LdSBCJMu
         GNyapGKwjm55ITqf2mdskvuyECQtkIWuMgYBCB/FGlWPmHxSW4lqZ3AAxgIEkjp2VoD/
         Q1+UAQNT5fpFKR2e1M4cYx/13u3xIYqOj5npBTyFK0UG6VDUPVmHk/cK2x5z2zAZU5nV
         BZkQOqyzJ3ZMiK9x/tfDYsWmK1MQ/LA7HtCK7WBgWxE9THvQOdNehqCa+wimvCoh2mho
         WHIQ==
X-Gm-Message-State: AOAM533aeB8HT7le4RqD6HmOShEB6K3P6hQZS4ku57U1ar1hxMefBaoj
        mS2iFNPVjB5bMUVp9rFIKAdqHVo4CFKyUK+t2BLD
X-Google-Smtp-Source: ABdhPJxbvum50dPhfmLT6PkFvr4im9qOS4UUgVDGP9cifAfcGFXDb/3Tanc5Hf/SztMBKxtZQyI0XsTmkWCqIuEM5Jk=
X-Received: by 2002:a17:906:8519:: with SMTP id i25mr5590393ejx.106.1613001068566;
 Wed, 10 Feb 2021 15:51:08 -0800 (PST)
MIME-Version: 1.0
References: <20210209200233.GF3171@redhat.com>
In-Reply-To: <20210209200233.GF3171@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 10 Feb 2021 18:50:57 -0500
Message-ID: <CAHC9VhQYE3ga53AiK2r-568_=2U0BJe+L4g9U_J0dLinzJqXYA@mail.gmail.com>
Subject: Re: [PATCH] selinux: Allow context mounts for unpriviliged overlayfs
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

On Tue, Feb 9, 2021 at 3:02 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Now overlayfs allow unpriviliged mounts. That is root inside a non-init
> user namespace can mount overlayfs. This was added in 5.10 kernel.
>
> Giuseppe tried to mount overlayfs with option "context" and it failed
> with error -EACCESS.
>
> $ su test
> $ unshare -rm
> $ mkdir -p lower upper work merged
> $ mount -t overlay -o lowerdir=lower,workdir=work,upperdir=upper,userxattr,context='system_u:object_r:container_file_t:s0' none merged
>
> This fails with -EACCESS. It works if option "-o context" is not specified.
>
> Little debugging showed that selinux_set_mnt_opts() returns -EACCESS.
>
> So this patch adds "overlay" to the list, where it is fine to specific
> context from non init_user_ns.
>
> Reported-by: Giuseppe Scrivano <gscrivan@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  security/selinux/hooks.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

This seems reasonable, but since we are at -rc7 this week it will need
to wait until after the upcoming merge window.  It's too late in the
cycle for new features.

-- 
paul moore
www.paul-moore.com
