Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4CDC4338F
	for <linux-unionfs@archiver.kernel.org>; Sat,  7 Aug 2021 11:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1464360C51
	for <linux-unionfs@archiver.kernel.org>; Sat,  7 Aug 2021 11:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbhHGLFp (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 7 Aug 2021 07:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbhHGLFo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 7 Aug 2021 07:05:44 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51E0C0613CF
        for <linux-unionfs@vger.kernel.org>; Sat,  7 Aug 2021 04:05:27 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id i7so11073001iow.1
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Aug 2021 04:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lHbIjo3VMqD+pIv3Kc+QbiB08JrBMboTeRuMYb9ZO9M=;
        b=tSBqzs+X282M7Y7KfJ7cf8e0HKHIjvov0y9l7rnyP4z0b+EkXvWa+GcxhHNZNg83Zu
         uhGg77IxNmz3lqjKB9fgBXP/Hk6+MThMXt56LM18uUcX/9RQRQEEivC00ebJXrS7FGY1
         IvmR4qbIld7yBsAa9bymT4iAt6pXXU2f18TmLZl6MKa0CHt1JtQHf5u+iu2ar71FyXTB
         XdD5WjtIfbgrLzPcPIGr3Z8GvTJj1p8/4HccuZ4O4HbuCh8jiGOFU5XXDeE/wPocluka
         Nyo0SFdF+JuOukiFT6ASJyvB02TBQoIKqpdDD7iBmAFCdP1HPw7ijS51DOnd6gb89jwy
         4dvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lHbIjo3VMqD+pIv3Kc+QbiB08JrBMboTeRuMYb9ZO9M=;
        b=kH0GjStt2lWxb9k5LzxTkgp+WvPrhTbJUqzQixivmHc2w5oymdOBwglVNHSDjQsWYR
         bf56EXgs2RF5ZvYfm9maG08Y02ClkRV3alJX7CH/gRrhhR1wtTs5w5YmZPjeWsC9rZuz
         pnZvvqc46bPezOMB0I0kT5qfU/0Wkz+ADkM3SaCtvN+NHGVuIgUZy1lPnpaHnA6Jfpb4
         pNY8NEx9klflOV5ETV5ESf3YYtm/jGDDjSy/6OgrjgrH2hXo0f4H2EeVMRPpgqqcrqjs
         VY+auVBtIShl54lmohxsSAnfy5Cq4ul7olHURlUUr/VTlkpNlTrnVDE+1SMfGu5nXz08
         odaQ==
X-Gm-Message-State: AOAM530VbABEX7M/kx0g0Gf5Liw+DRT3+84+95Uvleb7PAkW0jVMBGoc
        qzSeduBLo6StLzOJkFdpt6pEi1p3xYrCwOwv5X8=
X-Google-Smtp-Source: ABdhPJweJRTmW+Yno3G+Ueo/BSMCfzf/Nd3Bh6GqBEyaKJPjLPq5ASorMksKk8vMpWz84zNSajH8rzIcdttZp1/14nA=
X-Received: by 2002:a92:d5d0:: with SMTP id d16mr191861ilq.137.1628334326974;
 Sat, 07 Aug 2021 04:05:26 -0700 (PDT)
MIME-Version: 1.0
References: <ec78de1b-4edb-1eea-5c0d-79e65f139d79@huawei.com>
In-Reply-To: <ec78de1b-4edb-1eea-5c0d-79e65f139d79@huawei.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 7 Aug 2021 14:05:15 +0300
Message-ID: <CAOQ4uxiO7zt7sywNqyd-WwCVds9-NqRAixham9yVeN7F+JhXoA@mail.gmail.com>
Subject: Re: [QUESTION] Why overlayfs cannot mounted as nfs_export and metacopy?
To:     Zhihao Cheng <chengzhihao1@huawei.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Aug 7, 2021 at 1:17 PM Zhihao Cheng <chengzhihao1@huawei.com> wrote:
>
> Hi, all.
>
> As title said. I wonder to know the reason for overlayfs mount failure
> with '-o nfs_export=on,metacopy=on'.
>
> I modified kernel to enable these two options 'on',  it looks like that
> overlayfs can still work fine under nfs_v4.
>
> Besides, I can get no more information about the reason from source
> code, maybe I missed something.
>

It's because ovl_obtain_alias() (decoding a disconnected non-dir file handle)
does not know how to construct a metacopy overlayfs inode.

Maybe Vivek will be able to point you to the discussion that lead to making
the features mutually exclusive.

I don't remember any other reason.

Thanks,
Amir.
