Return-Path: <SRS0=Lx5L=AZ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3A86C433DF
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 18:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B141D225AA
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 18:43:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H9c0UwjM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgGNSnF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 14:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgGNSnE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Jul 2020 14:43:04 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2194C061755
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 11:43:04 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id h16so15049303ilj.11
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 11:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HnehJ/eREZ26ebP7II0PgYHu10ywuG7wkZJyI3i7Gxs=;
        b=H9c0UwjMOmjtbuSBRYxp0v6/mSMH/1sHfG2OZ571kZEUjctMxfdITZOgr5rWW27/v7
         I86H8aD7Ow2YZ3tmwr2AuW93ZCTrLqVrg/1T9rvaIuNfxTYCUMg3gLEE30EmBVxFbUXO
         3nEJ2Br28jGwujBYVOj/bNIM4B1wP7IxKoaXo22LCBrF1BjDZUMEIRbJzUiOzKb63jq0
         YX7JSLfYs5xXBTcXPCX+riHVJ0zS+F6BTtI1GRdmpHlSliRTBozqrWsj1R3iyzrjOYDX
         chp4cSJR0bDXZYC7gro1saSP8PTmTjX0lM6muJyKwHFE2pQrjcndQkELMsMcSPN6Lwfa
         exVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HnehJ/eREZ26ebP7II0PgYHu10ywuG7wkZJyI3i7Gxs=;
        b=TWpIN5FuvxhSvqLs910PO86/UmGKDmpb2GEIlKQ6QDDXx1hKXGOAZL+8G0sCEO+Hxf
         ecG/69H/K953cJZd5FHOdYyA35DaVQPJm+TSObiSkZchyvTTD70c/yhOIiSaBxfcRdcs
         R+Dxp1WUzhPTvAdOxnivcZebeMQdKi6ifha2YTrMm7wTI6IJ4Nx7mMDidrxJyG5d7WRt
         e+YdVBVYgJv+THRsJY4SAg4fhOEbaSL/EEzuuj2JA82cZLstO7+Uecxv1/HnKXwm6i/K
         MSmypBhTvMC+oVPl60+A20hhwMQUCE5ipqn53MDoRo3DC2rJspMTMKCfQ7fz3onCyZh0
         pM1A==
X-Gm-Message-State: AOAM533pecPPkxN+LROMPfzy4NLDnNLdHi8Rg/daRnkEcD5/t6dtTyfs
        c0rfJbuSMpQEWewtsS5cFOOIBfLu63BwlPwCwvM=
X-Google-Smtp-Source: ABdhPJxTk4VgKu27X1y+CUDyxOPT8KhYUzTmG3KtYgHD8lsRGdDheoQkGxJKg3cD26/KV8GuzNJ/omAXJtDmwZyNvfs=
X-Received: by 2002:a05:6e02:13e2:: with SMTP id w2mr6243043ilj.9.1594752184276;
 Tue, 14 Jul 2020 11:43:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200713141945.11719-1-amir73il@gmail.com> <20200714180705.GE324688@redhat.com>
In-Reply-To: <20200714180705.GE324688@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 14 Jul 2020 21:42:53 +0300
Message-ID: <CAOQ4uxh-fUKhiQOhRmZ5LT2sjtM3Wx5wo_wcKYtX+-DbYjXp0Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] Misc. redirect_dir=nofollow fixes
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jul 14, 2020 at 9:07 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Mon, Jul 13, 2020 at 05:19:42PM +0300, Amir Goldstein wrote:
> > Miklos, Vivek,
> >
> > Following discussion on following an unsafe non-dir origin [1]
> > and in a addition to a fix for the reported null uuid case [2] and to
> > Vivek's doc clarification [3], I am proposing to piggy back existing
> > config redirect_dir=nofollow to also not follow non-dir origin.
> >
> > Like in the case of non-dir origin, following redirects behavior was
> > added with no opt-out option in kernel v4.10.  Later security concerns
> > about following malformed redirects resulted in the redirect_dir=nofollow
> > config option.
>
> So what's the security issue you are seeing with malformed origin? If

TBH I never really understood the thread that led to redirect_dir=nofollow.
I don't think anyone has presented a proper use case that can be discussed,
so I just treat this config option as "paranoia" or "don't give me anything that
very old overlay did not give me".
Therefore I suggested piggybacking on it.
Of course if we do, we will need to document that.
BTW, I have another patch that does not follow mismatched lower dir origin
with redirect_dir=nofollow, i.e.:

 bool ovl_verify_lower(struct super_block *sb)
 {
        struct ovl_fs *ofs = sb->s_fs_info;

-       return ofs->config.nfs_export && ofs->config.index;
+       return ofs->config.nfs_export || !ofs->config.redirect_follow;
 }

That makes even more sense for "paranoia" IMO.

Thanks,
Amir.
