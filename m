Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 700A9C4338F
	for <linux-unionfs@archiver.kernel.org>; Sat,  7 Aug 2021 16:37:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 450B061042
	for <linux-unionfs@archiver.kernel.org>; Sat,  7 Aug 2021 16:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbhHGQh3 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 7 Aug 2021 12:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhHGQh3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 7 Aug 2021 12:37:29 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA38FC0613CF
        for <linux-unionfs@vger.kernel.org>; Sat,  7 Aug 2021 09:37:11 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id 188so17088972ioa.8
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Aug 2021 09:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eDhoQAIC6jdXyjOzm2kDB2z8YYGlLxeFp/kyDK2MSH0=;
        b=FMcNzQvhtpXRFUxlFLkGFTH3VCRfOEQPOdQRdo+WH5pTknpVQHiEstMwjBpwqZYfwH
         AzDVUHo7/VldqeAk9PalDX3MDoNcw2/NULxOGwHDlmmz+MgUf+DKYkk7o96b+x+guPlb
         jvCi5Y8syWhLWWlVUBbrIp/31arWG1hYlU0aPh7N3UziEkvPZ3XiKj/KfIpO8XLiePTp
         aQTZewl+OOWVycJ5ldYxSs5l6N1nXGalcAQGUB68QD/IBwkhvB5MMJYJ+Po1rKCgi1c8
         oAonBPQTeM9cmh2tF8DTzbi/9V9RaNp/grXvXNQpOwPfiPVMlKfpRVPrBqTFl/fZHm4a
         9q3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eDhoQAIC6jdXyjOzm2kDB2z8YYGlLxeFp/kyDK2MSH0=;
        b=Hg2f5lV7ReBOdy7svd23BZ0umjJeuZubCcZYBtFtwpD0XacM0fr0zmCugcsAc8S2Xy
         AwhJli80++JGG+WFK27KoORct7Mjvb3tvZbzhJ8v4wQSRml/oRQdVVa2YH1TFYt4nlC3
         +bEh9C66XnpBD7yT02PnBntimHCOj+TgABX7f+okxlC0dfNXiMBagj2GaIsLqQ5MDrTh
         /WHkAr/fRlmIjCwcLyUqFTWu2cDRJBEAUCF9irG/DFHfPkx8uRVMDN4m9YMxrnDpymO9
         Ec7A9x2EZ0uVJCxMG4m601JhnBmi14RYfcFVhWIedt22Rd3wz4o7PVtw7T7pDvMGJ/+p
         1rDQ==
X-Gm-Message-State: AOAM532UFXMEsSnlVl8fThRnVHdQJJA7JyLw0b5EgtRrYLxTu6hsnYeQ
        IgGXcyiS7pqs3P59wtjPOkKVjBoTaVkHVIeSbCA=
X-Google-Smtp-Source: ABdhPJyg8yIoqPZ7TLSl4vOxpmEjhl0WYjpmUyc6dcq2XZ8XLPgogiRkxIJhdl/15BkpRBNtZUPnsdH1/OXe5L4h9g0=
X-Received: by 2002:a05:6638:1036:: with SMTP id n22mr14984572jan.81.1628354231340;
 Sat, 07 Aug 2021 09:37:11 -0700 (PDT)
MIME-Version: 1.0
References: <ec78de1b-4edb-1eea-5c0d-79e65f139d79@huawei.com> <CAOQ4uxiO7zt7sywNqyd-WwCVds9-NqRAixham9yVeN7F+JhXoA@mail.gmail.com>
In-Reply-To: <CAOQ4uxiO7zt7sywNqyd-WwCVds9-NqRAixham9yVeN7F+JhXoA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 7 Aug 2021 19:37:00 +0300
Message-ID: <CAOQ4uxhAGSPKx6xsa5w_Wn9sax8LQQ=dPhB7Dtn1XDwghNpgvg@mail.gmail.com>
Subject: Re: [QUESTION] Why overlayfs cannot mounted as nfs_export and metacopy?
To:     Zhihao Cheng <chengzhihao1@huawei.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Aug 7, 2021 at 2:05 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Sat, Aug 7, 2021 at 1:17 PM Zhihao Cheng <chengzhihao1@huawei.com> wrote:
> >
> > Hi, all.
> >
> > As title said. I wonder to know the reason for overlayfs mount failure
> > with '-o nfs_export=on,metacopy=on'.
> >
> > I modified kernel to enable these two options 'on',  it looks like that
> > overlayfs can still work fine under nfs_v4.
> >
> > Besides, I can get no more information about the reason from source
> > code, maybe I missed something.
> >
>
> It's because ovl_obtain_alias() (decoding a disconnected non-dir file handle)
> does not know how to construct a metacopy overlayfs inode.
>
> Maybe Vivek will be able to point you to the discussion that lead to making
> the features mutually exclusive.
>
> I don't remember any other reason.
>

I remembered some more details...

I think the main complication discussed w.r.t decoding a metacopy
inode was for the case where ovl_inode_lowerdata() differs from
ovl_inode_lower().

If we had a weaker variant of metacopy (e.g. metacopy=upper) that
only allows creating and following metacopy inodes in the upper layer,
it would have been simpler to implement ovl_obtain_alias().

Specifically, when ofs->numlayer == 2 (single lower layer), there can
be no valid metacopy inodes in the lower layer, so that configuration
should also be rather easy to support.

Basically, for ovl_obtain_alias():
- 'lowerpath' must not have metadata xattr
- 'upper_alias' must not have metadata xattr
- If 'index' has metacopy xattr, OVL_UPPERDATA flag
  should not be set on ovl inode

But there are bigger complications w.r.t disconnected dentry.
Overlayfs knows how to decode, work with and copy up
disconnected dentries (parent is unknown), but in ovl_link(old, ...),
'old' dentry must not be a disconnected metacopy dentry when
calling ovl_set_link_redirect() => ... ovl_get_redirect(), so we will
also need to:
- On copy up of a disconnected lower, do not use metacopy
- Copy up data before ovl_link() when nfs_export is enabled
- In ovl_obtain_alias(), if 'index' has redirect:
-- Verify that it is an absolute path that it is resolved to the
'lowerpath's inode
-- oip.redirect needs to be passed to ovl_get_inode()
-- ovl_verify_inode() needs to verify that oip.redirect matches
   redirect that is found on existing ovl inode

And probably other things that I am forgetting...

Thanks,
Amir.
