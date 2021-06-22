Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09338C48BE5
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Jun 2021 15:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E86C26128E
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Jun 2021 15:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbhFVPMn (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 22 Jun 2021 11:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbhFVPMe (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Jun 2021 11:12:34 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3B5C06175F
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Jun 2021 08:10:16 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id 68so11397347vsu.6
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Jun 2021 08:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=o6jYECB1uY4kERwbwvQK62eKjskNIcvHqO/SelbLP+4=;
        b=pAN82221DIsUtrhb0p19lThHLu2emVpyjnLMrwRYEYMDXMZmJmomO2VGncVefPqeLk
         PnDv1mRg1xC4M0pPQpPSCfRUjwORrNe8KO6RCkK4uVhwO535jnc00YuKndimXSYZwRrL
         1qYgII3/HAmV7OjzDGHqcVLo+eR9flvdOJ94w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=o6jYECB1uY4kERwbwvQK62eKjskNIcvHqO/SelbLP+4=;
        b=f0H5Q5y860J7GrvDRFXiraEb2X/S5lP3dmu3hs1c1I1nbMBdF3kcYJTrWQ3OagrdTd
         VTXKeWQ8xexVO9O1NNbkfcUeYxWrUoVpNFbznarqSZUq/i/raufr8nA2elS8IUJS4mt7
         MYcdQpxu2D5Y40RyQQTq8eEXxd9LF+5sIopJtqC0sKB9rqjE6bx3INVabpplqYN069HV
         btIaCJ6oTLkk5rtO7eCt6h9Z5MbFRIAgUCfd1kLHDMQ3Wdzr17wJ9U7+nbeTlJqhPymK
         4GaYkjZfNB7tTXmAseWjifskjtJBwV51bCyTPX8cxmOvc1cLoQhv2BWhC2lvcGobgiX5
         h+zA==
X-Gm-Message-State: AOAM530xicZZPlAUzYrX9S2BSya6l3orEM7INSZKUx3sw59UxcdSKEPP
        dG4CDpDfjjxQ4o/KysUV66kAT79TrRyY4VeL57EmZA==
X-Google-Smtp-Source: ABdhPJzX7TH0X2nUVdZbCqZU8+z232mRwthdahvJ7HHQQYRERYGZF4uBl6yHl06y7O/o8Q4PJiqE+3iLP0fzGCmWnEM=
X-Received: by 2002:a67:bb14:: with SMTP id m20mr23694461vsn.0.1624374616050;
 Tue, 22 Jun 2021 08:10:16 -0700 (PDT)
MIME-Version: 1.0
References: <YNHXzBgzRrZu1MrD@miu.piliscsaba.redhat.com> <d73a5789-d233-940a-dc19-558b890f9b21@amd.com>
In-Reply-To: <d73a5789-d233-940a-dc19-558b890f9b21@amd.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 22 Jun 2021 17:10:05 +0200
Message-ID: <CAJfpegvTa9wnvCBP-vHumnDQ6f3XWb5vD6Fnpjbrj1V5N8QRig@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix mmap denywrite
To:     =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 22 Jun 2021 at 14:43, Christian K=C3=B6nig <christian.koenig@amd.co=
m> wrote:
>
> Am 22.06.21 um 14:30 schrieb Miklos Szeredi:
> > Overlayfs did not honor positive i_writecount on realfile for VM_DENYWR=
ITE
> > mappings.  Similarly negative i_mmap_writable counts were ignored for
> > VM_SHARED mappings.
> >
> > Fix by making vma_set_file() switch the temporary counts obtained and
> > released by mmap_region().
>
> Mhm, I don't fully understand the background but that looks like
> something specific to overlayfs to me.
>
> So why are you changing the common helper?

Need to hold the temporary counts until the final ones are obtained in
vma_link(), which is out of overlayfs' scope.

Thanks,
Miklos
