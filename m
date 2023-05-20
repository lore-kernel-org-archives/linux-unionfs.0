Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F9F7C77B7F
	for <linux-unionfs@archiver.kernel.org>; Sat, 20 May 2023 13:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbjETNTz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 20 May 2023 09:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbjETNTw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 20 May 2023 09:19:52 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBA0BF
        for <linux-unionfs@vger.kernel.org>; Sat, 20 May 2023 06:19:50 -0700 (PDT)
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 3F4D13F4A6
        for <linux-unionfs@vger.kernel.org>; Sat, 20 May 2023 13:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1684588788;
        bh=NzthO7BMG0Z86lKTG5pcPZLaqdSgk8GzDOcuVAlDI3A=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=wXdF+c8Wfz0aZ5OVDhy/iU5/99nBsm6BwOUXsQcP1y9sUr6EX3Q4TeZgZ7E68MX0q
         SqXk7gt/X3w4OdZsA8exzwIiY3dlqb/F+dB9cif5Dkd1FfuKwKFqUZQvNqEZI+6jdv
         U68XxTLZmDG8QWSBIfU8wg0AgeP3fbUh5O7mNo8yKJIUpbA3uLbOt4DhwclFCiKuu2
         lO1F1zzsOc9yG4Hcc2ytSShVaykTukmfu7JS8EKNTtfEfgB1XZ1qfVuZjR+VxWZz4U
         l5mng90Xez039mv6AM0lL94G9TimmwbkwqCsrlpVTlfb5TvFcZagJAWWJKKVnfMXhI
         DwbEAlugFnXWw==
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-9698409b9bfso241590366b.1
        for <linux-unionfs@vger.kernel.org>; Sat, 20 May 2023 06:19:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684588787; x=1687180787;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NzthO7BMG0Z86lKTG5pcPZLaqdSgk8GzDOcuVAlDI3A=;
        b=ST9XlFzDtnP0e8Mdf0e8iPt1dtvkVxOgg/m2Gu5+s0a/jphwupCkIPnURp/bAlg0vJ
         MSCOa9r0rEPjJlf/SeaO8TKdDtA/K4gd53CMUo24cIs0nqwN5gA31jw8dPo9lBtuon5U
         PsTO/7zLz+pmNscw41YWyWjkwMW+fgWQGkTZoPIfAXBkR2x3VS04oBUbZGhTaXuaA2b2
         MhL2QOq9qIzbYVpU1StVLen2WxJOEUaYOtbOf+5bktfkmg9HcxQoctDo+XqC5oHDeX4Z
         KOqpa9zKN12vXabxxSfAwNw8Qnciyfn/0m8LpBnnBc1W6p+mssE/cDfIbvd8McdP3BnB
         gRXw==
X-Gm-Message-State: AC+VfDy8/NBJFTk3IiKBcbSWxAHVN9G+12iWSKrvUYrY5JZlo0l+SXtz
        7A8rnj6ey4QfNKu1bZyjlAVhMmarxI2pUwcGCWg33Dx53WnAdwXP8GtXMFe4x2k8movKhkyCUPO
        SP31TlqM3Tx4VOJIp67w5rtx4MKpPB92mFth/6uapg5w=
X-Received: by 2002:a17:907:360c:b0:969:9c0c:4c97 with SMTP id bk12-20020a170907360c00b009699c0c4c97mr4345924ejc.1.1684588787746;
        Sat, 20 May 2023 06:19:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7du0+pcc/ypA6rXudHicfHbFFFlQPmbDMyIlAS1D42x2hBvPlKAhnw6o02K4eWbFkgkHqzhA==
X-Received: by 2002:a17:907:360c:b0:969:9c0c:4c97 with SMTP id bk12-20020a170907360c00b009699c0c4c97mr4345910ejc.1.1684588787417;
        Sat, 20 May 2023 06:19:47 -0700 (PDT)
Received: from localhost (host-87-10-127-160.retail.telecomitalia.it. [87.10.127.160])
        by smtp.gmail.com with ESMTPSA id s14-20020a170906c30e00b0094f410225c7sm770863ejz.169.2023.05.20.06.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 May 2023 06:19:47 -0700 (PDT)
Date:   Sat, 20 May 2023 15:19:44 +0200
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ovl: make consistent use of OVL_FS()
Message-ID: <ZGjI8Hutt9JwuN/i@righiandr-XPS-13-7390>
References: <20230520120528.339680-1-andrea.righi@canonical.com>
 <CAOQ4uxjOgWDqufLcabkkPcxvFcrehzoDuO0d6kdJZuoiRBKStw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjOgWDqufLcabkkPcxvFcrehzoDuO0d6kdJZuoiRBKStw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, May 20, 2023 at 03:33:32PM +0300, Amir Goldstein wrote:
> On Sat, May 20, 2023 at 3:20 PM Andrea Righi <andrea.righi@canonical.com> wrote:
...
> > @@ -97,6 +99,8 @@ static inline struct mnt_idmap *ovl_upper_mnt_idmap(struct ovl_fs *ofs)
> >
> >  static inline struct ovl_fs *OVL_FS(struct super_block *sb)
> >  {
> > +       /* Make sure OVL_FS() is always used with an overlayfs superblock */
> > +       BUG_ON(sb->s_magic != OVERLAYFS_SUPER_MAGIC);
> 
> 1. Adding new BUG_ON to kernel code is not acceptable - if anything
>     you can add WARN_ON_ONCE()

OK, but accessing a pointer to a struct ovl_fs that is not really a
struct ovl_fs can potentially have nasty effects, even data corruption
maybe? I'd rather crash the system now rather than experiencing random
behaviors later...

> 2. If anything, you should check s_type == s_ovl_fs_type, not s_magic

Hm.. is there a fast way to determine when sb->s_type == overlayfs?
Using get_fs_type() here seems quite expensive and I'm not even sure if
it's doable, is there a better way that I don't see?

> 3. It is very unclear to me that this check has that much value and OVL_FS()
>     macro is very commonly used inside internal helpers, so please add a
>     "why" to your patch - why do you think that it is desired and/or valuable
>     to fortify OVL_FS() like this?

Sure, I can send a v2 explaining why I think this is needed. Basically I
was debugging a custom overlayfs patch and after a while I realized that
I was accessing the sb->s_fs_info of a real path (not an overlayfs sb),
using OVL_FS() with a proper check would have saved a me a bunch of
time.

Thanks for looking at this!
-Andrea
