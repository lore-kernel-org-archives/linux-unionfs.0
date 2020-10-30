Return-Path: <SRS0=w8z3=EF=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3B1C4363A
	for <linux-unionfs@archiver.kernel.org>; Fri, 30 Oct 2020 12:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7856C206E9
	for <linux-unionfs@archiver.kernel.org>; Fri, 30 Oct 2020 12:16:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Z6fgzpu8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgJ3MQE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 30 Oct 2020 08:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgJ3MQE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 30 Oct 2020 08:16:04 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6031C0613CF
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2020 05:05:51 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id u16so2404861vsl.13
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2020 05:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kEFI5IoaRNxIAf7DKw6N5BawBOQRfFBfmntEXGVcmCg=;
        b=Z6fgzpu8RzTZXee0TpfWh15utmrC6AxRC+azYan5eqbBVtFLMVxkEbS0ZNXDgva33e
         DPlRLchyaQE26hfIak4xtJVLHErOkZimpA2JBlcgx6aoIsff4+C86WHMm4vYrc5ZiWYf
         QJ5hO39tZjmIzGWZUYYwhoGWnIRtaAxkcV8BY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kEFI5IoaRNxIAf7DKw6N5BawBOQRfFBfmntEXGVcmCg=;
        b=N/yhL6d2j5+PVitGoNpDEzpM1Cel45lRV5oHP9B1jUWTJZPinFvPpnkW1iBEaJmfqe
         NTR3EPoOskcg/1omU8FA0lbZ4fsE2N4t6orQ0x7kAhZt2PamKAjnMS4liFkW6PUIj14+
         NQBSYGTS0Da0oC/fZUYxSNHD70XLo3nOHn7mFMIXA42IfmJ9+AnbwF+BtIly+u0M6Q59
         Cda9uvYNn5SftooxZcW+q+6geEl06bEBKHl+Xes2UJHdm6DfSngGs7hczerrE4flqbrC
         DBJSzKe4a8kfovwLY71GMIALyDzDhNViOXw67yKoQNB9TZTXQZed7+rS8wVzMvNc/iEM
         cNbw==
X-Gm-Message-State: AOAM531jmaIkxL47smbGTlo9zmTxGQ5eMNrUIosFTOJqSpNpcF2hm24b
        oBU/jHUwbdZB0GCzwxclZljgR09ECaZt/8Xh5/s9Tg==
X-Google-Smtp-Source: ABdhPJw8iFMm7LPaGk5nSpgMHZnPAB/oWPe6xLCHIzRUfia26c9ZRKqVOnMYdhjnF6XtEbKDOFBnN+Nc+Kl9LPEIrNw=
X-Received: by 2002:a67:2b47:: with SMTP id r68mr4941252vsr.7.1604059551180;
 Fri, 30 Oct 2020 05:05:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200713141945.11719-1-amir73il@gmail.com> <20200713141945.11719-4-amir73il@gmail.com>
In-Reply-To: <20200713141945.11719-4-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 30 Oct 2020 13:05:36 +0100
Message-ID: <CAJfpegvhH+SUn-QModbU23sk3=NGYgxKSekh5B70JfK_=HbHfw@mail.gmail.com>
Subject: Re: [PATCH 3/3] ovl: do not follow non-dir origin with redirect_dir=nofollow
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 13, 2020 at 4:20 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Following non-dir origin can result in some bugs when underlying layers
> are edited offline.

Sorry, lost track.  What bugs this results in?

Thanks,
Miklos

  To be on the safe side, do not follow non-dir
> origin when not following redirects.  This will make overlay lookup
> with "redirect_dir=nofollow" behave as pre kernel v4.12 lookup, before
> the introduction of the origin xattr.
>
> Link: https://lore.kernel.org/linux-unionfs/CAJfpegv9h7ubuGy_6K4OCdZd3R7Z4HGmCDB2L7mO5bVoGd6MSA@mail.gmail.com/
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index ae1c1216a038..31ee5a519736 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -861,7 +861,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                         err = -EREMOTE;
>                         goto out;
>                 }
> -               if (upperdentry && !d.is_dir) {
> +               if (upperdentry && !d.is_dir && ofs->config.redirect_follow) {
>                         unsigned int origin_ctr = 0;
>
>                         /*
> --
> 2.17.1
>
