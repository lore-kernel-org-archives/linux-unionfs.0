Return-Path: <SRS0=h8cR=6T=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC6DC47247
	for <linux-unionfs@archiver.kernel.org>; Tue,  5 May 2020 18:15:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97B5D20663
	for <linux-unionfs@archiver.kernel.org>; Tue,  5 May 2020 18:15:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XhITRT+H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730615AbgEESPO (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 5 May 2020 14:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729315AbgEESPO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 5 May 2020 14:15:14 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA7DC061A0F;
        Tue,  5 May 2020 11:15:13 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id i16so3159232ils.12;
        Tue, 05 May 2020 11:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pjrvYcwwdk2nMIbGySYgWuQEXMvDJQT1UN96vH/RnKw=;
        b=XhITRT+Hh4vUEeTCYO09LVIHNdx2OF1TzvxNtbUYtZxFC1P+CcRVvH+xGXtpqvdF1E
         uSuWsj5WBTaAlJs9N7chEZxS4F8RnrKAfo81s/kPfgMq1OW7lmw6EsAETmUfy8gEfI49
         Nn2zqAoG7gQtbaplWhnClA7orkbu5su+NGmk9O8/Ishpwwv5raCXx/qTrV5LgF7sLLK2
         qXIGfSYPyV2rf+buoknRuxT6cvyrXO8JBQCBFn6UHavDOm438b0ElryMUILkJZnvVGzy
         bPlmth+5lE3exw3ytvUT3bHtRIaGA5HUn5x1T+V31KOn0UX0fzballBnB8DqbXh85/lX
         Fe7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pjrvYcwwdk2nMIbGySYgWuQEXMvDJQT1UN96vH/RnKw=;
        b=dhw2p8/Nej5FFC8YAjgATUyjBBQJACTk5SsTKKxlyVsOYz7irIXKyu05ZI04ERx+Wp
         /OW2Wv6ZDxZpCbKh44kjppsGT+XjK7tP3v5+17BjthYkU5zN81iJJVA+TNUDv7Bwv+w0
         h06LYWA2CJu3Pk70g6lp1YJwJxQSTU7dEcHnYKCNbJeV4mUWqyp0cr50R631jis8dWmQ
         +PXfq0lL+eHlUaQLBGrnKp/UW2Px77T61mTymb+yoglaDRVkiHY0fI02dGMu3lpf59Nk
         fLlHLOECd8coTP06XjvKlyl4qXzqjW1+r2BiR2M3t5bOzlRc7A6HnhG653bFKeVisKRo
         sSpw==
X-Gm-Message-State: AGi0PuZ2UhCCPFBixKjjtR3OP51vmySMGUefFR75ExY3PVNxlb3PufYX
        mvDv0lHlB2ngpJ89uku3yHC03pLKHyBHH7JIJn4=
X-Google-Smtp-Source: APiQypKpA8DL01sxi2j5auTLr+H5DquoW52m9k2HY/ykqs6biJdSifAMjKX+BDWcmz6gkdBLczbBEpQ2b+VThuZ5gF0=
X-Received: by 2002:a92:9e11:: with SMTP id q17mr5106885ili.137.1588702513314;
 Tue, 05 May 2020 11:15:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAOQ4uxj0F9V=FOUANKSATR2E==BoLr6OJMqsJe5QCbOLNR0k0A@mail.gmail.com>
 <20200505180734.GA47680@mwanda>
In-Reply-To: <20200505180734.GA47680@mwanda>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 5 May 2020 21:15:02 +0300
Message-ID: <CAOQ4uxhOi0H4ecJOc6emFc+bUhepscHF8qHywJQUzr-46H3+yw@mail.gmail.com>
Subject: Re: [PATCH] ovl: potential crash in ovl_fid_to_fh()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, May 5, 2020 at 9:07 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> The "buflen" value comes from the user and there is a potential that it
> could be zero.  In do_handle_to_path() we know that "handle->handle_bytes"
> is non-zero and we do:
>
>         handle_dwords = handle->handle_bytes >> 2;
>
> So values 1-3 become zero.  Then in ovl_fh_to_dentry() we do:
>
>         int len = fh_len << 2;
>
> So now len is in the "0,4-128" range and a multiple of 4.  But if
> "buflen" is zero it will try to copy negative bytes when we do the
> memcpy in ovl_fid_to_fh().
>
>         memcpy(&fh->fb, fid, buflen - OVL_FH_WIRE_OFFSET);
>
> And that will lead to a crash.  Thanks to Amir Goldstein for his help
> with this patch.
>
> Fixes: cbe7fba8edfc: ("ovl: make sure that real fid is 32bit aligned in memory")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  fs/overlayfs/export.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 475c61f53f0fe..0e58213ace6d7 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -776,6 +776,9 @@ static struct ovl_fh *ovl_fid_to_fh(struct fid *fid, int buflen, int fh_type)
>  {
>         struct ovl_fh *fh;
>
> +       if (buflen <= OVL_FH_WIRE_OFFSET)
> +               return ERR_PTR(-EINVAL);
> +

Sorry, I should have been more specific.
This check belongs after fh_type != OVL_FILEID_V0
because it is only relevant for OVL_FILEID_V0.
For OVL_FILEID_V1 len properly checked by ovl_check_fh_len().

Otherwise feel free to add:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>


Thanks,
Amir.
