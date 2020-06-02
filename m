Return-Path: <SRS0=S/H/=7P=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78AE5C433DF
	for <linux-unionfs@archiver.kernel.org>; Tue,  2 Jun 2020 08:07:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5532A2072F
	for <linux-unionfs@archiver.kernel.org>; Tue,  2 Jun 2020 08:07:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PJaNK1tu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgFBIHd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 04:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgFBIHc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 2 Jun 2020 04:07:32 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA55C061A0E
        for <linux-unionfs@vger.kernel.org>; Tue,  2 Jun 2020 01:07:32 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id h4so6597104iob.10
        for <linux-unionfs@vger.kernel.org>; Tue, 02 Jun 2020 01:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/2AxvDUnnweqWfkba/72d7fCBjMdCPGpGM3mwWifqUY=;
        b=PJaNK1tuqjlvcHV/I66Tc0b9xLlZ9ZKMMzgWPLdGSEXrrBW2mM6IZpj3vkiiF4D6jw
         sk8SGpXu2nczyEIcHW3Hx+7F1lMaWZDnMcpKh5IJ0BlCgw3U/1sGeRupdyBkS3HQ7kYD
         euAIEie1GA+jJWHr4CZcV5UZsyoxdztD9TtxnYvPrDfCoRZUiAja4eEABkVg+uWyf97s
         TFsam1JsPT+Ebuht9xbE8zIBLEpqtr9qEVRfWseQdc2UjTMforfExgOBWvj1izT41PDs
         n4iCZk/LmD/yx58RyF9kJqsUMIC4sDores9BpSGF/3HdpS3QAZN/JVfzzKStUQTkLEMX
         0raQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/2AxvDUnnweqWfkba/72d7fCBjMdCPGpGM3mwWifqUY=;
        b=FM7ia8eHJSeqSbN41JTRauTaRfEaoW287P5/P5oUWT90delywQ4lcPx1eIJClsfTpw
         oEzvP4i+KQ/+FCqcBuNHymr51mD9hb6c8sYB7MCDCDFulR45vvfZJYoCz5iSJe2seDL9
         RXKzY4DJ4xtteprzADmWNTDb4bcBNTtqGy3C5fPNY4ffUjmDXj08QI4R5xwgG36406ZU
         LdL8xd03sWHIkv0gh/9nVVZkbZ0XOcdNhcuCgX4JOvvG3GsaBddAqUk6TjU76mK1JHT3
         P+ZEs8wyNlVDfa83NJTlgQu+nkg5iASr0kW4UbSkSeBiIYjCrVIig+jOrlmv4UUq9thU
         eEZA==
X-Gm-Message-State: AOAM530aLmWcWDt1vvLEjPZnIeJUQUt8VxWV8gL996wyMm3SucJIK0jo
        8zOufYeoQLrfF/cOI4SOst/Am5Uz2bS19o0ZJ2T1pA==
X-Google-Smtp-Source: ABdhPJz84jlXr9anlRfcH7bznaxARXahm8jLplstzadpXGTjLzE6JoxL+2ikoC0CBiJLHEbURQ7aKFjt29mbPwIgg1I=
X-Received: by 2002:a05:6602:2437:: with SMTP id g23mr22175708iob.5.1591085251496;
 Tue, 02 Jun 2020 01:07:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200523132155.14698-1-amir73il@gmail.com>
In-Reply-To: <20200523132155.14698-1-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 2 Jun 2020 11:07:20 +0300
Message-ID: <CAOQ4uxg+Omm0uR4uw+vf8P3_CZOZQgOqNAnWr9Gh-9SMqvSO5Q@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix out of bounds access warning in ovl_check_fb_len()
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, May 23, 2020 at 4:22 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> syzbot reported out of bounds memory access from open_by_handle_at()
> with a crafted file handle that looks like this:
>
>   { .handle_bytes = 2, .handle_type = OVL_FILEID_V1 }
>
> handle_bytes gets rounded down to 0 and we end up calling:
>   ovl_check_fh_len(fh, 0) => ovl_check_fb_len(fh + 3, -3)
>
> But fh buffer is only 2 bytes long, so accessing struct ovl_fb at
> fh + 3 is illegal.
>
> Fixes: cbe7fba8edfc ("ovl: make sure that real fid is 32bit aligned in memory")
> Reported-and-tested-by: syzbot+61958888b1c60361a791@syzkaller.appspotmail.com
> Cc: <stable@vger.kernel.org> # v5.5
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Miklos,
>

Ping.

> Another fallout from aligned file handle.
> This one seems like a warning that cannot lead to actual harm.
> As far as I can tell, with:
>
>   { .handle_bytes = 2, .handle_type = OVL_FILEID_V1 }
>
> kmalloc in handle_to_path() allocates 10 bytes, which means 16 bytes
> slab object, so all fields accessed by ovl_check_fh_len() should be
> within the slab object boundaries. And in any case, their value
> won't change the outcome of EINVAL.
>
> I have added this use case to the xfstest for checking the first bug,
> but it doesn't trigger any warning on my kernel (without KASAN) and
> returns EINVAL as expected.
>
> Thanks,
> Amir.
>
>  fs/overlayfs/overlayfs.h | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 76747f5b0517..ffbb57b2d7f6 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -355,6 +355,9 @@ int ovl_check_fb_len(struct ovl_fb *fb, int fb_len);
>
>  static inline int ovl_check_fh_len(struct ovl_fh *fh, int fh_len)
>  {
> +       if (fh_len < sizeof(struct ovl_fh))
> +               return -EINVAL;
> +
>         return ovl_check_fb_len(&fh->fb, fh_len - OVL_FH_WIRE_OFFSET);
>  }
>
> --
> 2.17.1
>
